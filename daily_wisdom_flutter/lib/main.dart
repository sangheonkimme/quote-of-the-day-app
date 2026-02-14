import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/theme.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // Initialize date formatting for locales
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('ko', null);

  // Initialize local notifications and restore scheduled daily quote alerts.
  await NotificationService.instance.initialize();
  final systemLocale =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  await NotificationService.instance.syncDailyQuoteNotifications(
    locale: systemLocale,
  );

  runApp(const DailyWisdomApp());
}

class DailyWisdomApp extends StatelessWidget {
  const DailyWisdomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Wisdom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ko')],
      home: const HomeScreen(),
    );
  }
}
