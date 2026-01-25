"use client";

import { Bell, Settings } from "lucide-react";
import { Button } from "@/components/ui/button";

interface AppHeaderProps {
  title?: string;
}

export function AppHeader({ title = "Daily Wisdom" }: AppHeaderProps) {
  return (
    <header className="flex items-center justify-between px-6 py-4">
      <div>
        <h1 className="text-lg font-semibold text-foreground">{title}</h1>
        <p className="text-xs text-muted-foreground">
          {new Date().toLocaleDateString('en-US', { 
            weekday: 'long',
            month: 'short',
            day: 'numeric'
          })}
        </p>
      </div>
      <div className="flex items-center gap-2">
        <Button variant="ghost" size="icon" className="rounded-full w-10 h-10">
          <Bell className="w-5 h-5 text-muted-foreground" />
          <span className="sr-only">Notifications</span>
        </Button>
        <Button variant="ghost" size="icon" className="rounded-full w-10 h-10">
          <Settings className="w-5 h-5 text-muted-foreground" />
          <span className="sr-only">Settings</span>
        </Button>
      </div>
    </header>
  );
}
