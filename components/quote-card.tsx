"use client";

import { Quote } from "@/lib/quotes";
import { cn } from "@/lib/utils";

export interface QuoteCardProps {
  quote: Quote;
  isAnimating?: boolean;
  locale?: "en" | "ko";
}

export function QuoteCard({ quote, isAnimating, locale = "en" }: QuoteCardProps) {
  return (
    <div
      className={cn(
        "relative w-full max-w-md mx-auto",
        "transition-all duration-500 ease-out",
        isAnimating && "opacity-0 scale-95"
      )}
    >
      {/* Main Card */}
      <div className="bg-card rounded-2xl p-8 shadow-sm border border-border">
        {/* Quote Icon */}
        <div className="mb-6">
          <svg
            className="w-10 h-10 text-muted-foreground/30"
            fill="currentColor"
            viewBox="0 0 24 24"
          >
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z" />
          </svg>
        </div>

        {/* Quote Text */}
        <blockquote className="text-xl md:text-2xl font-serif leading-relaxed text-foreground mb-6 text-balance">
          {locale === "ko" && quote.text_ko ? quote.text_ko : quote.text}
        </blockquote>

        {/* Author & Category */}
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-foreground">{quote.author}</p>
            <p className="text-xs text-muted-foreground mt-0.5">{quote.category}</p>
          </div>
        </div>
      </div>
    </div>
  );
}
