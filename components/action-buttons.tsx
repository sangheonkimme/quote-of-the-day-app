"use client";

import { Button } from "@/components/ui/button";
import { Quote } from "@/lib/quotes";
import { RefreshCw, Share2, Heart, Copy, Check } from "lucide-react";
import { useState } from "react";

interface ActionButtonsProps {
  quote: Quote;
  onRefresh: () => void;
  isRefreshing?: boolean;
}

export function ActionButtons({ quote, onRefresh, isRefreshing }: ActionButtonsProps) {
  const [liked, setLiked] = useState(false);
  const [copied, setCopied] = useState(false);

  const handleShare = async () => {
    const shareText = `"${quote.text}" - ${quote.author}`;
    
    if (navigator.share) {
      try {
        await navigator.share({
          title: "Daily Wisdom",
          text: shareText,
        });
      } catch (err) {
        // User cancelled or error
      }
    } else {
      // Fallback to copy
      handleCopy();
    }
  };

  const handleCopy = async () => {
    const shareText = `"${quote.text}" - ${quote.author}`;
    await navigator.clipboard.writeText(shareText);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleLike = () => {
    setLiked(!liked);
  };

  return (
    <div className="flex items-center justify-center gap-3 mt-8">
      {/* Refresh Button */}
      <Button
        variant="outline"
        size="lg"
        onClick={onRefresh}
        disabled={isRefreshing}
        className="rounded-full px-6 gap-2 bg-transparent"
      >
        <RefreshCw className={`w-4 h-4 ${isRefreshing ? 'animate-spin' : ''}`} />
        <span className="hidden sm:inline">New Quote</span>
      </Button>

      {/* Like Button */}
      <Button
        variant="outline"
        size="icon"
        onClick={handleLike}
        className="rounded-full w-12 h-12 bg-transparent"
      >
        <Heart 
          className={`w-5 h-5 transition-colors ${liked ? 'fill-red-500 text-red-500' : ''}`} 
        />
        <span className="sr-only">Like quote</span>
      </Button>

      {/* Copy Button */}
      <Button
        variant="outline"
        size="icon"
        onClick={handleCopy}
        className="rounded-full w-12 h-12 bg-transparent"
      >
        {copied ? (
          <Check className="w-5 h-5 text-green-600" />
        ) : (
          <Copy className="w-5 h-5" />
        )}
        <span className="sr-only">Copy quote</span>
      </Button>

      {/* Share Button */}
      <Button
        variant="outline"
        size="icon"
        onClick={handleShare}
        className="rounded-full w-12 h-12 bg-transparent"
      >
        <Share2 className="w-5 h-5" />
        <span className="sr-only">Share quote</span>
      </Button>
    </div>
  );
}
