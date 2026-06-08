#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT_DIR/scripts/build-upstream-reference.sh"
"$ROOT_DIR/scripts/import-km-ufo.sh"
"$ROOT_DIR/scripts/build-km.sh"

echo "Full staged build complete."
