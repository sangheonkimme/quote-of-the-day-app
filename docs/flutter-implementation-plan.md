# Daily Wisdom - Flutter App Implementation Plan

## Overview

Next.js 프로토타입을 기반으로 한 Flutter 앱 구현 계획서입니다.
디자인과 기능을 동일하게 구현합니다.

### App Concept
- **로그인 없음** - 가볍게 바로 사용 가능
- **오프라인 지원** - 모든 명언 데이터 로컬 저장
- **최소 권한** - 알림 권한만 필요 (선택)
- **빠른 실행** - 즉시 명언 표시

---

## 1. Project Structure

```
lib/
├── main.dart
├── app/
│   └── app.dart                    # MaterialApp 설정
├── config/
│   ├── theme.dart                  # 테마 설정 (색상, 폰트)
│   └── constants.dart              # 상수 정의
├── models/
│   └── quote.dart                  # Quote 데이터 모델
├── data/
│   └── quotes_data.dart            # 50+ quotes 데이터
├── services/
│   ├── quote_service.dart          # 일일 명언, 랜덤 명언 로직
│   ├── notification_service.dart   # Push Notification (매일 오전 8시)
│   ├── storage_service.dart        # SharedPreferences (좋아요 저장)
│   └── ad_service.dart             # AdMob 설정
├── screens/
│   └── home_screen.dart            # 메인 홈 화면
├── widgets/
│   ├── app_header.dart             # 상단 헤더 (Daily Wisdom + 날짜 + 아이콘)
│   ├── quote_card.dart             # 명언 카드 위젯
│   ├── action_buttons.dart         # 액션 버튼 그룹
│   └── ad_banner.dart              # 광고 배너
└── utils/
    └── share_utils.dart            # 공유/복사 유틸리티
```

---

## 2. Design Specifications (디자인 명세)

### 2.1 Color Palette

```dart
// Light Theme (기본)
static const Color background = Color(0xFFF5F5F5);      // 밝은 회색 배경
static const Color cardBackground = Color(0xFFFFFFFF);  // 흰색 카드
static const Color foreground = Color(0xFF1A1A1A);      // 검정 텍스트
static const Color mutedForeground = Color(0xFF737373); // 회색 텍스트
static const Color border = Color(0xFFE5E5E5);          // 테두리 색상
```

### 2.2 Typography

```dart
// App Header
"Daily Wisdom"     : 18sp, FontWeight.w600, foreground
날짜 (Friday, Jan 23) : 12sp, FontWeight.w400, mutedForeground

// Quote Card
Quote Icon        : 40x40, mutedForeground (opacity 0.3)
Quote Text        : 24sp, Serif Font, FontWeight.w400, foreground
Author            : 14sp, FontWeight.w500, foreground
Category          : 12sp, FontWeight.w400, mutedForeground
```

### 2.3 Layout Specifications

```
┌─────────────────────────────────────────┐
│ [Header]                                │
│  Daily Wisdom              🔔  ⚙️      │
│  Friday, Jan 23                         │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  "                              │   │
│  │                                 │   │
│  │  If you want to lift           │   │
│  │  yourself up, lift             │   │
│  │  up someone else.              │   │
│  │                                 │   │
│  │  Booker T. Washington          │   │
│  │  Kindness                      │   │
│  └─────────────────────────────────┘   │
│                                         │
│     [🔄 New Quote] [♡] [📋] [↗️]        │
│                                         │
├─────────────────────────────────────────┤
│ [Ad Banner]                             │
│  ADVERTISEMENT                          │
│  Ad space - AdMob / Google Ads          │
└─────────────────────────────────────────┘
```

### 2.4 Component Dimensions

| Component | Specification |
|-----------|--------------|
| Quote Card | padding: 32px, borderRadius: 16px, shadow: sm |
| Quote Icon | 40x40px, opacity 0.3 |
| Action Buttons | height: 48px, borderRadius: 24px (circular) |
| New Quote Button | padding horizontal: 24px |
| Icon Buttons | 48x48px, circular |
| Ad Banner | padding: 16px, borderRadius: 12px |

---

## 3. Widget Implementation Details

### 3.1 AppHeader Widget

