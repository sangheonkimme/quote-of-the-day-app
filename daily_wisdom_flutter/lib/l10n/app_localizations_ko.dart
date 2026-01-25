// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '오늘의 명언';

  @override
  String get newQuote => '새 명언';

  @override
  String get advertisement => '광고';

  @override
  String get adPlaceholder => '광고 영역 - AdMob / Google Ads';

  @override
  String get likeQuote => '명언 좋아요';

  @override
  String get copyQuote => '명언 복사';

  @override
  String get shareQuote => '명언 공유';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get notifications => '알림';

  @override
  String get settings => '설정';
}
