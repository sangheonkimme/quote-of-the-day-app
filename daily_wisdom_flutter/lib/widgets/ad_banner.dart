import 'package:flutter/material.dart';
import '../config/theme.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      // mx-6 mb-4 → horizontal 24, bottom 16
      padding: const EdgeInsets.only(
        left: AppDimensions.spacing24,
        right: AppDimensions.spacing24,
        bottom: AppDimensions.spacing16,
      ),
      child: Container(
        // bg-secondary rounded-xl p-4 text-center border border-border
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd), // 12px
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // text-[10px] text-muted-foreground uppercase tracking-wider mb-1
            Text(
              locale == 'ko' ? '광고' : 'ADVERTISEMENT',
              style: TextStyle(
                fontSize: AppTypography.text10, // 10px
                fontWeight: FontWeight.w400,
                color: AppColors.mutedForeground,
                letterSpacing: AppTypography.trackingWider, // 0.5
              ),
            ),
            const SizedBox(height: AppDimensions.spacing4), // mb-1

            // h-12 flex items-center justify-center
            SizedBox(
              height: AppDimensions.iconXl, // 48px
              child: Center(
                // text-xs text-muted-foreground
                child: Text(
                  locale == 'ko'
                      ? '광고 영역 - AdMob / Google Ads'
                      : 'Ad space - AdMob / Google Ads',
                  style: const TextStyle(
                    fontSize: AppTypography.textXs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
