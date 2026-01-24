import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/quote.dart';

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
    final quoteFontSize = AppTheme.getQuoteFontSize(context);

    return Center(
      child: AnimatedOpacity(
        opacity: isAnimating ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 500), // duration-500
        curve: Curves.easeOut, // ease-out
        child: AnimatedScale(
          scale: isAnimating ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxWidthMd, // max-w-md = 448px
            ),
            padding: const EdgeInsets.all(AppDimensions.spacing32), // p-8
            decoration: BoxDecoration(
              color: AppColors.card, // bg-card
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg), // rounded-2xl
              border: Border.all(color: AppColors.border), // border border-border
              boxShadow: AppShadows.shadowSm, // shadow-sm
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quote Icon (") - SVG
                // w-10 h-10 text-muted-foreground/30
                SizedBox(
                  width: AppDimensions.iconLg, // 40px
                  height: AppDimensions.iconLg, // 40px
                  child: SvgPicture.asset(
                    'assets/icons/quote.svg',
                    colorFilter: ColorFilter.mode(
                      AppColors.mutedForeground.withValues(alpha: 0.3), // /30
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24), // mb-6

                // Quote Text
                // text-xl md:text-2xl font-serif leading-relaxed text-foreground
                Text(
                  quote.text,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: quoteFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.foreground,
                    height: AppTypography.leadingRelaxed,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24), // mb-6

                // Author & Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // text-sm font-medium text-foreground
                        Text(
                          quote.author,
                          style: const TextStyle(
                            fontSize: AppTypography.textSm,
                            fontWeight: FontWeight.w500,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing2), // mt-0.5
                        // text-xs text-muted-foreground
                        Text(
                          quote.category,
                          style: const TextStyle(
                            fontSize: AppTypography.textXs,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
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
