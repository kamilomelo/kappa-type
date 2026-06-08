#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for family_dir in "$ROOT_DIR"/families/*; do
  [[ -d "$family_dir" ]] || continue
  family_id="$(basename "$family_dir")"
  "$ROOT_DIR/scripts/build-family.sh" "$family_id"
done

"$ROOT_DIR/scripts/patch-kmmono-nerd.sh"
"$ROOT_DIR/scripts/build-webfonts.sh"
"$ROOT_DIR/scripts/proof.sh"
"$ROOT_DIR/scripts/validate.sh"

echo "KM build complete."
