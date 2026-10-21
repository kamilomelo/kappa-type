#!/usr/bin/env bash
# Build Kappa Page without rebuilding or rewriting the frozen families.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/.venv/bin/activate"

python "$ROOT_DIR/scripts/import-kappa-page.py"
bash "$ROOT_DIR/scripts/build-family.sh" kappa-page
bash "$ROOT_DIR/scripts/build-webfonts.sh" kappa-page
bash "$ROOT_DIR/scripts/proof.sh" kappa-page
python "$ROOT_DIR/scripts/check-kappa-page.py"

echo "Kappa Page alpha built; compare proofs/kappa-page.html with the upstream OTFs."
