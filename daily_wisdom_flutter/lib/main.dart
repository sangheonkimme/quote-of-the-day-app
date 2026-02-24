import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/theme.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

/// Global navigator key for push notification navigation.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only await lightweight, essential initialization.
  try {
    await initializeDateFormatting('en', null);
    await initializeDateFormatting('ko', null);
  } catch (_) {
    // Date formatting is non-critical; continue even if it fails.
  }

  // Fire-and-forget: initialize ads in the background (non-blocking).
  MobileAds.instance.initialize().then((_) {}).catchError((_) {});

  // Fire-and-forget: initialize notifications in the background.
  _initNotifications();

  runApp(const DailyWisdomApp());
}

/// Initialize notification service and sync daily quotes in the background.
/// Also sets up the notification tap handler.
Future<void> _initNotifications() async {
  try {
    await NotificationService.instance.initialize(
      onNotificationTap: _handleNotificationTap,
    );
    final systemLocale =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    await NotificationService.instance.syncDailyQuoteNotifications(
      locale: systemLocale,
    );
  } catch (_) {
    // Notification init failure should never block or crash the app.
  }
}

/// Handle when user taps a push notification from the system tray.
void _handleNotificationTap(String? payload) {
  if (payload == null) return;
  final quoteId = int.tryParse(payload);
  if (quoteId == null) return;

  // Navigate to home screen with the specific quote
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => HomeScreen(initialQuoteId: quoteId),
    ),
    (route) => false,
  );
}

class DailyWisdomApp extends StatelessWidget {
  const DailyWisdomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Daily Wisdom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ko')],
      home: const HomeScreen(),
    );
  }
}
