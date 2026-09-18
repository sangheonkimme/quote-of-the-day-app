import 'dart:math';
import '../models/quote.dart';
import '../data/quotes_en.dart';
import '../data/quotes_ko.dart';

class QuoteService {
  final String locale;

  QuoteService({this.locale = 'en'});

  List<Quote> get _quotes => locale == 'ko' ? quotesKo : quotesEn;

  /// Get daily quote based on date (same quote all day).
  /// Defaults to today; pass [date] to get the quote for another day.
  ///
  /// Walks the whole list without repeats: every quote appears exactly once
  /// per [_quotes.length] consecutive days. The stride spreads neighbouring
  /// days across the list so the same category doesn't repeat day after day.
  Quote getDailyQuote([DateTime? date]) {
    final day = date ?? DateTime.now();
    // Calendar days since epoch (UTC avoids DST skew).
    final dayNumber = DateTime.utc(day.year, day.month, day.day)
        .difference(DateTime.utc(1970))
        .inDays;
    final length = _quotes.length;
    final index = (dayNumber * _strideFor(length)) % length;
    return _quotes[index];
  }

  /// Smallest stride >= 101 that is coprime with [length], so the walk visits
  /// every index before repeating.
  static int _strideFor(int length) {
    var stride = 101;
    while (_gcd(stride, length) != 1) {
      stride++;
    }
    return stride;
  }

  static int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  /// Get random quote
  Quote getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }

  /// Get quote by ID
  Quote? getQuoteById(int id) {
    try {
      return _quotes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all quotes
  List<Quote> getAllQuotes() => _quotes;
}
