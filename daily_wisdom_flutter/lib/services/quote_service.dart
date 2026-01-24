import 'dart:math';
import '../models/quote.dart';
import '../data/quotes_en.dart';
import '../data/quotes_ko.dart';

class QuoteService {
  final String locale;

  QuoteService({this.locale = 'en'});

  List<Quote> get _quotes => locale == 'ko' ? quotesKo : quotesEn;

  /// Get daily quote based on date (same quote all day)
  Quote getDailyQuote() {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final index = seed % _quotes.length;
    return _quotes[index];
  }

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
