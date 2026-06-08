#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
REPORT_DIR="$ROOT_DIR/proofs/validation"

mkdir -p "$REPORT_DIR"
source "$VENV_DIR/bin/activate"

python - "$ROOT_DIR" "$REPORT_DIR" <<'PY'
from __future__ import annotations

import sys
from pathlib import Path

from fontTools.ttLib import TTFont

ROOT = Path(sys.argv[1])
REPORT_DIR = Path(sys.argv[2])

BANNED = {
    "kappa-text": ["Readerly", "Newsreader"],
    "kappa-mark": ["ABeeZee"],
    "kappa-mono": ["Commit Mono"],
    "kappa-spin": ["Comfortaa"],
}


def collect_font_paths() -> list[Path]:
    paths: list[Path] = []
    for family_dir in sorted((ROOT / "fonts").iterdir()):
        if not family_dir.is_dir():
            continue
        for ext in ("*.ttf", "*.otf", "*.woff2"):
            paths.extend(sorted(family_dir.rglob(ext)))
    return paths


lines = []
failed = False

for font_path in collect_font_paths():
    family_key = font_path.relative_to(ROOT / "fonts").parts[0]
    banned = BANNED.get(family_key, [])
    font = TTFont(font_path)
    family = font["name"].getDebugName(16) or font["name"].getDebugName(1) or ""
    style = font["name"].getDebugName(17) or font["name"].getDebugName(2) or ""
    postscript = font["name"].getDebugName(6) or ""
    joined = " | ".join([family, style, postscript])

    hit = [name for name in banned if name.lower() in joined.lower()]
    status = "FAIL" if hit else "OK"
    if hit:
        failed = True
    lines.append(f"{status} {font_path.relative_to(ROOT)} :: {joined}")
    if hit:
        lines.append(f"  banned names present: {', '.join(hit)}")

report_path = REPORT_DIR / "name-check.txt"
report_path.write_text("\n".join(lines) + ("\n" if lines else ""), encoding="utf-8")

if failed:
    raise SystemExit("validation failed; see proofs/validation/name-check.txt")
PY

if command -v fontbakery >/dev/null 2>&1; then
  FONTBAKERY_CMD=(
    fontbakery
    check-universal
    "$ROOT_DIR"/fonts/*/ttf/*.ttf
    --html
    "$REPORT_DIR/fontbakery-universal.html"
  )

  if command -v timeout >/dev/null 2>&1; then
    timeout 30 "${FONTBAKERY_CMD[@]}" >/dev/null 2>&1 || true
  else
    "${FONTBAKERY_CMD[@]}" >/dev/null 2>&1 || true
  fi
fi
