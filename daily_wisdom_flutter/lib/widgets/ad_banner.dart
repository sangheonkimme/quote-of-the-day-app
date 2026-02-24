import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/theme.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadFailed = false;

  // Production Ad Unit ID
  static const String _adUnitId = 'ca-app-pub-6553106832525632/6378216132';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    try {
      _bannerAd = BannerAd(
        adUnitId: _adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('BannerAd failed to load: $error');
            ad.dispose();
            if (mounted) {
              setState(() {
                _loadFailed = true;
              });
            }
          },
        ),
      )..load();
    } catch (e) {
      debugPrint('Ad initialization failed: $e');
      _loadFailed = true;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide the ad area entirely if loading failed.
    if (_loadFailed) {
      return const SizedBox.shrink();
    }

    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.spacing24,
        right: AppDimensions.spacing24,
        bottom: AppDimensions.spacing16,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing8),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale == 'ko' ? '광고' : 'ADVERTISEMENT',
              style: TextStyle(
                fontSize: AppTypography.text10,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedForeground,
                letterSpacing: AppTypography.trackingWider,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing4),
            if (_isLoaded && _bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            else
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    locale == 'ko' ? '광고 로딩 중...' : 'Loading ad...',
                    style: const TextStyle(
                      fontSize: AppTypography.textXs,
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
