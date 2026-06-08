#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p \
  "$ROOT_DIR/sources/kappa-text/upstream-import" \
  "$ROOT_DIR/sources/kappa-mark/upstream-import" \
  "$ROOT_DIR/sources/kappa-mono/upstream-import" \
  "$ROOT_DIR/sources/kappa-spin/upstream-import" \
  "$ROOT_DIR/licenses/kappa-text" \
  "$ROOT_DIR/licenses/kappa-mark" \
  "$ROOT_DIR/licenses/kappa-mono" \
  "$ROOT_DIR/licenses/kappa-spin"

cp "$ROOT_DIR/upstream/readerly/src/Newsreader-VariableFont_opsz,wght.ttf" \
   "$ROOT_DIR/upstream/readerly/src/Newsreader-Italic-VariableFont_opsz,wght.ttf" \
   "$ROOT_DIR/sources/kappa-text/upstream-import/"
cp -R "$ROOT_DIR/upstream/abeezee/sources/." "$ROOT_DIR/sources/kappa-mark/upstream-import/"
cp "$ROOT_DIR/upstream/commit-mono/src/fonts/fontlab/CommitMonoV143-400Regular.otf" \
   "$ROOT_DIR/upstream/commit-mono/src/fonts/fontlab/CommitMonoV143-400Italic.otf" \
   "$ROOT_DIR/upstream/commit-mono/src/fonts/fontlab/CommitMonoV143-700Regular.otf" \
   "$ROOT_DIR/upstream/commit-mono/src/fonts/fontlab/CommitMonoV143-700Italic.otf" \
   "$ROOT_DIR/sources/kappa-mono/upstream-import/"
cp -R "$ROOT_DIR/upstream/comfortaa/sources/." "$ROOT_DIR/sources/kappa-spin/upstream-import/"

cp "$ROOT_DIR/upstream/readerly/LICENSE" "$ROOT_DIR/upstream/readerly/COPYRIGHT" "$ROOT_DIR/upstream/readerly/VERSION" "$ROOT_DIR/licenses/kappa-text/"
cp "$ROOT_DIR/upstream/abeezee/OFL.txt" "$ROOT_DIR/upstream/abeezee/AUTHORS.txt" "$ROOT_DIR/upstream/abeezee/CONTRIBUTORS.txt" "$ROOT_DIR/licenses/kappa-mark/"
cp "$ROOT_DIR/upstream/commit-mono/LICENSE-FONT" "$ROOT_DIR/licenses/kappa-mono/OFL.txt"
cp "$ROOT_DIR/upstream/commit-mono/LICENSE" "$ROOT_DIR/licenses/kappa-mono/MIT-CODE.txt"
cp "$ROOT_DIR/upstream/comfortaa/OFL.txt" "$ROOT_DIR/upstream/comfortaa/AUTHORS.txt" "$ROOT_DIR/upstream/comfortaa/CONTRIBUTORS.txt" "$ROOT_DIR/upstream/comfortaa/FONTLOG.txt" "$ROOT_DIR/licenses/kappa-spin/"

echo "Upstream imports and licenses synchronized."
