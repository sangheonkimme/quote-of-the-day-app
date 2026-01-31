import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFavoritesTap;

  const AppHeader({
    super.key,
    this.onNotificationTap,
    this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();

    // Date format: "Thursday, Jan 23" (en) or "1월 23일 목요일" (ko)
    final dateFormat = locale == 'ko'
        ? DateFormat('M월 d일 EEEE', 'ko')
        : DateFormat('EEEE, MMM d', 'en');
    final formattedDate = dateFormat.format(now);

    return Padding(
      // px-6 py-4 → horizontal 24, vertical 16
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing24,
        vertical: AppDimensions.spacing16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Title and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text-lg font-semibold text-foreground
              Text(
                locale == 'ko' ? '오늘의 명언' : 'Daily Wisdom',
                style: const TextStyle(
                  fontSize: AppTypography.textLg,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              // text-xs text-muted-foreground
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: AppTypography.textXs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),

          // Right: Icon Buttons
          Row(
            children: [
              // Bell Button - w-10 h-10 rounded-full, ghost style
              _GhostIconButton(
                icon: LucideIcons.bell,
                onTap: onNotificationTap,
                semanticLabel: 'Notifications',
              ),
              const SizedBox(width: AppDimensions.spacing8), // gap-2
              // Favorites Button
              _GhostIconButton(
                icon: LucideIcons.heart,
                onTap: onFavoritesTap,
                semanticLabel: 'Favorites',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GhostIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  const _GhostIconButton({
    required this.icon,
    this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.buttonSizeSm / 2),
        child: Container(
          width: AppDimensions.buttonSizeSm, // 40px
          height: AppDimensions.buttonSizeSm, // 40px
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: AppDimensions.iconMd, // 20px
            color: AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
