import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../services/storage_service.dart';
import '../widgets/app_header.dart';
import '../widgets/quote_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/ad_banner.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Quote _currentQuote;
  bool _isAnimating = false;
  bool _isRefreshing = false;
  bool _isLiked = false;

  late QuoteService _quoteService;
  final StorageService _storageService = StorageService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    _quoteService = QuoteService(locale: locale);

    // Initialize with daily quote if not already set
    if (!_isInitialized) {
      _currentQuote = _quoteService.getDailyQuote();
      _checkLikedStatus();
      _isInitialized = true;
    }
  }

  bool _isInitialized = false;

  Future<void> _checkLikedStatus() async {
    final isLiked = await _storageService.isLiked(_currentQuote.id);
    if (mounted) {
      setState(() => _isLiked = isLiked);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
      _isAnimating = true;
    });

    // Wait for fade out animation
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _currentQuote = _quoteService.getRandomQuote();
      _isAnimating = false;
      _isRefreshing = false;
    });

    _checkLikedStatus();
  }

  Future<void> _handleLike() async {
    await _storageService.toggleLike(_currentQuote.id);
    setState(() => _isLiked = !_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            AppHeader(
              onSettingsTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            // Main Content - Quote Card + Action Buttons
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuoteCard(
                        quote: _currentQuote,
                        isAnimating: _isAnimating,
                      ),
                      ActionButtons(
                        quote: _currentQuote,
                        isLiked: _isLiked,
                        isRefreshing: _isRefreshing,
                        onRefresh: _handleRefresh,
                        onLike: _handleLike,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Ad Banner
            const AdBanner(),
          ],
        ),
      ),
    );
  }
}
