import 'package:daily_wisdom_flutter/services/quote_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in ['en', 'ko']) {
    test('[$locale] daily quote covers every quote once per cycle', () {
      final service = QuoteService(locale: locale);
      final total = service.getAllQuotes().length;
      final start = DateTime(2026, 1, 1);

      final ids = {
        for (int i = 0; i < total; i++)
          service.getDailyQuote(DateTime(start.year, start.month, start.day + i)).id,
      };
      expect(ids.length, total);
    });

    test('[$locale] same day gives same quote regardless of time', () {
      final service = QuoteService(locale: locale);
      expect(
        service.getDailyQuote(DateTime(2026, 3, 8, 0, 1)).id,
        service.getDailyQuote(DateTime(2026, 3, 8, 23, 59)).id,
      );
    });

    test('[$locale] quote ids are unique', () {
      final quotes = QuoteService(locale: locale).getAllQuotes();
      expect(quotes.map((q) => q.id).toSet().length, quotes.length);
    });
  }
}
