import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_item.dart';

/// Stores the in-app notification inbox.
///
/// The list holds both delivered items (scheduledAt in the past) and upcoming
/// items of the current schedule window. Only delivered items are exposed to
/// the UI; upcoming items become visible once their time passes.
class NotificationStorageService {
  static const String _notificationsKey = 'notification_history';
  static const int _maxStoredNotifications = 100;

  /// Save a single notification to history.
  Future<void> addNotification(NotificationItem item) async {
    final all = await _loadAll();
    all.add(item);
    await _saveAll(all);
  }

  /// Replace all not-yet-delivered items with [upcoming], keeping delivered
  /// history intact. Pass an empty list to drop upcoming items.
  Future<void> replaceUpcoming(List<NotificationItem> upcoming) async {
    final now = DateTime.now();
    final delivered =
        (await _loadAll()).where((n) => !n.scheduledAt.isAfter(now)).toList();
    await _saveAll([...delivered, ...upcoming]);
  }

  /// Get delivered notifications (newest first).
  Future<List<NotificationItem>> getNotifications() async {
    final now = DateTime.now();
    return (await _loadAll())
        .where((n) => !n.scheduledAt.isAfter(now))
        .toList();
  }

  /// Get count of unread notifications.
  Future<int> getUnreadCount() async {
    final items = await getNotifications();
    return items.where((n) => !n.isRead).length;
  }

  /// Mark all delivered notifications as read.
  Future<void> markAllAsRead() async {
    final now = DateTime.now();
    final all = await _loadAll();
    await _saveAll(all
        .map((n) => n.scheduledAt.isAfter(now) ? n : n.copyWith(isRead: true))
        .toList());
  }

  /// Mark a single notification as read by quoteId and scheduledAt.
  Future<void> markAsRead(int quoteId, DateTime scheduledAt) async {
    final all = await _loadAll();
    await _saveAll(all
        .map((n) => _matches(n, quoteId, scheduledAt)
            ? n.copyWith(isRead: true)
            : n)
        .toList());
  }

  /// Delete a single notification by quoteId and scheduledAt.
  Future<void> deleteNotification(int quoteId, DateTime scheduledAt) async {
    final all = await _loadAll();
    all.removeWhere((n) => _matches(n, quoteId, scheduledAt));
    await _saveAll(all);
  }

  /// Clear all notification history.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }

  bool _matches(NotificationItem n, int quoteId, DateTime scheduledAt) =>
      n.quoteId == quoteId && n.scheduledAt.isAtSameMomentAs(scheduledAt);

  Future<List<NotificationItem>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      return NotificationItem.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  /// Sort newest first and cap delivered history at [_maxStoredNotifications].
  /// Upcoming items are never trimmed.
  Future<void> _saveAll(List<NotificationItem> items) async {
    final now = DateTime.now();
    items.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    final upcoming = items.where((n) => n.scheduledAt.isAfter(now));
    final delivered = items
        .where((n) => !n.scheduledAt.isAfter(now))
        .take(_maxStoredNotifications);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _notificationsKey,
      NotificationItem.encodeList([...upcoming, ...delivered]),
    );
  }
}
