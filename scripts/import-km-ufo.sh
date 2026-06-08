#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
PYTHON_BIN="$VENV_DIR/bin/python"

source "$VENV_DIR/bin/activate"

"$ROOT_DIR/scripts/import-ufo-sources.sh"

rm -rf "$ROOT_DIR/sources/kappa-text/ufo" "$ROOT_DIR/sources/kappa-mono/ufo"
mkdir -p "$ROOT_DIR/sources/kappa-text/ufo" "$ROOT_DIR/sources/kappa-mono/ufo"

for style in Regular Bold Italic BoldItalic; do
  "$PYTHON_BIN" "$ROOT_DIR/scripts/import-binary-ufo.py" \
    --input "$ROOT_DIR/tmp/upstream-reference/kappa-text/ttf/Readerly-Reference-${style}.ttf" \
    --output "$ROOT_DIR/sources/kappa-text/ufo/KappaText-${style}.ufo"
done

"$PYTHON_BIN" "$ROOT_DIR/scripts/adopt-kappa-text-sources.py"

"$PYTHON_BIN" "$ROOT_DIR/scripts/import-binary-ufo.py" \
  --input "$ROOT_DIR/tmp/upstream-reference/kappa-mono/CommitMonoV143-400Regular.otf" \
  --output "$ROOT_DIR/sources/kappa-mono/ufo/KappaMono-Regular.ufo"
"$PYTHON_BIN" "$ROOT_DIR/scripts/import-binary-ufo.py" \
  --input "$ROOT_DIR/tmp/upstream-reference/kappa-mono/CommitMonoV143-400Italic.otf" \
  --output "$ROOT_DIR/sources/kappa-mono/ufo/KappaMono-Italic.ufo"
"$PYTHON_BIN" "$ROOT_DIR/scripts/import-binary-ufo.py" \
  --input "$ROOT_DIR/tmp/upstream-reference/kappa-mono/CommitMonoV143-700Regular.otf" \
  --output "$ROOT_DIR/sources/kappa-mono/ufo/KappaMono-Bold.ufo"
"$PYTHON_BIN" "$ROOT_DIR/scripts/import-binary-ufo.py" \
  --input "$ROOT_DIR/tmp/upstream-reference/kappa-mono/CommitMonoV143-700Italic.otf" \
  --output "$ROOT_DIR/sources/kappa-mono/ufo/KappaMono-BoldItalic.ufo"

"$PYTHON_BIN" "$ROOT_DIR/scripts/adopt-kappa-mono-sources.py"

echo "Imported binary-derived UFO packages into sources/kappa-text/ufo and sources/kappa-mono/ufo"
