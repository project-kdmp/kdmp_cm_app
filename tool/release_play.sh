#!/usr/bin/env bash
#
# 릴리스 빌드부터 Play 내부 테스트 트랙 업로드까지 한 번에 돈다.
#
#   tool/release_play.sh            # 검사 → 빌드 → 업로드
#   tool/release_play.sh --dry-run  # 검사와 빌드까지만, 업로드는 하지 않는다
#
# 프로덕션 승격은 이 스크립트가 하지 않는다. Play Console 에서 사람이 누른다.

set -euo pipefail

cd "$(dirname "$0")/.."
REPO_ROOT="$(pwd)"

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

say() { printf '\n\033[1m▸ %s\033[0m\n' "$1"; }
die() { printf '\n\033[31m✗ %s\033[0m\n' "$1" >&2; exit 1; }

# ─── 1. 올릴 수 있는 상태인가 ────────────────────────────────────────────────

say "사전 점검"

[[ -n "$(git status --porcelain)" ]] &&
  die "작업트리에 커밋하지 않은 변경이 있다. 산출물이 어느 커밋인지 말할 수 없으면 올리지 않는다."

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
COMMIT="$(git rev-parse --short HEAD)"
echo "  브랜치 $BRANCH · 커밋 $COMMIT"

VERSION_LINE="$(grep '^version:' pubspec.yaml)"
VERSION_NAME="${VERSION_LINE#version: }"; VERSION_NAME="${VERSION_NAME%%+*}"
VERSION_CODE="${VERSION_LINE##*+}"
echo "  버전 $VERSION_NAME($VERSION_CODE)"

# 서비스 계정 키
CREDENTIALS="${PLAY_SERVICE_ACCOUNT_JSON:-$REPO_ROOT/android/play-service-account.json}"
if [[ $DRY_RUN -eq 0 && ! -f "$CREDENTIALS" ]]; then
  die "Play 서비스 계정 키가 없다: $CREDENTIALS
     docs/deploy-play.md 의 발급 절차를 먼저 따른다."
fi

# 빌드에 필요한 로컬 파일 (전부 gitignore 대상이라 없을 수 있다).
# Firebase 설정 파일(google-services.json)은 이 저장소에 없다 —
# lib/firebase_options.dart 로만 설정하고 Gradle 플러그인을 쓰지 않는다
KEYSTORE="android/$(sed -n 's/^storeFile=\.\.\///p' android/key.properties)"
for f in .env android/key.properties "$KEYSTORE"; do
  [[ -f "$f" ]] || die "$f 가 없다. 이 파일들은 저장소에 담기지 않는다."
done

# ─── 2. 출시노트 ────────────────────────────────────────────────────────────

say "출시노트"

NOTES_SRC="docs/release-notes/${VERSION_NAME}.md"
[[ -f "$NOTES_SRC" ]] ||
  die "$NOTES_SRC 가 없다. 무엇이 바뀌었는지 적지 않은 채로 올리지 않는다."

NOTES_DIR="android/app/src/main/play/release-notes/ko-KR"
mkdir -p "$NOTES_DIR"

# 첫 코드블록이 스토어 붙여넣기용 본문이다
python3 - "$NOTES_SRC" "$NOTES_DIR/default.txt" <<'PY'
import re, sys

src, dst = sys.argv[1], sys.argv[2]
text = open(src, encoding="utf-8").read()

match = re.search(r"^```\n(.*?)\n```", text, re.S | re.M)
if not match:
    sys.exit(f"{src} 에서 스토어 본문(코드블록)을 찾지 못했다.")

body = match.group(1).strip()

# Play Console 은 언어당 500자까지 받는다. 넘으면 업로드가 거부된다
if len(body) > 500:
    sys.exit(f"스토어 본문이 {len(body)}자다. 500자를 넘으면 Play 가 거부한다.")

open(dst, "w", encoding="utf-8").write(body + "\n")
print(f"  {len(body)}자 / 500 → {dst}")
PY

# ─── 3. 빌드 ────────────────────────────────────────────────────────────────

say "릴리스 빌드"

# head 로 바로 파이프하면 flutter 가 닫힌 파이프에 쓰다 터진다. 먼저 담는다
FLUTTER_VERSION="$(fvm flutter --version)"
echo "  ${FLUTTER_VERSION%%$'\n'*}"

fvm flutter pub get
fvm dart analyze lib || die "정적 분석에서 에러가 났다."
fvm flutter build appbundle --release

AAB="build/app/outputs/bundle/release/app-release.aab"
[[ -f "$AAB" ]] || die "$AAB 가 만들어지지 않았다."

# 업로드 키로 서명됐는지 확인한다 — 디버그 키로 서명된 것을 올리면 Play 가 거부한다
unzip -l "$AAB" | grep -qE 'META-INF/.*\.(RSA|DSA|EC)' ||
  die "서명이 확인되지 않는다. android/key.properties 를 확인한다."

echo "  $AAB ($(du -h "$AAB" | cut -f1))"

# ─── 4. 업로드 ──────────────────────────────────────────────────────────────

if [[ $DRY_RUN -eq 1 ]]; then
  say "--dry-run 이므로 업로드하지 않는다"
  exit 0
fi

say "Play 내부 테스트 트랙 업로드"

cd android
PLAY_SERVICE_ACCOUNT_JSON="$CREDENTIALS" ./gradlew publishBundle --no-daemon

say "끝. $VERSION_NAME($VERSION_CODE) · 커밋 $COMMIT · internal 트랙"
echo "  프로덕션 승격은 Play Console 에서 사람이 누른다."
