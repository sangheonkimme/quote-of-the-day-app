"use client";

import { useState, useCallback } from "react";
import { MobileFrame } from "@/components/mobile-frame";
import { QuoteCard } from "@/components/quote-card";
import { ActionButtons } from "@/components/action-buttons";
import { AppHeader } from "@/components/app-header";
import { AdBanner } from "@/components/ad-banner";
import { getDailyQuote, getRandomQuote, Quote } from "@/lib/quotes";

export default function Home() {
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

  return (
    <main className="min-h-screen bg-muted py-8 px-4">
      {/* Page Header */}
      <div className="text-center mb-8">
        <h1 className="text-2xl md:text-3xl font-semibold text-foreground mb-2">
          Quote of the Day App
        </h1>
        <p className="text-muted-foreground text-sm max-w-md mx-auto">
          Flutter app design prototype - Minimal and clean UI for daily inspirational quotes
        </p>
      </div>

      {/* Mobile Preview */}
      <MobileFrame>
        <div className="flex flex-col h-full">
          {/* App Header */}
          <AppHeader />

          {/* Main Content */}
          <div className="flex-1 flex flex-col justify-center px-4 py-6">
            <QuoteCard quote={quote} isAnimating={isAnimating} />
            <ActionButtons
              quote={quote}
              onRefresh={handleRefresh}
              isRefreshing={isRefreshing}
            />
          </div>

          {/* Ad Banner (placeholder for monetization) */}
          <AdBanner />
        </div>
      </MobileFrame>

      {/* Feature Notes */}
      <div className="mt-12 max-w-2xl mx-auto">
        <h2 className="text-lg font-semibold text-foreground mb-4 text-center">
          MVP Features
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <FeatureCard
            title="Quote of the Day"
            description="Display a fresh inspirational quote each day based on date"
          />
          <FeatureCard
            title="Random Refresh"
            description="Tap to get a new random quote from the collection"
          />
          <FeatureCard
            title="Share Feature"
            description="Native share or copy to clipboard functionality"
          />
          <FeatureCard
            title="Push Notifications"
            description="Daily quote notification at 8 AM"
          />
          <FeatureCard
            title="Ad Monetization"
            description="Banner ad placement for revenue"
          />
          <FeatureCard
            title="1,000+ Quotes"
            description="Large collection of curated quotes"
          />
        </div>
      </div>
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
