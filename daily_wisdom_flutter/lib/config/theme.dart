import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design specs from globals.css (OKLCH → HEX conversion)
class AppColors {
  // Light Theme Colors
  static const Color background = Color(0xFFFAFAFA);      // oklch(0.985 0 0)
  static const Color foreground = Color(0xFF171717);      // oklch(0.145 0 0)
  static const Color card = Color(0xFFFFFFFF);            // oklch(1 0 0)
  static const Color cardForeground = Color(0xFF171717);  // oklch(0.145 0 0)
  static const Color secondary = Color(0xFFF5F5F5);       // oklch(0.96 0 0)
  static const Color muted = Color(0xFFF5F5F5);           // oklch(0.96 0 0)
  static const Color mutedForeground = Color(0xFF737373); // oklch(0.45 0 0)
  static const Color border = Color(0xFFE5E5E5);          // oklch(0.91 0 0)

  // Additional Colors
  static const Color heartRed = Color(0xFFEF4444);        // Tailwind red-500
  static const Color checkGreen = Color(0xFF16A34A);      // Tailwind green-600
}

/// Design dimensions from Tailwind classes
class AppDimensions {
  // Spacing
  static const double spacing2 = 2.0;    // mt-0.5
  static const double spacing4 = 4.0;    // mb-1
  static const double spacing8 = 8.0;    // gap-2
  static const double spacing12 = 12.0;  // gap-3
  static const double spacing16 = 16.0;  // p-4, mb-4
  static const double spacing24 = 24.0;  // px-6, mb-6
  static const double spacing32 = 32.0;  // p-8, mt-8

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;   // rounded-xl
  static const double radiusLg = 16.0;   // rounded-2xl
  static const double radiusFull = 9999.0;

  // Icon Sizes
  static const double iconSm = 16.0;     // w-4 h-4
  static const double iconMd = 20.0;     // w-5 h-5
  static const double iconLg = 40.0;     // w-10 h-10
  static const double iconXl = 48.0;     // w-12 h-12

  // Button Sizes
  static const double buttonSizeSm = 40.0;  // w-10 h-10
  static const double buttonSizeLg = 48.0;  // w-12 h-12
  static const double buttonHeightLg = 44.0; // size="lg"

  // Breakpoints
  static const double breakpointSm = 640.0;
  static const double breakpointMd = 768.0;

  // Max Width
  static const double maxWidthMd = 448.0; // max-w-md = 28rem
}

/// Typography specifications
class AppTypography {
  // Font Sizes (sp)
  static const double textXs = 12.0;   // text-xs
  static const double text10 = 10.0;   // text-[10px]
  static const double textSm = 14.0;   // text-sm
  static const double textBase = 16.0; // text-base
  static const double textLg = 18.0;   // text-lg
  static const double textXl = 20.0;   // text-xl
  static const double text2xl = 24.0;  // text-2xl

  // Line Heights
  static const double leadingRelaxed = 1.625;

  // Letter Spacing
  static const double trackingWider = 0.5; // tracking-wider ≈ 0.05em
}

/// App Theme
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.foreground,
        surface: AppColors.card,
        onSurface: AppColors.foreground,
        outline: AppColors.border,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        // Title - Daily Wisdom (text-lg font-semibold)
        titleLarge: const TextStyle(
          fontSize: AppTypography.textLg,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        // Subtitle - Date (text-xs)
        labelSmall: const TextStyle(
          fontSize: AppTypography.textXs,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedForeground,
        ),
        // Body - Quote text will use Serif font
        bodyLarge: const TextStyle(
          fontSize: AppTypography.textXl,
          fontWeight: FontWeight.w400,
          color: AppColors.foreground,
          height: AppTypography.leadingRelaxed,
        ),
        // Author (text-sm font-medium)
        bodyMedium: const TextStyle(
          fontSize: AppTypography.textSm,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
        ),
        // Category (text-xs)
        bodySmall: const TextStyle(
          fontSize: AppTypography.textXs,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }

  /// Serif text style for quotes
  static TextStyle get quoteTextStyle {
    return GoogleFonts.playfairDisplay(
      fontSize: AppTypography.textXl,
      fontWeight: FontWeight.w400,
      color: AppColors.foreground,
      height: AppTypography.leadingRelaxed,
    );
  }

  /// Responsive quote font size
  static double getQuoteFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppDimensions.breakpointMd
        ? AppTypography.text2xl
        : AppTypography.textXl;
  }

  /// Check if should show text on buttons
  static bool showButtonText(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppDimensions.breakpointSm;
  }
}

/// Box Shadow matching shadow-sm
class AppShadows {
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
}
