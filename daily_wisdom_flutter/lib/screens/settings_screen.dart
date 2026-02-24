import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../services/notification_service.dart';
import 'favorites_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  final NotificationService _notificationService = NotificationService.instance;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled =
          prefs.getBool(NotificationService.notificationsEnabledKey) ?? false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final locale = Localizations.localeOf(context).languageCode;
    final normalizedLocale = locale == 'ko' ? 'ko' : 'en';

    if (value) {
      final enabled = await _notificationService.enableDailyQuoteNotifications(
        locale: normalizedLocale,
      );
      if (!mounted) {
        return;
      }

      if (!enabled) {
        setState(() {
          _notificationsEnabled = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              locale == 'ko'
                  ? '알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.'
                  : 'Notification permission is required. Please allow it in settings.',
            ),
          ),
        );
        return;
      }
    } else {
      await _notificationService.disableDailyQuoteNotifications();
      if (!mounted) {
        return;
      }
    }

    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _sendDebugNotification() async {
    final locale = Localizations.localeOf(context).languageCode;
    final normalizedLocale = locale == 'ko' ? 'ko' : 'en';
    final scheduled = await _notificationService
        .scheduleDebugNotificationIn10Seconds(locale: normalizedLocale);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          scheduled
              ? (locale == 'ko'
                    ? '10초 후 테스트 알림이 예약되었습니다.'
                    : 'Test notification scheduled in 10 seconds.')
              : (locale == 'ko'
                    ? '알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.'
                    : 'Notification permission is required. Please allow it in settings.'),
        ),
      ),
    );
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
          locale == 'ko' ? '설정' : 'Settings',
          style: const TextStyle(
            fontSize: AppTypography.textLg,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Favorites Section
          _SectionHeader(title: locale == 'ko' ? '좋아요' : 'Favorites'),
          _SettingsItem(
            icon: LucideIcons.heart,
            title: locale == 'ko' ? '좋아요한 명언' : 'Favorite Quotes',
            subtitle: locale == 'ko'
                ? '저장한 명언을 모아보세요'
                : 'View your saved quotes',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: AppDimensions.spacing16),

          // Notifications Section
          _SectionHeader(title: locale == 'ko' ? '알림 설정' : 'Notifications'),
          _SettingsToggleItem(
            icon: LucideIcons.bell,
            title: locale == 'ko' ? '매일 알림 받기' : 'Daily Notifications',
            subtitle: locale == 'ko'
                ? '매일 아침 오늘의 명언을 알림으로 받아보세요'
                : 'Get daily quote notifications every morning',
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          if (kDebugMode) ...[
            _SettingsItem(
              icon: Icons.bug_report_outlined,
              title: locale == 'ko' ? '10초 후 테스트 알림' : 'Test in 10 Seconds',
              subtitle: locale == 'ko'
                  ? '디버그 전용: 랜덤 명언 알림을 10초 후 발송'
                  : 'Debug only: send a random quote notification in 10 seconds',
              onTap: _sendDebugNotification,
            ),
          ],

          const SizedBox(height: AppDimensions.spacing16),

          // Info Section
          _SectionHeader(title: locale == 'ko' ? '정보' : 'Information'),
          _SettingsItem(
            icon: LucideIcons.shield,
            title: locale == 'ko' ? '개인정보처리방침' : 'Privacy Policy',
            onTap: () async {
              final url = Uri.parse(
                'https://quote-of-the-day-app-ten.vercel.app/privacy',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          _SettingsInfoItem(
            icon: LucideIcons.info,
            title: locale == 'ko' ? '앱 버전' : 'App Version',
            value: '1.2.0',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacing24,
        AppDimensions.spacing16,
        AppDimensions.spacing24,
        AppDimensions.spacing8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppTypography.textSm,
          fontWeight: FontWeight.w500,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(icon, size: 20, color: AppColors.foreground),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppTypography.textBase,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: AppTypography.textXs,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, size: 20, color: AppColors.foreground),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTypography.textBase,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: AppTypography.textXs,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.foreground,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SettingsInfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppDimensions.spacing16,
        right: AppDimensions.spacing16,
        top: AppDimensions.spacing8,
      ),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, size: 20, color: AppColors.foreground),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppTypography.textBase,
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppTypography.textSm,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
