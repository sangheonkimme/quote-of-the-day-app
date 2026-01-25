export const translations = {
  en: {
    pageTitle: "Quote of the Day App",
    pageDescription: "Minimal and clean UI for daily inspirational quotes",
    mvpFeatures: "MVP Features",
    features: {
      quoteOfDay: {
        title: "Quote of the Day",
        description: "Display a fresh inspirational quote each day based on date",
      },
      randomRefresh: {
        title: "Random Refresh",
        description: "Tap to get a new random quote from the collection",
      },
      share: {
        title: "Share Feature",
        description: "Native share or copy to clipboard functionality",
      },
      notifications: {
        title: "Push Notifications",
        description: "Daily quote notification at 8 AM",
      },
      ads: {
        title: "Ad Monetization",
        description: "Banner ad placement for revenue",
      },
      quotes: {
        title: "1,000+ Quotes",
        description: "Large collection of curated quotes",
      },
    },
    privacyPolicy: "Privacy Policy",
    appHeader: "Daily Wisdom",
    newQuote: "New Quote",
    adLabel: "Advertisement",
  },
  ko: {
    pageTitle: "오늘의 명언 앱",
    pageDescription: "매일 영감을 주는 명언을 위한 미니멀하고 깔끔한 UI",
    mvpFeatures: "MVP 기능",
    features: {
      quoteOfDay: {
        title: "오늘의 명언",
        description: "날짜에 따라 매일 새로운 영감을 주는 명언 표시",
      },
      randomRefresh: {
        title: "랜덤 새로고침",
        description: "탭 한 번으로 컬렉션에서 새로운 명언 발견",
      },
      share: {
        title: "공유 기능",
        description: "네이티브 공유 또는 클립보드 복사 기능",
      },
      notifications: {
        title: "푸시 알림",
        description: "매일 아침 8시 명언 알림",
      },
      ads: {
        title: "광고 수익화",
        description: "수익을 위한 배너 광고 배치",
      },
      quotes: {
        title: "1,000개 이상의 명언",
        description: "엄선된 명언 컬렉션",
      },
    },
    privacyPolicy: "개인정보처리방침",
    appHeader: "오늘의 명언",
    newQuote: "새 명언",
    adLabel: "광고",
  },
} as const;

export type Locale = keyof typeof translations;
export type Translations = typeof translations.en;
