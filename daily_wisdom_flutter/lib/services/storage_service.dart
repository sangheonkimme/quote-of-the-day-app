import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _likedQuotesKey = 'liked_quotes';

  Future<void> toggleLike(int quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedQuotesKey) ?? [];

    if (liked.contains(quoteId.toString())) {
      liked.remove(quoteId.toString());
    } else {
      liked.add(quoteId.toString());
    }

    await prefs.setStringList(_likedQuotesKey, liked);
  }

  Future<bool> isLiked(int quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedQuotesKey) ?? [];
    return liked.contains(quoteId.toString());
  }

  Future<List<int>> getLikedQuoteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedQuotesKey) ?? [];
    return liked.map((id) => int.parse(id)).toList();
  }
}
