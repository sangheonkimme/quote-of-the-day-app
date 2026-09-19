import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../widgets/share_card.dart';

/// Shares a quote as a PNG card, with the plain text attached for apps that
/// only take text. Falls back to text-only sharing if the image fails.
class ShareImageService {
  static const double _pixelRatio = 3; // 360x450 -> 1080x1350

  static String shareText(Quote quote) => '"${quote.text}" - ${quote.author}';

  static Future<void> shareQuote(
    BuildContext context,
    Quote quote, {
    Rect? sharePositionOrigin,
  }) async {
    final text = shareText(quote);
    try {
      final bytes = await renderPng(context, quote);
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            name: 'daily_wisdom_${quote.id}.png',
            mimeType: 'image/png',
          ),
        ],
        text: text,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Image share failed, falling back to text: $e');
      await Share.share(text, sharePositionOrigin: sharePositionOrigin);
    }
  }

  static Future<Uint8List> renderPng(BuildContext context, Quote quote) async {
    final locale = Localizations.localeOf(context).languageCode;
    final appName = locale == 'ko' ? '오늘의 명언' : 'Daily Wisdom';

    // Off-screen rendering doesn't wait for async assets, so load the fonts
    // and the app icon up front.
    ShareCard.quoteStyle(quote.text);
    ShareCard.authorStyle;
    ShareCard.metaStyle;
    await GoogleFonts.pendingFonts();
    if (context.mounted) {
      await precacheImage(const AssetImage(ShareCard.appIconAsset), context);
    }
    if (!context.mounted) throw StateError('context unmounted');

    return ScreenshotController().captureFromWidget(
      ShareCard(quote: quote, appName: appName),
      context: context,
      targetSize: ShareCard.size,
      pixelRatio: _pixelRatio,
      delay: const Duration(milliseconds: 50),
    );
  }
}