```dart
// 구조
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Wisdom"),  // 18sp, semibold
        Text("Friday, Jan 23"), // 12sp, muted
      ],
    ),
    Row(
      children: [
        IconButton(Bell),      // 40x40, ghost style
        IconButton(Settings),  // 40x40, ghost style
      ],
    ),
  ],
)
```

### 3.2 QuoteCard Widget

```dart
Container(
  padding: EdgeInsets.all(32),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderColor),
    boxShadow: [/* subtle shadow */],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Quote Icon (")
      SvgPicture or Icon, // 40x40, opacity 0.3
      SizedBox(height: 24),

      // Quote Text
      Text(
        quote.text,
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Serif', // Georgia or similar
          height: 1.4,
        ),
      ),
      SizedBox(height: 24),

      // Author & Category
      Text(quote.author),    // 14sp, medium
      SizedBox(height: 2),
      Text(quote.category),  // 12sp, muted
    ],
  ),
)
```

### 3.3 ActionButtons Widget

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // New Quote Button (with text)
    OutlinedButton.icon(
      icon: Icon(Icons.refresh),
      label: Text("New Quote"),
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    SizedBox(width: 12),

    // Heart Button (toggle)
    _CircularIconButton(
      icon: liked ? Icons.favorite : Icons.favorite_border,
      color: liked ? Colors.red : null,
    ),
    SizedBox(width: 12),

    // Copy Button
    _CircularIconButton(icon: Icons.copy_outlined),
    SizedBox(width: 12),

    // Share Button
    _CircularIconButton(icon: Icons.share_outlined),
  ],
)
```

### 3.4 AdBanner Widget

```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: 24),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFF5F5F5),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderColor),
  ),
  child: Column(
    children: [
      Text(
        "ADVERTISEMENT",
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 1.2,
          color: mutedForeground,
        ),
      ),
      SizedBox(height: 4),
      // AdMob BannerAd Widget
      AdWidget(ad: bannerAd),
    ],
  ),
)
```

---

## 4. Data Model

### 4.1 Quote Model

```dart
class Quote {
  final int id;
  final String text;
  final String author;
  final String category;

  const Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
  });
}
```

### 4.2 Sample Quotes Data (50개)

```dart
const List<Quote> quotes = [
  Quote(
    id: 1,
    text: "The only way to do great work is to love what you do.",
    author: "Steve Jobs",
    category: "Work",
  ),
  Quote(
    id: 2,
    text: "In the middle of difficulty lies opportunity.",
    author: "Albert Einstein",
    category: "Perseverance",
  ),
  // ... 48 more quotes from lib/quotes.ts
];
```

---

## 5. Core Services

### 5.1 QuoteService

```dart
class QuoteService {
  // 날짜 기반 일일 명언 (매일 동일한 명언)
  Quote getDailyQuote() {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final index = seed % quotes.length;
    return quotes[index];
  }

  // 랜덤 명언
  Quote getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}
```

### 5.2 NotificationService

```dart
class NotificationService {
  // flutter_local_notifications 패키지 사용

