#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

source "$VENV_DIR/bin/activate"

python - "$ROOT_DIR" <<'PY'
from __future__ import annotations

import sys
from pathlib import Path

from fontTools.ttLib import TTFont

ROOT = Path(sys.argv[1])


def css_weight(subfamily: str) -> str:
    name = subfamily.lower()
    if "thin" in name:
        return "100"
    if "extra light" in name or "extralight" in name:
        return "200"
    if "light" in name:
        return "300"
    if "medium" in name:
        return "500"
    if "semi bold" in name or "semibold" in name:
        return "600"
    if "bold" in name:
        return "700"
    return "400"


def css_style(subfamily: str) -> str:
    return "italic" if "italic" in subfamily.lower() else "normal"


for family_dir in sorted((ROOT / "fonts").iterdir()):
    if not family_dir.is_dir():
        continue

    candidates = []
    ttf_dir = family_dir / "ttf"
    otf_dir = family_dir / "otf"
    if ttf_dir.exists():
        candidates.extend(sorted(path for path in ttf_dir.glob("*.ttf") if "-VF" not in path.stem))
    elif otf_dir.exists():
        candidates.extend(sorted(otf_dir.glob("*.otf")))

    if not candidates:
        continue

    web_dir = family_dir / "webfonts"
    css_dir = family_dir / "css"
    web_dir.mkdir(parents=True, exist_ok=True)
    css_dir.mkdir(parents=True, exist_ok=True)

    css_blocks = []
    for font_path in candidates:
        font = TTFont(font_path)
        out_path = web_dir / f"{font_path.stem}.woff2"
        font.flavor = "woff2"
        font.save(out_path)

        family = font["name"].getDebugName(16) or font["name"].getDebugName(1)
        subfamily = font["name"].getDebugName(17) or font["name"].getDebugName(2)
        css_blocks.append(
            "\n".join(
                [
                    "@font-face {",
                    f"  font-family: '{family}';",
                    f"  src: url('../webfonts/{out_path.name}') format('woff2');",
                    f"  font-style: {css_style(subfamily)};",
                    f"  font-weight: {css_weight(subfamily)};",
                    "  font-display: swap;",
                    "}",
                ]
            )
        )

    (css_dir / f"{family_dir.name}.css").write_text("\n\n".join(css_blocks) + "\n", encoding="utf-8")
PY
