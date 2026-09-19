import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/quote.dart';
import '../utils/text_utils.dart';

/// Quote layout rendered off-screen into the image that gets shared.
///
/// Laid out at [size] logical pixels; captured at 3x for a 1080x1350
/// (4:5, Instagram feed friendly) PNG.
class ShareCard extends StatelessWidget {
  static const Size size = Size(360, 450);
  static const String appIconAsset = 'assets/icons/icon.png';

  final Quote quote;
  final String appName;

  const ShareCard({super.key, required this.quote, required this.appName});

  /// Shorter quotes get bigger type; FittedBox below is the safety net.
  static double _quoteFontSize(String text) {
    final length = text.characters.length;
    if (length <= 40) return 30;
    if (length <= 80) return 26;
    if (length <= 130) return 22;
    return 19;
  }

  static TextStyle quoteStyle(String text) => GoogleFonts.playfairDisplay(
    fontSize: _quoteFontSize(text),
    fontWeight: FontWeight.w400,
    color: AppColors.foreground,
    height: 1.45,
  );

  static TextStyle get authorStyle => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.foreground,
  );

  static TextStyle get metaStyle => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedForeground,
  );

  @override
  Widget build(BuildContext context) {
    const outerPadding = 24.0;
    const innerPadding = 28.0;
    const textWidth = 360 - 2 * (outerPadding + innerPadding);

    // Keep the layout fixed regardless of the user's system text size.
    return MediaQuery.withNoTextScaling(
      child: Container(
        width: size.width,
        height: size.height,
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(
          outerPadding,
          outerPadding,
          outerPadding,
          16,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(innerPadding),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 56,
                        height: 0.9,
                        color: AppColors.mutedForeground.withValues(alpha: 0.3),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: textWidth,
                            child: Text(
                              keepWordsTogether(quote.text),
                              style: quoteStyle(quote.text),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    Text(quote.author, style: authorStyle),
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(quote.category, style: metaStyle),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(appIconAsset, width: 20, height: 20),
                ),
                const SizedBox(width: AppDimensions.spacing8),
                Text(appName, style: metaStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
