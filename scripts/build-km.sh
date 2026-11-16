#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Do not replace the published Nerd-patched Mono fonts with unpatched builds.
bash "$ROOT_DIR/scripts/patch-kmmono-nerd.sh" --check

for family_dir in "$ROOT_DIR"/families/*; do
  [[ -d "$family_dir" ]] || continue
  family_id="$(basename "$family_dir")"
  bash "$ROOT_DIR/scripts/build-family.sh" "$family_id"
done

bash "$ROOT_DIR/scripts/patch-kmmono-nerd.sh"
bash "$ROOT_DIR/scripts/build-webfonts.sh"
bash "$ROOT_DIR/scripts/proof.sh"
bash "$ROOT_DIR/scripts/validate.sh"

echo "KM build complete."
