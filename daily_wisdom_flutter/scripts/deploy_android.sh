#!/usr/bin/env bash
# 로컬에서 AAB를 빌드해 Google Play에 업로드한다. (GitHub Actions 워크플로와 같은 동작)
#
# 사용법 (daily_wisdom_flutter 폴더에서)
#   PLAY_SERVICE_ACCOUNT_JSON=~/Downloads/xxx.json ./scripts/deploy_android.sh [track]
#
#   track: internal(기본) | alpha | beta | production
#   --dry-run 을 붙이면 빌드/업로드 없이 인증과 다음 versionCode 만 확인한다.
#
# 필요: flutter, curl, openssl, python3, android/key.properties(업로드 키 서명 정보)
# versionName 은 pubspec.yaml 값을 쓰고, versionCode 는 Play 의 모든 트랙 중 최댓값 + 1 로 정한다.

set -euo pipefail

PACKAGE_NAME="com.railit.dailywisdom"
API="https://androidpublisher.googleapis.com/androidpublisher/v3/applications/$PACKAGE_NAME"
UPLOAD_API="https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications/$PACKAGE_NAME"
AAB="build/app/outputs/bundle/release/app-release.aab"
MAPPING="build/app/outputs/mapping/release/mapping.txt"

TRACK="internal"
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    internal|alpha|beta|production) TRACK="$arg" ;;
    *) echo "알 수 없는 인자: $arg" >&2; exit 1 ;;
  esac
done

cd "$(dirname "$0")/.."

: "${PLAY_SERVICE_ACCOUNT_JSON:?PLAY_SERVICE_ACCOUNT_JSON 에 서비스 계정 JSON 경로를 지정하세요}"
if [ ! -f "$PLAY_SERVICE_ACCOUNT_JSON" ]; then
  echo "서비스 계정 JSON 을 찾을 수 없습니다: $PLAY_SERVICE_ACCOUNT_JSON" >&2
  exit 1
fi
if [ "$DRY_RUN" = false ] && [ ! -f android/key.properties ]; then
  # 없으면 build.gradle.kts 가 debug 키로 서명해 업로드가 거부된다.
  echo "android/key.properties 가 없습니다. 업로드 키 서명 정보가 필요합니다." >&2
  exit 1
fi

json_get() { python3 -c "import json,sys; print(json.load(sys.stdin)$1)"; }

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# --- 서비스 계정으로 OAuth 액세스 토큰 발급 (JWT bearer) ---
b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

CLIENT_EMAIL="$(json_get "['client_email']" < "$PLAY_SERVICE_ACCOUNT_JSON")"
json_get "['private_key']" < "$PLAY_SERVICE_ACCOUNT_JSON" > "$TMP_DIR/key.pem"

NOW="$(date +%s)"
HEADER="$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)"
CLAIMS="$(printf '{"iss":"%s","scope":"https://www.googleapis.com/auth/androidpublisher","aud":"https://oauth2.googleapis.com/token","iat":%d,"exp":%d}' \
  "$CLIENT_EMAIL" "$NOW" "$((NOW + 3600))" | b64url)"
SIGNATURE="$(printf '%s.%s' "$HEADER" "$CLAIMS" | openssl dgst -sha256 -sign "$TMP_DIR/key.pem" | b64url)"

ACCESS_TOKEN="$(curl -sS --fail-with-body https://oauth2.googleapis.com/token \
  -d grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer \
  -d assertion="$HEADER.$CLAIMS.$SIGNATURE" | json_get "['access_token']")"

api() { curl -sS --fail-with-body -H "Authorization: Bearer $ACCESS_TOKEN" "$@"; }

# --- 편집(edit) 세션 시작, 다음 versionCode 계산 ---
EDIT_ID="$(api -X POST "$API/edits" | json_get "['id']")"

VERSION_CODE="$(api "$API/edits/$EDIT_ID/tracks" | python3 -c '
import json, sys
tracks = json.load(sys.stdin).get("tracks", [])
codes = [int(c) for t in tracks for r in t.get("releases", []) for c in r.get("versionCodes", [])]
print(max(codes, default=0) + 1)
')"
VERSION_NAME="$(grep -E '^version:' pubspec.yaml | sed -E 's/version:[[:space:]]*([^+]+).*/\1/')"

echo "▶ $PACKAGE_NAME $VERSION_NAME ($VERSION_CODE) → $TRACK"

if [ "$DRY_RUN" = true ]; then
  api -X DELETE "$API/edits/$EDIT_ID" > /dev/null
  echo "dry-run: 인증 및 Play API 접근 확인 완료"
  exit 0
fi

# --- 빌드 ---
flutter pub get
flutter build appbundle --release --build-name="$VERSION_NAME" --build-number="$VERSION_CODE"

# --- 업로드 ---
echo "▶ AAB 업로드 중..."
api -X POST "$UPLOAD_API/edits/$EDIT_ID/bundles?uploadType=media" \
  -H "Content-Type: application/octet-stream" --data-binary "@$AAB" > /dev/null

if [ -f "$MAPPING" ]; then
  echo "▶ mapping.txt 업로드 중..."
  api -X POST "$UPLOAD_API/edits/$EDIT_ID/apks/$VERSION_CODE/deobfuscationFiles/proguard?uploadType=media" \
    -H "Content-Type: application/octet-stream" --data-binary "@$MAPPING" > /dev/null
fi

api -X PUT "$API/edits/$EDIT_ID/tracks/$TRACK" -H "Content-Type: application/json" \
  -d "{\"track\":\"$TRACK\",\"releases\":[{\"versionCodes\":[\"$VERSION_CODE\"],\"status\":\"completed\"}]}" > /dev/null

api -X POST "$API/edits/$EDIT_ID:commit" > /dev/null

echo "✅ $VERSION_NAME ($VERSION_CODE) 을(를) $TRACK 트랙에 배포했습니다."
