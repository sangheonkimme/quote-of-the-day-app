"use client";

import { useState, useCallback } from "react";
import { MobileFrame } from "@/components/mobile-frame";
import { QuoteCard } from "@/components/quote-card";
import { ActionButtons } from "@/components/action-buttons";
import { AppHeader } from "@/components/app-header";
import { AdBanner } from "@/components/ad-banner";
import { getDailyQuote, getRandomQuote, Quote } from "@/lib/quotes";
import { useI18n } from "@/lib/i18n-context";

export default function Home() {
  const { locale, setLocale, t } = useI18n();
  const [quote, setQuote] = useState<Quote>(getDailyQuote);
  const [isAnimating, setIsAnimating] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = useCallback(() => {
    setIsRefreshing(true);
    setIsAnimating(true);

    setTimeout(() => {
      setQuote(getRandomQuote());
      setIsAnimating(false);
      setIsRefreshing(false);
    }, 300);
  }, []);

  const toggleLocale = () => {
    setLocale(locale === "en" ? "ko" : "en");
  };

  return (
    <main className="min-h-screen bg-muted py-8 px-4">
      {/* Language Toggle */}
      <div className="absolute top-4 right-4">
        <button
          onClick={toggleLocale}
          className="px-3 py-1.5 text-sm bg-card border border-border rounded-lg hover:bg-muted transition-colors cursor-pointer"
        >
          {locale === "en" ? "한국어" : "English"}
        </button>
      </div>

      {/* Page Header */}
      <div className="text-center mb-8">
        <h1 className="text-2xl md:text-3xl font-semibold text-foreground mb-2">
          {t.pageTitle}
        </h1>
        <p className="text-muted-foreground text-sm max-w-md mx-auto">
          {t.pageDescription}
        </p>
      </div>

      {/* Mobile Preview */}
      <MobileFrame>
        <div className="flex flex-col h-full">
          {/* App Header */}
          <AppHeader title={t.appHeader} />

          {/* Main Content */}
          <div className="flex-1 flex flex-col justify-center px-4 py-6">
            <QuoteCard quote={quote} isAnimating={isAnimating} locale={locale} />
            <ActionButtons
              quote={quote}
              onRefresh={handleRefresh}
              isRefreshing={isRefreshing}
              newQuoteLabel={t.newQuote}
            />
          </div>

          {/* Ad Banner (placeholder for monetization) */}
          <AdBanner label={t.adLabel} />
        </div>
      </MobileFrame>

      {/* Feature Notes */}
      <div className="mt-12 max-w-2xl mx-auto">
        <h2 className="text-lg font-semibold text-foreground mb-4 text-center">
          {t.mvpFeatures}
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <FeatureCard
            title={t.features.quoteOfDay.title}
            description={t.features.quoteOfDay.description}
          />
          <FeatureCard
            title={t.features.randomRefresh.title}
            description={t.features.randomRefresh.description}
          />
          <FeatureCard
            title={t.features.share.title}
            description={t.features.share.description}
          />
          <FeatureCard
            title={t.features.notifications.title}
            description={t.features.notifications.description}
          />
          <FeatureCard
            title={t.features.ads.title}
            description={t.features.ads.description}
          />
          <FeatureCard
            title={t.features.quotes.title}
            description={t.features.quotes.description}
          />
        </div>
      </div>

      {/* Footer */}
      <footer className="mt-12 text-center">
        <a
          href="/privacy"
          className="text-muted-foreground hover:text-foreground text-sm underline"
        >
          {t.privacyPolicy}
        </a>
      </footer>
    </main>
  );
}

function FeatureCard({ title, description }: { title: string; description: string }) {
  return (
    <div className="bg-card rounded-xl p-4 border border-border">
      <h3 className="font-medium text-foreground mb-1">{title}</h3>
      <p className="text-sm text-muted-foreground">{description}</p>
    </div>
  );
}
