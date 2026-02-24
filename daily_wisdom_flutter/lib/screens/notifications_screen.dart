import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../config/theme.dart';
import '../models/notification_item.dart';
import '../services/notification_storage_service.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationStorageService _storage = NotificationStorageService();
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final items = await _storage.getNotifications();
    // Mark all as read when the screen is opened
    await _storage.markAllAsRead();
    if (mounted) {
      setState(() {
        _notifications = items;
        _isLoading = false;
      });
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notifDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(notifDay).inDays;

    if (diff == 0) {
      return locale == 'ko' ? '오늘' : 'Today';
    } else if (diff == 1) {
      return locale == 'ko' ? '어제' : 'Yesterday';
    } else if (diff < 7) {
      return locale == 'ko' ? '$diff일 전' : '${diff}d ago';
    } else {
      final format =
          locale == 'ko' ? DateFormat('M월 d일', 'ko') : DateFormat('MMM d');
      return format.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          locale == 'ko' ? '알림' : 'Notifications',
          style: const TextStyle(
            fontSize: AppTypography.textLg,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState(locale)
              : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState(String locale) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bellOff,
              size: 64,
              color: AppColors.mutedForeground.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              locale == 'ko' ? '아직 받은 알림이 없습니다' : 'No notifications yet',
              style: const TextStyle(
                fontSize: AppTypography.textBase,
                color: AppColors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              locale == 'ko'
                  ? '설정에서 매일 알림을 켜보세요'
                  : 'Turn on daily notifications in settings',
              style: TextStyle(
                fontSize: AppTypography.textSm,
                color: AppColors.mutedForeground.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    final locale = Localizations.localeOf(context).languageCode;

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final item = _notifications[index];
        return Dismissible(
          key: ValueKey('${item.quoteId}_${item.scheduledAt.toIso8601String()}'),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: AppColors.heartRed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(
              LucideIcons.trash2,
              color: Colors.white,
              size: 22,
            ),
          ),
          onDismissed: (_) {
            final removedItem = _notifications[index];
            setState(() => _notifications.removeAt(index));
            _storage.deleteNotification(
              removedItem.quoteId,
              removedItem.scheduledAt,
            );
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  locale == 'ko' ? '알림이 삭제되었습니다' : 'Notification deleted',
                ),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: locale == 'ko' ? '되돌리기' : 'Undo',
                  onPressed: () {
                    setState(() => _notifications.insert(index, removedItem));
                    _storage.addNotification(removedItem);
                  },
                ),
              ),
            );
          },
          child: _NotificationCard(
            item: item,
            dateLabel: _formatDate(context, item.scheduledAt),
            onTap: () {
              Navigator.pop(context, item.quoteId);
            },
          ),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final String dateLabel;
  final VoidCallback? onTap;

  const _NotificationCard({
    required this.item,
    required this.dateLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.card : AppColors.secondary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: item.isRead
                ? AppColors.border
                : AppColors.foreground.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bell icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.isRead
                    ? AppColors.background
                    : AppColors.foreground.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                LucideIcons.bell,
                size: 18,
                color: item.isRead
                    ? AppColors.mutedForeground
                    : AppColors.foreground,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: AppTypography.textSm,
                          fontWeight:
                              item.isRead ? FontWeight.w500 : FontWeight.w700,
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontSize: AppTypography.textXs,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.body,
                    style: const TextStyle(
                      fontSize: AppTypography.textSm,
                      color: AppColors.foreground,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Unread dot + chevron
            const SizedBox(width: 4),
            Column(
              children: [
                if (!item.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.heartRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.mutedForeground.withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
