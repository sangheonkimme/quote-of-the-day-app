/// Batch-exports quote cards as PNGs for social posting.
///
/// Not part of the shipped app: run it with `scripts/export_cards.sh`, which
/// wraps `flutter run -d macos -t lib/tools/export_cards.dart` and copies the
/// files out of the sandboxed app container.
///
/// Options (passed as --dart-define by the script):
///   DAYS=30            how many days to export
///   START=2026-09-21   first day (defaults to today)
///   LOCALES=ko,en      which languages
///   FORMATS=feed,story feed = 1080x1350 (4:5), story = 1080x1920 (9:16)
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../models/quote.dart';
import '../services/quote_service.dart';
import '../widgets/share_card.dart';

const _days = int.fromEnvironment('DAYS', defaultValue: 30);
const _start = String.fromEnvironment('START');
const _locales = String.fromEnvironment('LOCALES', defaultValue: 'ko,en');
const _formats = String.fromEnvironment('FORMATS', defaultValue: 'feed,story');
const _pixelRatio = 3.0; // 360x450 -> 1080x1350, 360x640 -> 1080x1920

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _ExporterApp());
}

class _ExporterApp extends StatefulWidget {
  const _ExporterApp();

  @override
  State<_ExporterApp> createState() => _ExporterAppState();
}

class _ExporterAppState extends State<_ExporterApp> {
  String _status = 'starting…';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    try {
      final outDir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/daily_wisdom_cards',
      );
      if (outDir.existsSync()) outDir.deleteSync(recursive: true);
      outDir.createSync(recursive: true);
      // The wrapper script reads this line to find the files.
      stdout.writeln('[export] OUTPUT_DIR=${outDir.path}');

      final firstDay = _start.isEmpty ? DateTime.now() : DateTime.parse(_start);
      var written = 0;

      for (final locale in _locales.split(',')) {
        final service = QuoteService(locale: locale.trim());
        final appName = locale.trim() == 'ko' ? '오늘의 명언' : 'Daily Wisdom';

        for (var i = 0; i < _days; i++) {
          final day = DateTime(
            firstDay.year,
            firstDay.month,
            firstDay.day + i,
          );
          final quote = service.getDailyQuote(day);

          for (final format in _formats.split(',')) {
            final isStory = format.trim() == 'story';
            final file = File(
              '${outDir.path}/${locale.trim()}/${format.trim()}/'
              '${_dateStamp(day)}_id${quote.id}.png',
            )..createSync(recursive: true);

            setState(() => _status = 'writing ${file.path.split('/').last}');
            file.writeAsBytesSync(
              await _render(
                quote,
                appName,
                isStory ? ShareCard.storySize : ShareCard.size,
              ),
            );
            written++;
          }
        }
      }

      _writeIndex(outDir, firstDay);
      stdout.writeln('[export] wrote $written files to ${outDir.path}');
      stdout.writeln('[export] DONE');
    } catch (e, stack) {
      stdout.writeln('[export] FAILED: $e\n$stack');
      exit(1);
    }
    exit(0);
  }

  Future<Uint8List> _render(Quote quote, String appName, Size size) async {
    // Off-screen rendering doesn't wait for async assets.
    ShareCard.quoteStyle(quote.text);
    ShareCard.authorStyle;
    ShareCard.metaStyle;
    await GoogleFonts.pendingFonts();
    if (!mounted) throw StateError('exporter widget was disposed');
    await precacheImage(const AssetImage(ShareCard.appIconAsset), context);
    if (!mounted) throw StateError('exporter widget was disposed');

    return ScreenshotController().captureFromWidget(
      ShareCard(quote: quote, appName: appName, cardSize: size),
      context: context,
      targetSize: size,
      pixelRatio: _pixelRatio,
      delay: const Duration(milliseconds: 50),
    );
  }

  /// A plain-text list of what each day's card says, for writing captions.
  void _writeIndex(Directory outDir, DateTime firstDay) {
    final buffer = StringBuffer();
    for (final locale in _locales.split(',')) {
      final service = QuoteService(locale: locale.trim());
      buffer.writeln('## ${locale.trim()}');
      for (var i = 0; i < _days; i++) {
        final day = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
        final quote = service.getDailyQuote(day);
        buffer.writeln(
          '${_dateStamp(day)}\tid${quote.id}\t[${quote.category}]\t'
          '${quote.text} — ${quote.author}',
        );
      }
      buffer.writeln();
    }
    File('${outDir.path}/index.txt').writeAsStringSync(buffer.toString());
  }

  String _dateStamp(DateTime day) =>
      '${day.year}-${_two(day.month)}-${_two(day.day)}';

  String _two(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text(_status))),
    );
  }
}
