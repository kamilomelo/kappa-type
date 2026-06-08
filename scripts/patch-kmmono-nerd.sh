#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT_DIR="$ROOT_DIR/fonts/kappa-mono/ttf"
OUTPUT_DIR="$ROOT_DIR/fonts/kappa-mono/ttf"
RENAMER="$ROOT_DIR/scripts/rename-fonts.py"
PATCHER="${NERD_FONT_PATCHER:-}"

if [[ -z "$PATCHER" ]]; then
  if command -v font-patcher >/dev/null 2>&1; then
    PATCHER="$(command -v font-patcher)"
  elif [[ -x "/tmp/nerd-fonts/font-patcher" ]]; then
    PATCHER="/tmp/nerd-fonts/font-patcher"
  fi
fi

if [[ -z "$PATCHER" || ! -x "$PATCHER" ]]; then
  echo "font-patcher not found. Install Nerd Fonts patcher first or set NERD_FONT_PATCHER." >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

style_from_name() {
  case "$1" in
    *BoldItalic*) printf '%s\n' "Bold Italic" ;;
    *Bold*) printf '%s\n' "Bold" ;;
    *Italic*) printf '%s\n' "Italic" ;;
    *) printf '%s\n' "Regular" ;;
  esac
}

for font_path in "$INPUT_DIR"/*.ttf; do
  [[ -f "$font_path" ]] || continue
  [[ "$(basename "$font_path")" == *"-VF.ttf" ]] && continue

  basename="$(basename "$font_path")"
  style="$(style_from_name "$basename")"
  workdir="$(mktemp -d)"

  "$PATCHER" --complete --careful --outputdir "$workdir" "$font_path"

  patched_path="$(find "$workdir" -maxdepth 1 -type f \( -name '*.ttf' -o -name '*.otf' \) | head -n 1)"
  if [[ -z "$patched_path" ]]; then
    echo "Nerd patching failed for $font_path" >&2
    rm -rf "$workdir"
    exit 1
  fi

  python "$RENAMER" \
    --input "$patched_path" \
    --output "$font_path.tmp" \
    --family "Kappa Mono" \
    --style "$style"
  mv "$font_path.tmp" "$font_path"
  rm -rf "$workdir"
done

echo "Patched Kappa Mono TTFs in place at $OUTPUT_DIR"
