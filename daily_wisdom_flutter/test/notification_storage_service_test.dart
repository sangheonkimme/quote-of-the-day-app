import 'package:daily_wisdom_flutter/models/notification_item.dart';
import 'package:daily_wisdom_flutter/services/notification_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

NotificationItem _item(int id, DateTime at) => NotificationItem(
      quoteId: id,
      title: 't',
      body: 'b',
      scheduledAt: at,
    );

void main() {
  late NotificationStorageService storage;
  final now = DateTime.now();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = NotificationStorageService();
  });

  test('delivered items stay visible even when many are upcoming', () async {
    await storage.addNotification(_item(1, now.subtract(const Duration(days: 1))));
    await storage.replaceUpcoming([
      for (int i = 1; i <= 150; i++) _item(100 + i, now.add(Duration(days: i))),
    ]);

    final visible = await storage.getNotifications();
    expect(visible.map((n) => n.quoteId), [1]);
  });

  test('replaceUpcoming keeps history and swaps only upcoming items', () async {
    await storage.addNotification(_item(1, now.subtract(const Duration(days: 2))));
    await storage.replaceUpcoming([_item(2, now.add(const Duration(days: 1)))]);
    await storage.replaceUpcoming([_item(3, now.add(const Duration(days: 1)))]);
    await storage.replaceUpcoming([]);

    await storage.addNotification(_item(4, now.subtract(const Duration(days: 1))));
    final visible = await storage.getNotifications();
    expect(visible.map((n) => n.quoteId), [4, 1]);
  });

  test('delivered history is capped at 100, newest kept', () async {
    for (int i = 0; i < 120; i++) {
      await storage.addNotification(
          _item(i, now.subtract(Duration(days: 120 - i))));
    }
    final visible = await storage.getNotifications();
    expect(visible.length, 100);
    expect(visible.first.quoteId, 119);
    expect(visible.last.quoteId, 20);
  });

  test('markAllAsRead does not pre-mark upcoming items', () async {
    await storage.addNotification(_item(1, now.subtract(const Duration(hours: 1))));
    await storage.replaceUpcoming(
        [_item(2, now.add(const Duration(milliseconds: 300)))]);
    await storage.markAllAsRead();
    expect(await storage.getUnreadCount(), 0);

    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(await storage.getUnreadCount(), 1);
  });
}
