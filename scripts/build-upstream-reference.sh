#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
REF_DIR="$ROOT_DIR/tmp/upstream-reference"

source "$VENV_DIR/bin/activate"
mkdir -p "$REF_DIR"

build_readerly_reference() {
  local workdir="$ROOT_DIR/upstream/readerly"
  local outdir="$REF_DIR/kappa-text/ttf"
  local tmpdir="$workdir/tmp"
  local variant_prefix="Readerly-Reference"
  local readerly_status=0

  rm -rf "$workdir/out" "$tmpdir" "$outdir"
  mkdir -p "$outdir" "$tmpdir"

  cat > "$tmpdir/kobofix.py" <<'PY'
#!/usr/bin/env python3
import sys
sys.exit(0)
PY
  chmod +x "$tmpdir/kobofix.py"

  (
    cd "$workdir"
    python3 build.py --name Readerly-Reference
  ) || readerly_status=$?

  for style in Regular Bold Italic BoldItalic; do
    if [[ ! -f "$workdir/out/ttf/${variant_prefix}-${style}.ttf" ]]; then
      echo "Readerly reference build failed before producing ${variant_prefix}-${style}.ttf" >&2
      return "${readerly_status:-1}"
    fi
  done

  if [[ "$readerly_status" -ne 0 ]]; then
    echo "Readerly upstream build exited with status $readerly_status after producing TTFs; continuing without Kobo/web outputs." >&2
  fi

  cp "$workdir/out/ttf/${variant_prefix}-Regular.ttf" "$outdir/${variant_prefix}-Regular.ttf"
  cp "$workdir/out/ttf/${variant_prefix}-Bold.ttf" "$outdir/${variant_prefix}-Bold.ttf"
  cp "$workdir/out/ttf/${variant_prefix}-Italic.ttf" "$outdir/${variant_prefix}-Italic.ttf"
  cp "$workdir/out/ttf/${variant_prefix}-BoldItalic.ttf" "$outdir/${variant_prefix}-BoldItalic.ttf"
}

build_googlefonts_reference() {
  local family_id="$1"
  local workdir="$REF_DIR/$family_id"

  rm -rf "$workdir"
  mkdir -p "$workdir/sources"
  cp -R "$ROOT_DIR/sources/$family_id/upstream-import/." "$workdir/sources/"

  if [[ "$family_id" == "kappa-spin" ]]; then
    python - "$workdir/sources/config.yaml" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
text = text.replace("Comfortaa[wght].ttf:", "Comfortaa[wdth,wght].ttf:")
path.write_text(text, encoding="utf-8")
PY
  fi

  (
    cd "$workdir"
    gftools builder sources/config.yaml
  )
}

build_commit_mono_reference() {
  local outdir="$REF_DIR/kappa-mono"
  rm -rf "$outdir"
  mkdir -p "$outdir"
  cp "$ROOT_DIR"/sources/kappa-mono/upstream-import/* "$outdir/"
}

build_readerly_reference
build_googlefonts_reference "kappa-mark"
build_commit_mono_reference
build_googlefonts_reference "kappa-spin"

echo "Upstream reference outputs written to $REF_DIR"
