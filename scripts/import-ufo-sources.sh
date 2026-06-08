#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

source "$VENV_DIR/bin/activate"

import_abeezee() {
  local workdir="$ROOT_DIR/tmp/import-ufo/kappa-mark"
  local ufo_dir="$ROOT_DIR/sources/kappa-mark/ufo"
  local designspace_dir="$ROOT_DIR/sources/kappa-mark/designspace"
  local master_dir="$ufo_dir/masters"
  local instance_dir="$ufo_dir/instances"

  if [[ -d "$master_dir/regular/KappaMark-Regular.ufo" && "${KAPPA_MARK_REIMPORT_FROM_UPSTREAM:-0}" != "1" ]]; then
    echo "Skipping kappa-mark upstream UFO import; canonical KM source already adopted."
    return
  fi

  rm -rf "$workdir" "$ufo_dir" "$designspace_dir"
  mkdir -p "$workdir" "$master_dir" "$instance_dir" "$designspace_dir"

  (
    cd "$workdir"
    fontmake -i "ABeeZee Regular" \
      -o ufo \
      -g "$ROOT_DIR/sources/kappa-mark/upstream-import/ABeeZee.glyphs" \
      --master-dir "$master_dir/regular" \
      --designspace-path "$designspace_dir/ABeeZee-Regular.designspace" \
      --ufo-structure=package \
      --instance-dir "$instance_dir"
    fontmake -i "ABeeZee Italic" \
      -o ufo \
      -g "$ROOT_DIR/sources/kappa-mark/upstream-import/ABeeZee-Italic.glyphs" \
      --master-dir "$master_dir/italic" \
      --designspace-path "$designspace_dir/ABeeZee-Italic.designspace" \
      --ufo-structure=package \
      --instance-dir "$instance_dir"
  )
}

import_comfortaa() {
  local workdir="$ROOT_DIR/tmp/import-ufo/kappa-spin"
  local ufo_dir="$ROOT_DIR/sources/kappa-spin/ufo"
  local designspace_dir="$ROOT_DIR/sources/kappa-spin/designspace"
  local master_dir="$ufo_dir/masters"
  local instance_dir="$ufo_dir/instances"

  rm -rf "$workdir" "$ufo_dir" "$designspace_dir"
  mkdir -p "$workdir" "$master_dir" "$instance_dir" "$designspace_dir"

  (
    cd "$workdir"
    fontmake -i \
      -o ufo \
      -g "$ROOT_DIR/sources/kappa-spin/upstream-import/Comfortaa.glyphs" \
      --master-dir "$master_dir" \
      --designspace-path "$designspace_dir/Comfortaa.designspace" \
      --ufo-structure=package \
      --instance-dir "$instance_dir"
  )
}

import_abeezee
import_comfortaa

echo "Imported master UFOs, instance UFOs, and designspace files for kappa-mark and kappa-spin"
