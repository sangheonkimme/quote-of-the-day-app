import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/notification_item.dart';
import 'notification_storage_service.dart';
import 'quote_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String notificationsEnabledKey = 'notifications_enabled';

  static const int _dailyNotificationHour = 8;
  static const int _notificationIdBase = 8000;
  static const int _daysToSchedule = 365;
  static const int _debugNotificationId = 9000;
  static const String _channelId = 'daily_quote_channel';
  static const String _channelName = 'Daily Quote';
  static const String _channelDescription =
      'Daily inspirational quote notifications';
  static const NotificationDetails _defaultNotificationDetails =
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Random _random = Random();

  bool _isInitialized = false;

  Future<void> initialize({
    void Function(String?)? onNotificationTap,
  }) async {
    if (_isInitialized) {
      return;
    }

    tzdata.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap != null
          ? (NotificationResponse response) {
              onNotificationTap(response.payload);
            }
          : null,
    );
    _isInitialized = true;
  }

  Future<void> syncDailyQuoteNotifications({required String locale}) async {
    try {
      await initialize();
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(notificationsEnabledKey) ?? false;
      if (!enabled) {
        await _cancelScheduledDailyQuoteNotifications();
        return;
      }

      final alreadyScheduled = await _hasScheduledDailyQuotes();
      if (!alreadyScheduled) {
        await _scheduleDailyQuoteNotifications(locale: locale);
      }
    } catch (e) {
      debugPrint('syncDailyQuoteNotifications failed: $e');
    }
  }

  Future<bool> enableDailyQuoteNotifications({required String locale}) async {
    await initialize();
    final granted = await _requestPermissionsIfNeeded();
    if (!granted) {
      return false;
    }

    await _scheduleDailyQuoteNotifications(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationsEnabledKey, true);
    return true;
  }

  Future<void> disableDailyQuoteNotifications() async {
    await initialize();
    await _cancelScheduledDailyQuoteNotifications();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationsEnabledKey, false);
  }

  Future<bool> scheduleDebugNotificationIn10Seconds({
    required String locale,
  }) async {
    return scheduleDebugNotification(
      locale: locale,
      delay: const Duration(seconds: 10),
    );
  }

  Future<bool> scheduleDebugNotification({
    required String locale,
    Duration delay = const Duration(seconds: 10),
  }) async {
    await initialize();
    final granted = await _requestPermissionsIfNeeded();
    if (!granted) {
      return false;
    }

    final normalizedLocale = locale == 'ko' ? 'ko' : 'en';
    final quoteService = QuoteService(locale: normalizedLocale);
    final quotes = quoteService.getAllQuotes();
    if (quotes.isEmpty) {
      return false;
    }

    final quote = quotes[_random.nextInt(quotes.length)];
    final scheduledDate = tz.TZDateTime.from(
      DateTime.now().add(delay).toUtc(),
      tz.UTC,
    );
    final title = normalizedLocale == 'ko' ? '테스트 알림' : 'Test Notification';
    final body = '"${quote.text}" - ${quote.author}';

    await _plugin.cancel(_debugNotificationId);
    await _plugin.zonedSchedule(
      _debugNotificationId,
      title,
      body,
      scheduledDate,
      _defaultNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: quote.id.toString(),
    );

    // Save to notification history so it appears in the inbox
    final storage = NotificationStorageService();
    await storage.addNotification(NotificationItem(
      quoteId: quote.id,
      title: title,
      body: body,
      scheduledAt: DateTime.now(), // Use current time so it shows immediately
    ));
    return true;
  }

  Future<bool> _requestPermissionsIfNeeded() async {
    bool granted = true;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      granted = (await android.requestNotificationsPermission()) ?? true;
    }

    final iOS = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iOS != null) {
      final iosGranted = await iOS.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = granted && (iosGranted ?? false);
    }

    final macOS = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macOS != null) {
      final macGranted = await macOS.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = granted && (macGranted ?? false);
    }

    return granted;
  }

  Future<bool> _hasScheduledDailyQuotes() async {
    final pending = await _plugin.pendingNotificationRequests();
    final maxId = _notificationIdBase + _daysToSchedule;
    return pending.any(
      (request) => request.id >= _notificationIdBase && request.id < maxId,
    );
  }

  Future<void> _scheduleDailyQuoteNotifications({
    required String locale,
  }) async {
    await _cancelScheduledDailyQuoteNotifications();

    final normalizedLocale = locale == 'ko' ? 'ko' : 'en';
    final quoteService = QuoteService(locale: normalizedLocale);
    final quotes = quoteService.getAllQuotes();
    final firstScheduleDate = _nextEightAm();
    final storage = NotificationStorageService();

    // Clear old notification history before scheduling new ones
    await storage.clearAll();

    for (int i = 0; i < _daysToSchedule; i++) {
      final localDate = firstScheduleDate.add(Duration(days: i));
      final quote = quotes[_random.nextInt(quotes.length)];
      final scheduledDate = tz.TZDateTime.from(localDate.toUtc(), tz.UTC);
      final title = normalizedLocale == 'ko' ? '오늘의 명언' : 'Daily Wisdom';
      final body = '"${quote.text}" - ${quote.author}';

      await _plugin.zonedSchedule(
        _notificationIdBase + i,
        title,
        body,
        scheduledDate,
        _defaultNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: quote.id.toString(),
      );

      // Save to notification history for the inbox
      await storage.addNotification(NotificationItem(
        quoteId: quote.id,
        title: title,
        body: body,
        scheduledAt: localDate,
      ));
    }
  }

  Future<void> _cancelScheduledDailyQuoteNotifications() async {
    for (int i = 0; i < _daysToSchedule; i++) {
      await _plugin.cancel(_notificationIdBase + i);
    }
  }

  DateTime _nextEightAm() {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, _dailyNotificationHour);
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }
}
