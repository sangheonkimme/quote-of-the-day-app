"use client";

export function AdBanner() {
  return (
    <div className="mx-6 mb-4">
      <div className="bg-secondary rounded-xl p-4 text-center border border-border">
        <p className="text-[10px] text-muted-foreground uppercase tracking-wider mb-1">Advertisement</p>
        <div className="h-12 flex items-center justify-center">
          <p className="text-xs text-muted-foreground">Ad space - AdMob / Google Ads</p>
        </div>
      </div>
    </div>
  );
}
