#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

mkdir -p \
  "$ROOT_DIR/upstream" \
  "$ROOT_DIR/families/kappa-text" \
  "$ROOT_DIR/families/kappa-mark" \
  "$ROOT_DIR/families/kappa-mono" \
  "$ROOT_DIR/families/kappa-spin" \
  "$ROOT_DIR/sources/kappa-text/upstream-import" \
  "$ROOT_DIR/sources/kappa-text/ufo" \
  "$ROOT_DIR/sources/kappa-text/designspace" \
  "$ROOT_DIR/sources/kappa-text/docs" \
  "$ROOT_DIR/sources/kappa-mark/upstream-import" \
  "$ROOT_DIR/sources/kappa-mark/ufo" \
  "$ROOT_DIR/sources/kappa-mark/designspace" \
  "$ROOT_DIR/sources/kappa-mark/docs" \
  "$ROOT_DIR/sources/kappa-mono/upstream-import" \
  "$ROOT_DIR/sources/kappa-mono/ufo" \
  "$ROOT_DIR/sources/kappa-mono/designspace" \
  "$ROOT_DIR/sources/kappa-mono/docs" \
  "$ROOT_DIR/sources/kappa-spin/upstream-import" \
  "$ROOT_DIR/sources/kappa-spin/ufo" \
  "$ROOT_DIR/sources/kappa-spin/designspace" \
  "$ROOT_DIR/sources/kappa-spin/docs" \
  "$ROOT_DIR/fonts/kappa-text" \
  "$ROOT_DIR/fonts/kappa-mark" \
  "$ROOT_DIR/fonts/kappa-mono" \
  "$ROOT_DIR/fonts/kappa-spin" \
  "$ROOT_DIR/proofs" \
  "$ROOT_DIR/licenses/kappa-text" \
  "$ROOT_DIR/licenses/kappa-mark" \
  "$ROOT_DIR/licenses/kappa-mono" \
  "$ROOT_DIR/licenses/kappa-spin"

clone_if_missing() {
  local url="$1"
  local dir="$2"
  if [[ ! -d "$dir/.git" ]]; then
    git clone --depth 1 "$url" "$dir"
  fi
}

clone_if_missing "https://github.com/nicoverbruggen/readerly" "$ROOT_DIR/upstream/readerly"
clone_if_missing "https://github.com/googlefonts/abeezee" "$ROOT_DIR/upstream/abeezee"
clone_if_missing "https://github.com/eigilnikolajsen/commit-mono" "$ROOT_DIR/upstream/commit-mono"
clone_if_missing "https://github.com/googlefonts/comfortaa" "$ROOT_DIR/upstream/comfortaa"

"$ROOT_DIR/scripts/sync-upstream-imports.sh"

if [[ ! -d "$VENV_DIR" ]]; then
  python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip
python -m pip install fonttools brotli gftools fontbakery ufoLib2

echo "Bootstrap complete."
echo "Optional external tools for fuller builds:"
echo "- fontforge"
echo "- ttfautohint"
echo "- font-patcher (for Nerd Font patching)"
