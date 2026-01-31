import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../config/theme.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../services/storage_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storageService = StorageService();
  List<Quote> _favoriteQuotes = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final locale = Localizations.localeOf(context).languageCode;
    final quoteService = QuoteService(locale: locale);
    final likedIds = await _storageService.getLikedQuoteIds();

    final quotes = <Quote>[];
    for (final id in likedIds) {
      final quote = quoteService.getQuoteById(id);
      if (quote != null) {
        quotes.add(quote);
      }
    }

    if (mounted) {
      setState(() {
        _favoriteQuotes = quotes;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleUnlike(int quoteId) async {
    await _storageService.toggleLike(quoteId);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          locale == 'ko' ? '좋아요한 명언' : 'Favorite Quotes',
          style: const TextStyle(
            fontSize: AppTypography.textLg,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteQuotes.isEmpty
              ? _buildEmptyState(locale)
              : _buildQuoteList(),
    );
  }

  Widget _buildEmptyState(String locale) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.mutedForeground.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              locale == 'ko' ? '아직 좋아요한 명언이 없습니다' : 'No favorite quotes yet',
              style: const TextStyle(
                fontSize: AppTypography.textBase,
                color: AppColors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              locale == 'ko'
                  ? '마음에 드는 명언에 하트를 눌러보세요'
                  : 'Tap the heart icon on quotes you love',
              style: TextStyle(
                fontSize: AppTypography.textSm,
                color: AppColors.mutedForeground.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      itemCount: _favoriteQuotes.length,
      itemBuilder: (context, index) {
        final quote = _favoriteQuotes[index];
        return _FavoriteQuoteCard(
          quote: quote,
          onUnlike: () => _handleUnlike(quote.id),
        );
      },
    );
  }
}

class _FavoriteQuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onUnlike;

  const _FavoriteQuoteCard({
    required this.quote,
    required this.onUnlike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${quote.text}"',
            style: const TextStyle(
              fontSize: AppTypography.textBase,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.author,
                    style: const TextStyle(
                      fontSize: AppTypography.textSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    quote.category,
                    style: const TextStyle(
                      fontSize: AppTypography.textXs,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: AppColors.heartRed,
                ),
                onPressed: onUnlike,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
