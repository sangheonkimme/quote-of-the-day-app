# Daily Wisdom - Flutter Implementation Checklist

## Overview

로그인 없이 가볍게 사용하는 명언 앱 구현 체크리스트

---

## Phase 1: Project Setup

### 1.1 Flutter Project 초기화

- [ ] Flutter 프로젝트 생성 (`flutter create daily_wisdom`)
- [ ] 불필요한 기본 코드 제거
- [ ] 폴더 구조 생성
  - [ ] `lib/models/`
  - [ ] `lib/data/`
  - [ ] `lib/services/`
  - [ ] `lib/screens/`
  - [ ] `lib/widgets/`
  - [ ] `lib/config/`
  - [ ] `lib/utils/`

### 1.2 Dependencies 설치

- [ ] `pubspec.yaml` 수정
  ```yaml
  dependencies:
    provider: ^6.1.1
    shared_preferences: ^2.2.2
    flutter_local_notifications: ^17.0.0
    timezone: ^0.9.2
    google_mobile_ads: ^4.0.0
    share_plus: ^7.2.1
    lucide_icons: ^0.257.0          # 아이콘 (디자인과 동일)
    flutter_svg: ^2.0.9             # Quote 아이콘 SVG 렌더링
    google_fonts: ^6.1.0            # Serif 폰트 (Georgia 대체)
  ```
- [ ] `flutter pub get` 실행
- [ ] iOS/Android 플랫폼 설정 확인

### 1.3 Theme 설정

- [ ] `lib/config/theme.dart` 생성
- [ ] Light theme 색상 정의 (globals.css OKLCH → HEX 변환)
  ```dart
  // globals.css 기준 정확한 색상
  static const Color background = Color(0xFFFAFAFA);      // oklch(0.985 0 0)
  static const Color foreground = Color(0xFF171717);      // oklch(0.145 0 0)
  static const Color card = Color(0xFFFFFFFF);            // oklch(1 0 0)
  static const Color cardForeground = Color(0xFF171717);  // oklch(0.145 0 0)
  static const Color secondary = Color(0xFFF5F5F5);       // oklch(0.96 0 0)
  static const Color muted = Color(0xFFF5F5F5);           // oklch(0.96 0 0)
  static const Color mutedForeground = Color(0xFF737373); // oklch(0.45 0 0)
  static const Color border = Color(0xFFE5E5E5);          // oklch(0.91 0 0)

  // Additional
  static const Color heartRed = Color(0xFFEF4444);        // Tailwind red-500
  static const Color checkGreen = Color(0xFF16A34A);      // Tailwind green-600
  ```
- [ ] Typography 설정 (Serif 폰트 for quotes)
- [ ] `main.dart`에 theme 적용

---

## Phase 1.5: Localization Setup (한국어/영어)

### 1.5.1 Flutter Localization 설정

- [ ] `pubspec.yaml`에 의존성 추가
  ```yaml
  dependencies:
    flutter_localizations:
      sdk: flutter
    intl: ^0.19.0
  ```
- [ ] `pubspec.yaml`에 generate 옵션 추가
  ```yaml
  flutter:
    generate: true
  ```
- [ ] `l10n.yaml` 파일 생성 (프로젝트 루트)
  ```yaml
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
  output-localization-file: app_localizations.dart
  ```

### 1.5.2 ARB 파일 생성

- [ ] `lib/l10n/app_en.arb` 생성 (영어 - 기본)
  ```json
  {
    "@@locale": "en",
    "appTitle": "Daily Wisdom",
    "dateFormat": "{weekday}, {month} {day}",
    "newQuote": "New Quote",
    "advertisement": "ADVERTISEMENT",
    "adPlaceholder": "Ad space - AdMob / Google Ads",
    "likeQuote": "Like quote",
    "copyQuote": "Copy quote",
    "shareQuote": "Share quote",
    "copiedToClipboard": "Copied to clipboard",
    "notifications": "Notifications",
    "settings": "Settings"
  }
  ```
