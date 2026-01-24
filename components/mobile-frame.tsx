"use client";

import { ReactNode } from "react";

interface MobileFrameProps {
  children: ReactNode;
}

export function MobileFrame({ children }: MobileFrameProps) {
  return (
    <div className="relative mx-auto w-full max-w-[380px]">
      {/* Phone Frame */}
      <div className="relative bg-foreground rounded-[3rem] p-3 shadow-2xl">
        {/* Screen */}
        <div className="relative bg-background rounded-[2.5rem] overflow-hidden">
          {/* Status Bar */}
          <div className="flex items-center justify-between px-8 py-3 bg-background">
            <span className="text-xs font-medium text-foreground">9:41</span>
            <div className="flex items-center gap-1">
              <svg className="w-4 h-4 text-foreground" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 3C8.5 3 5.5 4.5 3.5 7L2 5.5C4.5 2.5 8 1 12 1s7.5 1.5 10 4.5L20.5 7C18.5 4.5 15.5 3 12 3zm0 4c-2.3 0-4.4 1-5.9 2.5L4.5 8C6.5 5.8 9.1 4.5 12 4.5s5.5 1.3 7.5 3.5l-1.6 1.5C16.4 8 14.3 7 12 7zm0 4c-1.2 0-2.3.5-3.1 1.2L7.3 10.7C8.6 9.6 10.2 9 12 9s3.4.6 4.7 1.7l-1.6 1.5C14.3 11.5 13.2 11 12 11zm0 4c-.6 0-1.1.2-1.6.5L9 14c.8-.7 1.9-1 3-1s2.2.4 3 1l-1.4 1.5c-.5-.3-1-.5-1.6-.5zm0 2a1 1 0 100 2 1 1 0 000-2z"/>
              </svg>
              <svg className="w-4 h-4 text-foreground" fill="currentColor" viewBox="0 0 24 24">
                <path d="M17 4h-3V2h-4v2H7v18h10V4zm-3 16h-4v-2h4v2zm0-4h-4v-8h4v8z"/>
              </svg>
            </div>
          </div>

          {/* Dynamic Island / Notch */}
          <div className="absolute top-3 left-1/2 -translate-x-1/2 w-28 h-7 bg-foreground rounded-full" />

          {/* Content */}
          <div className="min-h-[600px]">
            {children}
          </div>

          {/* Home Indicator */}
          <div className="flex justify-center pb-2 pt-4">
            <div className="w-32 h-1 bg-foreground/20 rounded-full" />
          </div>
        </div>
      </div>
    </div>
  );
}
