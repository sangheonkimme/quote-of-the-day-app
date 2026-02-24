import 'dart:convert';

class NotificationItem {
  final int quoteId;
  final String title;
  final String body;
  final DateTime scheduledAt;
  final bool isRead;

  const NotificationItem({
    required this.quoteId,
    required this.title,
    required this.body,
    required this.scheduledAt,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      quoteId: quoteId,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() => {
        'quoteId': quoteId,
        'title': title,
        'body': body,
        'scheduledAt': scheduledAt.toIso8601String(),
        'isRead': isRead,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      quoteId: json['quoteId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  static String encodeList(List<NotificationItem> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  static List<NotificationItem> decodeList(String source) {
    final list = jsonDecode(source) as List;
    return list
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
