#!/usr/bin/env bash
# SNS 게시용 명언 카드를 한 번에 PNG로 뽑는다.
#
# 사용법 (daily_wisdom_flutter 폴더에서)
#   ./scripts/export_cards.sh [옵션]
#
#   --days 30              며칠치를 뽑을지 (기본 30)
#   --start 2026-10-01     시작 날짜 (기본 오늘)
#   --locales ko,en        언어 (기본 ko,en)
#   --formats feed,story   feed=1080x1350(4:5), story=1080x1920(9:16)
#   --out build/cards      저장 위치 (기본 build/cards)
#   --quotes cards.json    직접 고른 명언 목록으로 카드 생성 (날짜별 자동 선택 대신)
#                          [{"name","text","author","category","format","appName"}]
#
# 앱의 공유 카드 위젯을 그대로 써서 앱에서 공유한 것과 똑같은 이미지가 나온다.
# macOS 앱으로 잠깐 실행되며, 샌드박스 안에 만든 파일을 --out 위치로 복사한다.

set -euo pipefail

DAYS=30
START=""
LOCALES="ko,en"
FORMATS="feed,story"
OUT="build/cards"
QUOTES=""

while [ $# -gt 0 ]; do
  case "$1" in
    --days) DAYS="$2"; shift 2 ;;
    --start) START="$2"; shift 2 ;;
    --locales) LOCALES="$2"; shift 2 ;;
    --formats) FORMATS="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --quotes) QUOTES="$2"; shift 2 ;;
    *) echo "알 수 없는 인자: $1" >&2; exit 1 ;;
  esac
done

cd "$(dirname "$0")/.."

LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT

QUOTES_B64=""
if [ -n "$QUOTES" ]; then
  [ -f "$QUOTES" ] || { echo "명언 목록 파일을 찾을 수 없습니다: $QUOTES" >&2; exit 1; }
  QUOTES_B64="$(base64 -i "$QUOTES" | tr -d '\n')"
  echo "▶ 지정한 명언으로 카드 생성 중 ($QUOTES)..."
else
  echo "▶ ${DAYS}일치 카드 생성 중 (${LOCALES} / ${FORMATS})..."
fi

flutter run -d macos -t lib/tools/export_cards.dart \
  --dart-define=QUOTES_B64="$QUOTES_B64" \
  --dart-define=DAYS="$DAYS" \
  --dart-define=START="$START" \
  --dart-define=LOCALES="$LOCALES" \
  --dart-define=FORMATS="$FORMATS" \
  2>&1 | tee "$LOG" | grep --line-buffered -E "^\[export\]|^Error|^Exception" || true

SRC="$(grep -m1 -o 'OUTPUT_DIR=.*' "$LOG" | cut -d= -f2- | tr -d '\r')"
if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
  echo "카드 생성에 실패했습니다. 전체 로그를 보려면 아래 명령을 직접 실행하세요." >&2
  echo "  flutter run -d macos -t lib/tools/export_cards.dart" >&2
  exit 1
fi

mkdir -p "$OUT"
rm -rf "${OUT:?}"/*
cp -R "$SRC"/* "$OUT"/

echo "✅ $(find "$OUT" -name '*.png' | wc -l | tr -d ' ')개 카드 → $OUT"
echo "   명언 목록(캡션 작성용): $OUT/index.txt"
