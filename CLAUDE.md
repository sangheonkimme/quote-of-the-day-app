# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

This repo contains **two separate applications** for the same "Daily Wisdom / Quote of the Day" product:

1. **Next.js landing/privacy site** (repo root) — marketing landing page and privacy policy, written in TypeScript with Next.js 16 (App Router), React 19, Tailwind CSS v4, and shadcn/Radix UI components.
   - `app/` — App Router pages (`page.tsx` landing, `privacy/page.tsx`)
   - `components/` — UI components (shadcn-style, configured via `components.json`)
   - `hooks/`, `lib/`, `styles/`
   - Package manager: **pnpm** (see `pnpm-lock.yaml`)

2. **Flutter mobile app** in `daily_wisdom_flutter/` — the actual Daily Wisdom app shipped to users.
   - `lib/main.dart`, with `screens/` (home, favorites, notifications, settings), `services/` (quote, storage, notification, notification_storage), `models/`, `widgets/`, `data/`, `config/`, `l10n/`
   - Localized via `l10n.yaml` / `lib/l10n`
   - Local notifications including a daily 8 AM alarm and an in-app notification inbox (see recent commits)

The two apps are independent — there is no shared code or build between them.

## Common commands

### Next.js site (repo root)
```bash
pnpm install
pnpm dev      # next dev
pnpm build    # next build
pnpm start    # next start
pnpm lint     # eslint .
```

### Flutter app (`daily_wisdom_flutter/`)
```bash
cd daily_wisdom_flutter
flutter pub get
flutter run
flutter test
flutter test test/path/to/file_test.dart   # single test file
flutter build apk --release       # APK -> build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release # AAB -> build/app/outputs/bundle/release/app-release.aab (Play Store)
```

## Notes

- Commit messages in this repo follow a Korean `타입 : 설명` style (e.g. `feat : ...`, `docs : ...`).
- Implementation planning docs for the Flutter app live in `docs/flutter-implementation-plan.md` and `docs/flutter-implementation-checklist.md` — consult these before making structural changes to the Flutter side.
