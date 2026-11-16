#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

if [[ ! -d "$VENV_DIR" ]]; then
  python3 -m venv "$VENV_DIR"
fi

"$VENV_DIR/bin/python" -m pip install -r "$ROOT_DIR/scripts/requirements.txt"

echo "Bootstrap complete. Upstream cloning/import is an explicit, separate step."
echo "A full Kappa Mono rebuild also requires FontForge and the Nerd Fonts patcher."
