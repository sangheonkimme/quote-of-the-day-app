import 'package:daily_wisdom_flutter/models/quote.dart';
import 'package:daily_wisdom_flutter/services/quote_service.dart';
import 'package:daily_wisdom_flutter/utils/text_utils.dart';
import 'package:daily_wisdom_flutter/widgets/share_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final locale in ['en', 'ko']) {
    final quotes = QuoteService(locale: locale).getAllQuotes();
    final byLength = [...quotes]
      ..sort((a, b) => a.text.length.compareTo(b.text.length));
    final samples = <String, Quote>{
      'shortest': byLength.first,
      'longest': byLength.last,
      'bible': quotes.firstWhere(
        (q) => q.category == (locale == 'ko' ? '성경' : 'Bible'),
      ),
    };

    samples.forEach((label, quote) {
      testWidgets('[$locale] $label quote fits the share card', (tester) async {
        tester.view.physicalSize = const Size(1080, 1350);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: ShareCard(quote: quote, appName: 'Daily Wisdom'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(keepWordsTogether(quote.text)), findsOneWidget);
        expect(tester.getSize(find.byType(ShareCard)), ShareCard.size);
      });
    });
  }
}