  Future<void> scheduleDailyNotification() async {
    // 매일 오전 8시에 명언 알림
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Wisdom',
      getDailyQuote().text,
      _nextInstanceOf8AM(),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
```

### 5.3 StorageService

```dart
class StorageService {
  // SharedPreferences로 좋아요한 명언 ID 저장

  Future<void> toggleLike(int quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('liked_quotes') ?? [];

    if (liked.contains(quoteId.toString())) {
      liked.remove(quoteId.toString());
    } else {
      liked.add(quoteId.toString());
    }

    await prefs.setStringList('liked_quotes', liked);
  }

  Future<bool> isLiked(int quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('liked_quotes') ?? [];
    return liked.contains(quoteId.toString());
  }
}
```

---

## 6. Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Local Storage
  shared_preferences: ^2.2.2

  # Notifications
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.2

  # Ads
  google_mobile_ads: ^4.0.0

  # Share
  share_plus: ^7.2.1

  # UI
  flutter_svg: ^2.0.9

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

---

## 7. MVP Features Checklist

| Feature | Description | Implementation |
|---------|-------------|----------------|
| Quote of the Day | 날짜 기반 일일 명언 | `QuoteService.getDailyQuote()` |
| Random Refresh | 새로고침 버튼으로 랜덤 명언 | `QuoteService.getRandomQuote()` |
| Share Feature | 네이티브 공유 | `share_plus` 패키지 |
| Copy to Clipboard | 클립보드 복사 | `Clipboard.setData()` |
| Like/Favorite | 좋아요 토글 | `SharedPreferences` |
| Push Notifications | 매일 오전 8시 알림 | `flutter_local_notifications` |
| Ad Monetization | 배너 광고 | `google_mobile_ads` |
| 50+ Quotes | 명언 컬렉션 | 정적 데이터 |

---

## 8. Animation Specifications

### 8.1 Quote Transition Animation

```dart
// New Quote 버튼 클릭 시
AnimatedOpacity(
  opacity: isAnimating ? 0.0 : 1.0,
  duration: Duration(milliseconds: 300),
  child: AnimatedScale(
    scale: isAnimating ? 0.95 : 1.0,
    duration: Duration(milliseconds: 300),
    child: QuoteCard(quote: currentQuote),
  ),
)
```

### 8.2 Refresh Icon Animation

```dart
// isRefreshing 상태일 때
AnimatedRotation(
  turns: isRefreshing ? 1 : 0,
  duration: Duration(milliseconds: 500),
  child: Icon(Icons.refresh),
)
```

### 8.3 Heart Animation

```dart
// 좋아요 클릭 시
AnimatedScale(
  scale: liked ? 1.2 : 1.0,
  duration: Duration(milliseconds: 150),
  child: Icon(
    liked ? Icons.favorite : Icons.favorite_border,
    color: liked ? Colors.red : null,
  ),
)
```

---

## 9. Screen Implementation

### 9.1 HomeScreen

```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Quote _currentQuote;
  bool _isAnimating = false;
  bool _isRefreshing = false;
  bool _isLiked = false;

  final QuoteService _quoteService = QuoteService();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _currentQuote = _quoteService.getDailyQuote();
    _checkLikedStatus();
  }

  void _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
      _isAnimating = true;
    });

    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      _currentQuote = _quoteService.getRandomQuote();
      _isAnimating = false;
      _isRefreshing = false;
    });

    _checkLikedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuoteCard(
                        quote: _currentQuote,
                        isAnimating: _isAnimating,
                      ),
                      SizedBox(height: 32),
                      ActionButtons(
                        quote: _currentQuote,
                        isLiked: _isLiked,
                        isRefreshing: _isRefreshing,
                        onRefresh: _handleRefresh,
                        onLike: _handleLike,
                        onCopy: _handleCopy,
                        onShare: _handleShare,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AdBanner(),
          ],
        ),
      ),
    );
  }
}
```

---

## 10. Testing Plan

### 10.1 Unit Tests
- QuoteService: getDailyQuote(), getRandomQuote()
- StorageService: toggleLike(), isLiked()

### 10.2 Widget Tests
- QuoteCard 렌더링
- ActionButtons 상호작용
- AppHeader 날짜 표시

### 10.3 Integration Tests
- 전체 플로우: 앱 실행 → 명언 표시 → 새로고침 → 공유

---

## 11. Build & Deploy

### 11.1 Android
```bash
flutter build apk --release
flutter build appbundle --release  # Play Store 배포용
```

### 11.2 iOS
```bash
flutter build ios --release
# Xcode에서 Archive → App Store Connect 배포
```

### 11.3 AdMob Setup
1. AdMob 계정 생성 및 앱 등록
2. 배너 광고 단위 ID 생성
3. `android/app/src/main/AndroidManifest.xml`에 AdMob App ID 추가
4. `ios/Runner/Info.plist`에 GADApplicationIdentifier 추가

---

## 12. Future Enhancements (Post-MVP)

- [ ] 다크 모드 지원
- [ ] 위젯 (홈 화면 위젯)
- [ ] 명언 카테고리 필터
- [ ] 좋아요한 명언 목록 화면
- [ ] 1,000+ 명언으로 확장
- [ ] 사용자 정의 명언 추가
- [ ] 알림 시간 설정