- [ ] `lib/l10n/app_ko.arb` 생성 (한국어)
  ```json
  {
    "@@locale": "ko",
    "appTitle": "오늘의 명언",
    "dateFormat": "{month} {day}일 {weekday}",
    "newQuote": "새 명언",
    "advertisement": "광고",
    "adPlaceholder": "광고 영역 - AdMob / Google Ads",
    "likeQuote": "명언 좋아요",
    "copyQuote": "명언 복사",
    "shareQuote": "명언 공유",
    "copiedToClipboard": "클립보드에 복사됨",
    "notifications": "알림",
    "settings": "설정"
  }
  ```

### 1.5.3 MaterialApp 설정

- [ ] `main.dart`에 localization delegates 추가
  ```dart
  MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en'),
      Locale('ko'),
    ],
  )
  ```
- [ ] `flutter gen-l10n` 실행하여 코드 생성

### 1.5.4 명언 데이터 다국어

- [ ] `lib/data/quotes_en.dart` 생성 (영어 명언 50개)
- [ ] `lib/data/quotes_ko.dart` 생성 (한국어 명언 50개)
- [ ] QuoteService에서 현재 locale에 따라 데이터 선택

---

## Phase 2: Data Layer

### 2.1 Quote Model

- [ ] `lib/models/quote.dart` 생성
  ```dart
  class Quote {
    final int id;
    final String text;
    final String author;
    final String category;
  }
  ```

### 2.2 Quotes Data (다국어)

- [ ] `lib/data/quotes_en.dart` 생성 (영어)
  - [ ] 1-10번 명언
  - [ ] 11-20번 명언
  - [ ] 21-30번 명언
  - [ ] 31-40번 명언
  - [ ] 41-50번 명언
- [ ] `lib/data/quotes_ko.dart` 생성 (한국어)
  - [ ] 1-10번 명언 (한국어 번역 또는 한국 명언)
  - [ ] 11-20번 명언
  - [ ] 21-30번 명언
  - [ ] 31-40번 명언
  - [ ] 41-50번 명언
- [ ] `lib/data/quotes_data.dart` - locale별 데이터 반환 함수

### 2.3 Quote Service

- [ ] `lib/services/quote_service.dart` 생성
- [ ] `getDailyQuote()` 구현 (날짜 기반 seed)
- [ ] `getRandomQuote()` 구현

---

## Phase 3: UI Widgets

### 3.1 AppHeader Widget

```
소스: components/app-header.tsx
클래스: px-6 py-4 → padding: horizontal 24px, vertical 16px
```

- [ ] `lib/widgets/app_header.dart` 생성
- [ ] 전체 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16)
- [ ] "Daily Wisdom" 타이틀
  - [ ] 클래스: `text-lg font-semibold text-foreground`
  - [ ] fontSize: 18sp (text-lg = 1.125rem = 18px)
  - [ ] fontWeight: FontWeight.w600 (font-semibold)
  - [ ] color: Color(0xFF171717) (text-foreground)
- [ ] 날짜 표시
  - [ ] 클래스: `text-xs text-muted-foreground`
  - [ ] 형식: "Thursday, Jan 23" (weekday: long, month: short, day: numeric)
  - [ ] fontSize: 12sp (text-xs = 0.75rem = 12px)
  - [ ] fontWeight: FontWeight.w400
  - [ ] color: Color(0xFF737373) (text-muted-foreground)
- [ ] Bell 아이콘 버튼
  - [ ] 클래스: `rounded-full w-10 h-10` + variant="ghost"
  - [ ] 크기: 40x40px (w-10 h-10 = 2.5rem = 40px)
  - [ ] borderRadius: 20px (원형)
  - [ ] 아이콘 클래스: `w-5 h-5 text-muted-foreground`
  - [ ] 아이콘: LucideIcons.bell (20x20, w-5 h-5 = 1.25rem = 20px)
  - [ ] 아이콘 색상: Color(0xFF737373)
  - [ ] 배경: transparent (ghost = no background)
- [ ] Settings 아이콘 버튼
  - [ ] 동일한 스타일
  - [ ] 아이콘: LucideIcons.settings (20x20)
- [ ] 아이콘 버튼 간격: 8px (gap-2 = 0.5rem = 8px)
- [ ] Row: MainAxisAlignment.spaceBetween

### 3.2 QuoteCard Widget

```txt
소스: components/quote-card.tsx
카드: bg-card rounded-2xl p-8 shadow-sm border border-border
애니메이션: transition-all duration-500 ease-out, opacity-0 scale-95
```

