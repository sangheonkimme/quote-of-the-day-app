import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../services/storage_service.dart';
import '../services/notification_storage_service.dart';
import '../widgets/app_header.dart';
import '../widgets/quote_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/ad_banner.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  /// Optional quoteId to display on launch (e.g. from push notification tap).
  final int? initialQuoteId;

  const HomeScreen({super.key, this.initialQuoteId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Quote _currentQuote;
  bool _isAnimating = false;
  bool _isRefreshing = false;
  bool _isLiked = false;
  int _unreadNotificationCount = 0;

  late QuoteService _quoteService;
  final StorageService _storageService = StorageService();
  final NotificationStorageService _notificationStorage =
      NotificationStorageService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    final localeChanged = _isInitialized && locale != _quoteService.locale;
    _quoteService = QuoteService(locale: locale);

    // The quote list differs per language, so swap to that language's quote
    // of the day if the app language changes while running.
    if (localeChanged) {
      _currentQuote = _quoteService.getDailyQuote();
      _checkLikedStatus();
    }

    if (!_isInitialized) {
      // If an initial quoteId was passed (e.g. from push notification),
      // show that specific quote. Otherwise show daily quote.
      if (widget.initialQuoteId != null) {
        _currentQuote =
            _quoteService.getQuoteById(widget.initialQuoteId!) ??
            _quoteService.getDailyQuote();
      } else {
        _currentQuote = _quoteService.getDailyQuote();
      }
      _checkLikedStatus();
      _loadUnreadCount();
      _isInitialized = true;
    }
  }

  bool _isInitialized = false;

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notificationStorage.getUnreadCount();
      if (mounted) {
        setState(() => _unreadNotificationCount = count);
      }
    } catch (_) {}
  }

  /// Navigate to a specific quote by its ID.
  void _navigateToQuote(int quoteId) {
    final quote = _quoteService.getQuoteById(quoteId);
    if (quote != null) {
      setState(() {
        _isAnimating = true;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _currentQuote = quote;
            _isAnimating = false;
          });
          _checkLikedStatus();
        }
      });
    }
  }

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
              unreadCount: _unreadNotificationCount,
              onNotificationTap: () async {
                final selectedQuoteId = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
                // Refresh unread count
                _loadUnreadCount();
                // If a notification was tapped, navigate to that quote
                if (selectedQuoteId != null) {
                  _navigateToQuote(selectedQuoteId);
                }
              },
              onSettingsTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
                _loadUnreadCount();
                // Likes may have changed on the favorites screen
                _checkLikedStatus();
              },
            ),

            // Main Content
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
