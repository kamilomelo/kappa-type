#!/usr/bin/env python3
from __future__ import annotations

from collections import Counter
from pathlib import Path

from ufoLib2 import Font


ROOT_DIR = Path(__file__).resolve().parent.parent
SOURCE_BASE = ROOT_DIR / "sources" / "kappa-mark" / "ufo" / "masters"
OUT_FILE = ROOT_DIR / "families" / "kappa-mark" / "KERNING.md"


def summarize(font: Font, label: str) -> list[str]:
    left_counts: Counter[str] = Counter()
    right_counts: Counter[str] = Counter()

    for left, right in font.kerning.keys():
        left_counts[str(left)] += 1
        right_counts[str(right)] += 1

    lines = [
        f"## {label}",
        "",
        f"- kerning pairs: {len(font.kerning)}",
        f"- groups: {len(font.groups)}",
        "- top left-side glyphs by pair count:",
    ]
    for name, count in left_counts.most_common(15):
        lines.append(f"  - `{name}`: {count}")

    lines.append("- top right-side glyphs by pair count:")
    for name, count in right_counts.most_common(15):
        lines.append(f"  - `{name}`: {count}")

    lines.append("")
    return lines


def main() -> None:
    regular = Font.open(SOURCE_BASE / "regular" / "KappaMark-Regular.ufo")
    italic = Font.open(SOURCE_BASE / "italic" / "KappaMark-Italic.ufo")

    lines = [
        "# Kappa Mark Kerning Audit",
        "",
        "This is a structural audit of the canonical master UFO kerning data.",
        "",
        "Current observation:",
        "- kerning is pair-based",
        "- no explicit kerning groups are present",
        "- this is valid, but likely heavier to maintain long term than grouped kerning",
        "",
    ]
    lines.extend(summarize(regular, "Regular"))
    lines.extend(summarize(italic, "Italic"))

    OUT_FILE.write_text("\n".join(lines), encoding="utf-8")


if __name__ == "__main__":
    main()