- [ ] `lib/widgets/quote_card.dart` 생성
- [ ] Container 스타일링
  - [ ] 클래스: `rounded-2xl p-8 shadow-sm border border-border`
  - [ ] padding: 32px (p-8 = 2rem = 32px)
  - [ ] borderRadius: 16px (rounded-2xl = 1rem = 16px)
  - [ ] background: Color(0xFFFFFFFF) (bg-card)
  - [ ] border: 1px solid Color(0xFFE5E5E5) (border-border)
  - [ ] shadow: shadow-sm → BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))
- [ ] Quote icon (") - **커스텀 SVG 필수**
  - [ ] 클래스: `w-10 h-10 text-muted-foreground/30`
  - [ ] 크기: 40x40px (w-10 h-10)
  - [ ] 색상: Color(0xFF737373).withOpacity(0.3) (/30 = 30% opacity)
  - [ ] SVG viewBox: "0 0 24 24", fill: currentColor
  - [ ] SVG Path: `M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z`
  - [ ] marginBottom: 24px (mb-6 = 1.5rem = 24px)
- [ ] Quote text
  - [ ] 클래스: `text-xl md:text-2xl font-serif leading-relaxed text-foreground mb-6`
  - [ ] fontSize: 20sp mobile / 24sp tablet+ (text-xl=20px, text-2xl=24px)
  - [ ] fontFamily: Serif (font-serif)
  - [ ] height: 1.625 (leading-relaxed)
  - [ ] color: Color(0xFF171717) (text-foreground)
  - [ ] marginBottom: 24px (mb-6)
- [ ] Author
  - [ ] 클래스: `text-sm font-medium text-foreground`
  - [ ] fontSize: 14sp (text-sm = 0.875rem = 14px)
  - [ ] fontWeight: FontWeight.w500 (font-medium)
  - [ ] color: Color(0xFF171717)
- [ ] Category
  - [ ] 클래스: `text-xs text-muted-foreground mt-0.5`
  - [ ] fontSize: 12sp (text-xs = 12px)
  - [ ] fontWeight: FontWeight.w400
  - [ ] color: Color(0xFF737373)
  - [ ] marginTop: 2px (mt-0.5 = 0.125rem = 2px)
- [ ] 애니메이션
  - [ ] duration: 500ms (duration-500)
  - [ ] curve: Curves.easeOut (ease-out)
  - [ ] isAnimating 시: opacity 0, scale 0.95

### 3.3 ActionButtons Widget

```txt
소스: components/action-buttons.tsx
컨테이너: flex items-center justify-center gap-3 mt-8
Lucide 아이콘: RefreshCw, Share2, Heart, Copy, Check
```

- [ ] `lib/widgets/action_buttons.dart` 생성
- [ ] 전체 컨테이너
  - [ ] 클래스: `flex items-center justify-center gap-3 mt-8`
  - [ ] marginTop: 32px (mt-8 = 2rem = 32px)
  - [ ] 중앙 정렬 (MainAxisAlignment.center)
  - [ ] 버튼 간격: 12px (gap-3 = 0.75rem = 12px)
- [ ] New Quote 버튼
  - [ ] 클래스: `rounded-full px-6 gap-2 bg-transparent` + variant="outline" size="lg"
  - [ ] height: 44px (size="lg" 기본값)
  - [ ] padding: horizontal 24px (px-6)
  - [ ] borderRadius: 22px (rounded-full = 9999px, 실제로는 높이/2)
  - [ ] border: 1px solid Color(0xFFE5E5E5)
  - [ ] background: transparent
  - [ ] 아이콘 클래스: `w-4 h-4`
  - [ ] 아이콘: LucideIcons.refreshCw (16x16, w-4 h-4 = 1rem = 16px)
  - [ ] 아이콘-텍스트 간격: 8px (gap-2)
  - [ ] 텍스트: "New Quote" (sm 이상에서만 표시, `hidden sm:inline`)
  - [ ] 로딩 시: animate-spin (무한 회전)
- [ ] Heart 버튼
  - [ ] 클래스: `rounded-full w-12 h-12 bg-transparent` + variant="outline" size="icon"
  - [ ] 크기: 48x48px (w-12 h-12 = 3rem = 48px)
  - [ ] borderRadius: 24px (원형)
  - [ ] border: 1px solid Color(0xFFE5E5E5)
  - [ ] 아이콘 클래스: `w-5 h-5 transition-colors`
  - [ ] 아이콘: LucideIcons.heart (20x20)
  - [ ] liked 상태 클래스: `fill-red-500 text-red-500`
  - [ ] liked 색상: Color(0xFFEF4444) (red-500)
- [ ] Copy 버튼
  - [ ] 동일 스타일 (w-12 h-12 rounded-full)
  - [ ] 아이콘: LucideIcons.copy (20x20)
  - [ ] 복사 성공: LucideIcons.check + `text-green-600` → Color(0xFF16A34A)
  - [ ] 2초 후 복귀 (setTimeout 2000ms)
- [ ] Share 버튼
  - [ ] 동일 스타일
  - [ ] 아이콘: LucideIcons.share2 (20x20) - ⚠️ Share2 (숫자 2 포함)

### 3.4 AdBanner Widget

```txt
소스: components/ad-banner.tsx
외부: mx-6 mb-4
내부: bg-secondary rounded-xl p-4 text-center border border-border
```

- [ ] `lib/widgets/ad_banner.dart` 생성
- [ ] 외부 Container
  - [ ] 클래스: `mx-6 mb-4`
  - [ ] margin: horizontal 24px (mx-6 = 1.5rem = 24px)
  - [ ] marginBottom: 16px (mb-4 = 1rem = 16px)
- [ ] 내부 Container
  - [ ] 클래스: `bg-secondary rounded-xl p-4 text-center border border-border`
  - [ ] padding: 16px (p-4 = 1rem = 16px)
  - [ ] borderRadius: 12px (rounded-xl = 0.75rem = 12px)
  - [ ] border: 1px solid Color(0xFFE5E5E5)
  - [ ] background: Color(0xFFF5F5F5) (bg-secondary)
  - [ ] 정렬: 중앙 (text-center)
- [ ] "ADVERTISEMENT" 라벨
  - [ ] 클래스: `text-[10px] text-muted-foreground uppercase tracking-wider mb-1`
  - [ ] fontSize: 10px (text-[10px] = 커스텀 10px)
  - [ ] color: Color(0xFF737373)
  - [ ] 대문자: uppercase
  - [ ] letterSpacing: 0.05em (tracking-wider ≈ 0.5px)
  - [ ] marginBottom: 4px (mb-1 = 0.25rem = 4px)
- [ ] 광고 콘텐츠 영역
  - [ ] 클래스: `h-12 flex items-center justify-center`
  - [ ] height: 48px (h-12 = 3rem = 48px)
  - [ ] 중앙 정렬 (flex items-center justify-center)
- [ ] Placeholder 텍스트
  - [ ] 클래스: `text-xs text-muted-foreground`
  - [ ] fontSize: 12px
  - [ ] color: Color(0xFF737373)

---

## Phase 4: Main Screen

### 4.1 HomeScreen 기본 구조

- [ ] `lib/screens/home_screen.dart` 생성
- [ ] StatefulWidget 구조
- [ ] State 변수 정의
  - [ ] `_currentQuote`
  - [ ] `_isAnimating`
  - [ ] `_isRefreshing`
  - [ ] `_isLiked`
- [ ] initState에서 getDailyQuote() 호출

### 4.2 HomeScreen 레이아웃

- [ ] Scaffold 설정 (backgroundColor: F5F5F5)
- [ ] SafeArea 적용
- [ ] Column 레이아웃
  - [ ] AppHeader
  - [ ] Expanded (QuoteCard + ActionButtons)
  - [ ] AdBanner
- [ ] 적절한 padding 적용

### 4.3 HomeScreen 인터랙션

- [ ] `_handleRefresh()` 구현
  - [ ] 애니메이션 트리거
  - [ ] 300ms 딜레이
  - [ ] 새 명언 로드
- [ ] `_handleLike()` 구현
- [ ] `_handleCopy()` 구현
- [ ] `_handleShare()` 구현

---

## Phase 5: Core Features

### 5.1 Storage Service (좋아요 저장)

- [ ] `lib/services/storage_service.dart` 생성
- [ ] SharedPreferences 초기화
- [ ] `toggleLike(int quoteId)` 구현
- [ ] `isLiked(int quoteId)` 구현
- [ ] `getLikedQuotes()` 구현

### 5.2 Share & Copy 기능

- [ ] `lib/utils/share_utils.dart` 생성
- [ ] `copyToClipboard(Quote quote)` 구현
  - [ ] `Clipboard.setData()` 사용
  - [ ] 포맷: `"quote text" - author`
- [ ] `shareQuote(Quote quote)` 구현
  - [ ] `share_plus` 패키지 사용
  - [ ] 네이티브 공유 시트 호출

### 5.3 Notification Service

- [ ] `lib/services/notification_service.dart` 생성
- [ ] flutter_local_notifications 초기화
- [ ] Android 채널 설정
- [ ] iOS 권한 요청
- [ ] `scheduleDailyNotification()` 구현
  - [ ] 매일 오전 8시 스케줄
  - [ ] 일일 명언 내용 포함
- [ ] `cancelAllNotifications()` 구현

---

## Phase 6: AdMob Integration

### 6.1 AdMob 설정

- [ ] Google AdMob 계정 생성/로그인
- [ ] 앱 등록 (Android)
- [ ] 앱 등록 (iOS)
- [ ] Banner 광고 단위 생성

### 6.2 Android 설정

- [ ] `android/app/src/main/AndroidManifest.xml` 수정
  ```xml
  <meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXX~YYYYY"/>
  ```

### 6.3 iOS 설정

- [ ] `ios/Runner/Info.plist` 수정
  ```xml
  <key>GADApplicationIdentifier</key>
  <string>ca-app-pub-XXXXX~YYYYY</string>
  ```

### 6.4 Ad Service 구현

- [ ] `lib/services/ad_service.dart` 생성
- [ ] BannerAd 초기화
- [ ] 테스트 광고 ID 적용 (개발용)
- [ ] AdWidget 통합
- [ ] 광고 로드 실패 핸들링

---

## Phase 7: Animations & Polish

### 7.1 Quote Transition Animation

- [ ] AnimatedOpacity 적용 (duration: 300ms)
- [ ] AnimatedScale 적용 (0.95 → 1.0)
- [ ] Curve 설정 (easeOut)

### 7.2 Button Animations

- [ ] Refresh 아이콘 회전 (AnimatedRotation)
- [ ] Heart 스케일 애니메이션 (tap feedback)
- [ ] Copy 성공 아이콘 전환

### 7.3 UI Polish

- [ ] 모든 터치 영역 최소 48x48 확인
- [ ] 로딩 상태 UI 확인
- [ ] 에러 상태 핸들링
- [ ] 접근성 라벨 추가 (Semantics)

---

## Phase 8: Testing

### 8.1 Unit Tests

- [ ] QuoteService 테스트
  - [ ] getDailyQuote() 일관성 테스트
  - [ ] getRandomQuote() 범위 테스트
- [ ] StorageService 테스트
  - [ ] toggleLike() 테스트
  - [ ] isLiked() 테스트

### 8.2 Widget Tests

- [ ] QuoteCard 렌더링 테스트
- [ ] ActionButtons 탭 테스트
- [ ] AppHeader 날짜 포맷 테스트

### 8.3 Integration Tests

- [ ] 앱 실행 → 명언 표시 플로우
- [ ] New Quote 버튼 → 명언 변경 플로우
- [ ] 좋아요 → 앱 재시작 → 상태 유지 테스트

---

## Phase 9: Build & Release

### 9.1 App Icon & Splash

- [ ] App icon 생성 (1024x1024)
- [ ] Android adaptive icon 설정
- [ ] iOS app icon 설정
- [ ] Splash screen 설정

### 9.2 Android Build

- [ ] `flutter build apk --release` 테스트
- [ ] `flutter build appbundle --release`
- [ ] Signing key 생성
- [ ] ProGuard rules 설정 (필요시)

### 9.3 iOS Build

- [ ] Bundle ID 설정
- [ ] Xcode signing 설정
- [ ] `flutter build ios --release`
- [ ] TestFlight 업로드 테스트

### 9.4 Store 준비

- [ ] 스크린샷 캡처 (6.5", 5.5")
- [ ] 앱 설명 작성
- [ ] 개인정보 처리방침 URL
- [ ] AdMob 프로덕션 광고 ID 적용

---

## Phase 10: Launch

### 10.1 Google Play Store

- [ ] Play Console 앱 생성
- [ ] 앱 정보 입력
- [ ] 스크린샷 업로드
- [ ] AAB 파일 업로드
- [ ] 내부 테스트 → 프로덕션 릴리스

### 10.2 Apple App Store

- [ ] App Store Connect 앱 생성
- [ ] 앱 정보 입력
- [ ] 스크린샷 업로드
- [ ] 빌드 업로드
- [ ] 심사 제출

---

## Progress Summary

| Phase | Status | Progress |
|-------|--------|----------|
| Phase 1: Project Setup | ⬜ | 0% |
| Phase 2: Data Layer | ⬜ | 0% |
| Phase 3: UI Widgets | ⬜ | 0% |
| Phase 4: Main Screen | ⬜ | 0% |
| Phase 5: Core Features | ⬜ | 0% |
| Phase 6: AdMob | ⬜ | 0% |
| Phase 7: Animations | ⬜ | 0% |
| Phase 8: Testing | ⬜ | 0% |
| Phase 9: Build | ⬜ | 0% |
| Phase 10: Launch | ⬜ | 0% |

---

## Quick Reference

### Design Specs (Pixel Perfect)

```
=== COLORS (OKLCH → HEX 정확한 변환) ===

Light Theme (globals.css 기준):
┌────────────────────┬─────────────────┬────────────┐
│ Variable           │ OKLCH           │ HEX        │
├────────────────────┼─────────────────┼────────────┤
│ --background       │ oklch(0.985 0 0)│ #FAFAFA    │
│ --foreground       │ oklch(0.145 0 0)│ #171717    │
│ --card             │ oklch(1 0 0)    │ #FFFFFF    │
│ --card-foreground  │ oklch(0.145 0 0)│ #171717    │
│ --secondary        │ oklch(0.96 0 0) │ #F5F5F5    │
│ --muted            │ oklch(0.96 0 0) │ #F5F5F5    │
│ --muted-foreground │ oklch(0.45 0 0) │ #737373    │
│ --border           │ oklch(0.91 0 0) │ #E5E5E5    │
│ --input            │ oklch(0.91 0 0) │ #E5E5E5    │
└────────────────────┴─────────────────┴────────────┘

Flutter Color 정의:
Background:       Color(0xFFFAFAFA)  // oklch(0.985 0 0)
Card:             Color(0xFFFFFFFF)  // oklch(1 0 0)
Foreground:       Color(0xFF171717)  // oklch(0.145 0 0)
Muted Foreground: Color(0xFF737373)  // oklch(0.45 0 0)
Secondary/Muted:  Color(0xFFF5F5F5)  // oklch(0.96 0 0)
Border:           Color(0xFFE5E5E5)  // oklch(0.91 0 0)

Additional Colors:
Red (Heart):      Color(0xFFEF4444)  // Tailwind red-500
Green (Check):    Color(0xFF16A34A)  // Tailwind green-600

=== APP HEADER (app-header.tsx) ===
클래스: px-6 py-4 → padding: 24px horizontal, 16px vertical
Title: text-lg font-semibold → 18sp, w600
Date: text-xs → 12sp
Icons: w-10 h-10 → 40x40px
Icon inner: w-5 h-5 → 20x20px
Gap: gap-2 → 8px

=== QUOTE CARD (quote-card.tsx) ===
Outer: w-full max-w-md mx-auto → width 100%, max 448px, 중앙정렬
Card: rounded-2xl p-8 → radius 16px, padding 32px
Shadow: shadow-sm → blur 2px, offset (0,1)
Border: border border-border → 1px solid #E5E5E5

Quote Icon: w-10 h-10 → 40x40px
Icon opacity: text-muted-foreground/30 → 30% opacity
Icon MB: mb-6 → 24px

Quote: text-xl md:text-2xl → 20sp (mobile) / 24sp (tablet+)
Quote: font-serif leading-relaxed → Serif, height 1.625
Quote MB: mb-6 → 24px

Author: text-sm font-medium → 14sp, w500
Category: text-xs mt-0.5 → 12sp, marginTop 2px

Animation: duration-500 ease-out → 500ms, easeOut
Animation: opacity-0 scale-95 → opacity 0, scale 0.95

=== ACTION BUTTONS (action-buttons.tsx) ===
Container: gap-3 mt-8 → gap 12px, marginTop 32px
정렬: justify-center → 중앙 정렬

New Quote: size="lg" px-6 → height 44px, padding-x 24px
New Quote: rounded-full → stadium shape
New Quote Icon: w-4 h-4 → 16x16px
New Quote: gap-2 → icon-text gap 8px
New Quote text: hidden sm:inline → 640px 이상에서만 표시

Icon Buttons: w-12 h-12 → 48x48px
Icon Buttons: rounded-full → 원형
Icon inner: w-5 h-5 → 20x20px

Heart liked: fill-red-500 text-red-500 → #EF4444
Copy success: text-green-600 → #16A34A
Copy reset: setTimeout 2000ms

=== AD BANNER (ad-banner.tsx) ===
Outer: mx-6 mb-4 → margin-x 24px, margin-bottom 16px
Inner: rounded-xl p-4 → radius 12px, padding 16px
Background: bg-secondary → #F5F5F5

Label: text-[10px] → 10px (커스텀)
Label: uppercase tracking-wider → 대문자, letterSpacing 0.05em
Label: mb-1 → marginBottom 4px

Content: h-12 → height 48px
Content text: text-xs → 12px

=== ⚠️ 디자인 주의사항 (스크린샷 기준) ===

1. Quote Icon (")
   - 단순 텍스트 따옴표 아님
   - 두 개의 큰따옴표가 세로로 긴 형태
   - 반드시 SVG 또는 CustomPaint로 구현

2. Action Buttons 정렬
   - 스크린샷: 왼쪽 정렬이 아닌 중앙 정렬
   - New Quote 버튼이 가장 왼쪽 (텍스트 포함)
   - 나머지 3개는 아이콘만 있는 원형 버튼

3. Card 내부 여백
   - Quote icon과 Quote text 사이: 24px (mb-6)
   - Quote text와 Author 사이: 24px (mb-6)
   - Author와 Category 사이: 2px (mt-0.5)

4. 폰트 스타일
   - "Daily Wisdom": Sans-serif, Bold (600)
   - Quote text: Serif (Georgia 또는 유사), Regular
   - Author: Sans-serif, Medium (500)
   - Category: Sans-serif, Regular (400)

5. Ad Banner 위치
   - 화면 하단 고정
   - 홈 인디케이터 위에 위치
   - SafeArea 내부

=== 📱 반응형/기기별 호환성 ===

1. 화면 너비 대응 (Quote Card)
   - 소스: `w-full max-w-md mx-auto`
   - Flutter: width: double.infinity (부모에 맞춤)
   - maxWidth: 448px (max-w-md = 28rem = 448px)
   - 중앙 정렬: Center() 또는 alignment: Alignment.center
   - 실제 구현:
     ```dart
     Container(
       width: double.infinity,
       constraints: BoxConstraints(maxWidth: 448),
       margin: EdgeInsets.symmetric(horizontal: 16),
     )
     ```

2. Quote 텍스트 반응형
   - 소스: `text-xl md:text-2xl`
   - 모바일 (<768px): 20sp (text-xl)
   - 태블릿+ (≥768px): 24sp (text-2xl)
   - Flutter 구현:
     ```dart
     fontSize: MediaQuery.of(context).size.width >= 768 ? 24 : 20
     ```

3. New Quote 버튼 텍스트
   - 소스: `hidden sm:inline`
   - 작은 화면 (<640px): 아이콘만 표시
   - 큰 화면 (≥640px): 아이콘 + "New Quote" 텍스트
   - Flutter 구현:
     ```dart
     if (MediaQuery.of(context).size.width >= 640)
       Text("New Quote")
     ```

4. SafeArea 적용
   - 상단: 노치/Dynamic Island 대응
   - 하단: 홈 인디케이터 대응
   - Flutter: SafeArea(child: ...)

5. 기기별 테스트 필수 화면 크기
   - iPhone SE: 375 x 667
   - iPhone 14: 390 x 844
   - iPhone 14 Pro Max: 430 x 932
   - Android Small: 360 x 640
   - Android Large: 412 x 915
```

### Icon Specifications (정확한 아이콘 - 스크린샷 기준)

```
=== 스크린샷 아이콘 분석 ===

App Header (우측 상단):
  - Bell:      outline 스타일, 알림 종 모양 (채워지지 않음)
  - Settings:  outline 스타일, 톱니바퀴 (6개 톱니, 채워지지 않음)

Quote Card:
  - Quote:     큰따옴표 2개 "" 스타일 (왼쪽 정렬, 회색, 투명도 적용)
              ※ 단순 텍스트 아님, 특수 디자인 아이콘

Action Buttons (스크린샷 순서: 왼쪽→오른쪽):
  1. Refresh:  🔄 두 개의 화살표가 원형으로 도는 모양 (RefreshCw)
  2. Heart:    ♡ outline 하트 (채워지지 않음)
  3. Copy:     📋 두 장의 겹친 사각형 (앞 사각형이 작음)
  4. Share:    ↗️ 세 개의 점이 연결된 공유 아이콘 (share-2 스타일)

=== LUCIDE ICONS 사용 (Flutter: lucide_icons 패키지) ===

App Header:
  - Bell:      LucideIcons.bell (20x20) - outline
  - Settings:  LucideIcons.settings (20x20) - outline, 6톱니

Quote Card:
  - Quote:     커스텀 SVG 필수 (Text로 대체 불가)
              SVG viewBox: "0 0 24 24"
              SVG Path: "M14.017 21v-7.391c0-5.704 3.731-9.57
              8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995
              5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57
              9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996
              5.849h3.983v10h-9.983z"

Action Buttons:
  - Refresh:   LucideIcons.refreshCw (16x16) - 두 화살표 원형
  - Heart:     LucideIcons.heart (20x20) - outline only
  - Heart:     (filled) Icon에 fill 속성 추가
  - Copy:      LucideIcons.copy (20x20) - 두 장 겹친 사각형
  - Check:     LucideIcons.check (20x20) - 복사 성공
  - Share:     LucideIcons.share2 (20x20) - 세 점 연결 스타일

=== FLUTTER MATERIAL ICONS 대안 (Lucide와 약간 다름 주의) ===
  - Bell:      Icons.notifications_outlined (비슷함)
  - Settings:  Icons.settings_outlined (비슷함)
  - Refresh:   Icons.refresh (⚠️ 단일 화살표, 다름)
               → Icons.sync 또는 커스텀 필요
  - Heart:     Icons.favorite_border / Icons.favorite (비슷함)
  - Copy:      Icons.copy_outlined (⚠️ 모양 다름)
               → Icons.content_copy 권장
  - Check:     Icons.check (비슷함)
  - Share:     Icons.share_outlined (⚠️ iOS/Android 다름)
               → LucideIcons.share2 권장
```

### Animation Specs (정확한 값)

```
=== QUOTE TRANSITION (quote-card.tsx 기준) ===
Duration:     500ms (duration-500) ⚠️ 300ms 아님!
Curve:        Curves.easeOut (ease-out)
Opacity:      1.0 → 0.0 → 1.0
Scale:        1.0 → 0.95 → 1.0

=== REFRESH ICON SPIN ===
Duration:     500ms (continuous while loading)
Turns:        1 full rotation

=== HEART TAP ===
Duration:     150ms
Scale:        1.0 → 1.2 → 1.0

=== COPY SUCCESS ===
Icon swap duration: instant
Reset delay:        2000ms
```

### Key Files

```
lib/
├── main.dart
├── config/theme.dart
├── models/quote.dart
├── data/quotes_data.dart
├── services/
│   ├── quote_service.dart
│   ├── storage_service.dart
│   ├── notification_service.dart
│   └── ad_service.dart
├── screens/home_screen.dart
├── widgets/
│   ├── app_header.dart
│   ├── quote_card.dart
│   ├── action_buttons.dart
│   └── ad_banner.dart
└── utils/share_utils.dart
```
