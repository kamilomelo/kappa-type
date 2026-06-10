#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
RENAMER="$ROOT_DIR/scripts/rename-fonts.py"
TMP_DIR="$ROOT_DIR/tmp/build"
FAMILY_ID="${1:-}"
FAMILY_CONF="$ROOT_DIR/families/$FAMILY_ID/family.conf"

if [[ -z "$FAMILY_ID" ]]; then
  echo "usage: $0 <family-id>" >&2
  exit 1
fi

if [[ ! -f "$FAMILY_CONF" ]]; then
  echo "missing family config: $FAMILY_CONF" >&2
  exit 1
fi

source "$FAMILY_CONF"
FONTMAKE_ARGS=()
UFO_SOURCE_DIR="${INSTANCE_UFO_DIR:-$ROOT_DIR/sources/$FAMILY_ID/ufo}"

if [[ -n "${EXTRA_FONTMAKE_ARGS:-}" ]]; then
  # shellcheck disable=SC2206
  FONTMAKE_ARGS=(${EXTRA_FONTMAKE_ARGS})
fi

source "$VENV_DIR/bin/activate"
mkdir -p "$TMP_DIR"

style_from_filename() {
  local name="$1"
  case "$name" in
    *ThinItalic*) printf '%s\n' "Thin Italic" ;;
    *Thin*) printf '%s\n' "Thin" ;;
    *ExtraBoldItalic*) printf '%s\n' "Extra Bold Italic" ;;
    *ExtraBold*) printf '%s\n' "Extra Bold" ;;
    *SemiBoldItalic*) printf '%s\n' "Semi Bold Italic" ;;
    *SemiBold*) printf '%s\n' "Semi Bold" ;;
    *BoldItalic*) printf '%s\n' "Bold Italic" ;;
    *Bold*) printf '%s\n' "Bold" ;;
    *MediumItalic*) printf '%s\n' "Medium Italic" ;;
    *Medium*) printf '%s\n' "Medium" ;;
    *LightItalic*) printf '%s\n' "Light Italic" ;;
    *Light*) printf '%s\n' "Light" ;;
    *Italic*) printf '%s\n' "Italic" ;;
    *) printf '%s\n' "Regular" ;;
  esac
}

filename_stem() {
  local family="$1"
  local style="$2"
  printf '%s-%s' "${family// /}" "${style// /}"
}

build_ufo_family() {
  local key="$1"
  local final_family="$2"
  local format="$3"
  local out_dir="$ROOT_DIR/fonts/$key/$format"
  local workdir="$TMP_DIR/km-$key-$format"

  rm -rf "$workdir"
  mkdir -p "$workdir" "$out_dir"

  for ufo_path in "$UFO_SOURCE_DIR"/*.ufo; do
    [[ -d "$ufo_path" ]] || continue
    local basename style output_name tmp_output
    basename="$(basename "$ufo_path" .ufo)"
    style="$(style_from_filename "$basename")"
    output_name="$(filename_stem "$final_family" "$style").$format"
    tmp_output="$workdir/$output_name"

    fontmake -u "$ufo_path" -o "$format" "${FONTMAKE_ARGS[@]}" --output-path "$tmp_output"
    python "$RENAMER" \
      --input "$tmp_output" \
      --output "$out_dir/$output_name" \
      --family "$final_family" \
      --style "$style"
  done
}

case "$FAMILY_ID" in
  kappa-text) build_ufo_family "kappa-text" "Kappa Text" "ttf" ;;
  kappa-mark) build_ufo_family "kappa-mark" "Kappa Mark" "ttf" ;;
  kappa-form) build_ufo_family "kappa-form" "Kappa Form" "ttf" ;;
  kappa-mono)
    rm -rf "$ROOT_DIR/fonts/kappa-mono/otf"
    rm -f "$ROOT_DIR/fonts/kappa-mono/ttf/KappaMono-VF.ttf"
    rm -f "$ROOT_DIR/fonts/kappa-mono/webfonts/KappaMono-VF.woff2"
    build_ufo_family "kappa-mono" "Kappa Mono" "ttf"
    ;;
  kappa-spin) build_ufo_family "kappa-spin" "Kappa Spin" "ttf" ;;
  *)
    echo "unknown family id: $FAMILY_ID" >&2
    exit 1
    ;;
esac
