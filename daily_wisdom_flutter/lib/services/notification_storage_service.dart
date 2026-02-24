import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_item.dart';

class NotificationStorageService {
  static const String _notificationsKey = 'notification_history';
  static const int _maxStoredNotifications = 100;

  /// Save a notification to history.
  Future<void> addNotification(NotificationItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getNotifications();
    items.insert(0, item); // newest first

    // Keep only the most recent items
    final trimmed = items.length > _maxStoredNotifications
        ? items.sublist(0, _maxStoredNotifications)
        : items;

    await prefs.setString(
      _notificationsKey,
      NotificationItem.encodeList(trimmed),
    );
  }

  /// Get all stored notifications (newest first), only past ones.
  Future<List<NotificationItem>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final all = NotificationItem.decodeList(raw);
      final now = DateTime.now();
      // Only return notifications whose scheduled time has passed
      return all.where((n) => !n.scheduledAt.isAfter(now)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Get count of unread notifications.
  Future<int> getUnreadCount() async {
    final items = await getNotifications();
    return items.where((n) => !n.isRead).length;
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final all = NotificationItem.decodeList(raw);
      final updated = all.map((n) => n.copyWith(isRead: true)).toList();
      await prefs.setString(
        _notificationsKey,
        NotificationItem.encodeList(updated),
      );
    } catch (_) {}
  }

  /// Mark a single notification as read by quoteId and scheduledAt.
  Future<void> markAsRead(int quoteId, DateTime scheduledAt) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final all = NotificationItem.decodeList(raw);
      final updated = all.map((n) {
        if (n.quoteId == quoteId &&
            n.scheduledAt.isAtSameMomentAs(scheduledAt)) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      await prefs.setString(
        _notificationsKey,
        NotificationItem.encodeList(updated),
      );
    } catch (_) {}
  }

  /// Delete a single notification by quoteId and scheduledAt.
  Future<void> deleteNotification(int quoteId, DateTime scheduledAt) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final all = NotificationItem.decodeList(raw);
      all.removeWhere(
        (n) =>
            n.quoteId == quoteId &&
            n.scheduledAt.isAtSameMomentAs(scheduledAt),
      );
      await prefs.setString(
        _notificationsKey,
        NotificationItem.encodeList(all),
      );
    } catch (_) {}
  }

  /// Clear all notification history.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }
}
