import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/quote.dart';
import '../utils/text_utils.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final bool isAnimating;

  const QuoteCard({
    super.key,
    required this.quote,
    this.isAnimating = false,
  });

  @override
  Widget build(BuildContext context) {
    // Always use larger font size (24sp) for mobile as shown in design
    const quoteFontSize = AppTypography.text2xl;

    return Center(
      child: AnimatedOpacity(
        opacity: isAnimating ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: isAnimating ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxWidthMd,
            ),
            padding: const EdgeInsets.all(AppDimensions.spacing32),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quote Icon - larger size (48px) to match design
                SizedBox(
                  width: 48,
                  height: 48,
                  child: SvgPicture.asset(
                    'assets/icons/quote.svg',
                    colorFilter: ColorFilter.mode(
                      AppColors.mutedForeground.withValues(alpha: 0.3),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24),

                // Quote Text - 24sp as shown in design
                Text(
                  keepWordsTogether(quote.text),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: quoteFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.foreground,
                    height: AppTypography.leadingRelaxed,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24),

                // Author & Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author - 16sp bold
                    Text(
                      quote.author,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing4),
                    // Category - 14sp
                    Text(
                      quote.category,
                      style: const TextStyle(
                        fontSize: AppTypography.textSm,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
