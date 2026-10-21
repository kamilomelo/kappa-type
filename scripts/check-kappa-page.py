#!/usr/bin/env python3
"""Check the Kappa Page alpha against the pinned upstream OTFs."""

from __future__ import annotations

from pathlib import Path

from fontTools.ttLib import TTFont


ROOT = Path(__file__).resolve().parent.parent
STYLES = {
    "Regular": ("cmunss", 400, "Regular"),
    "Italic": ("cmunsi", 400, "Italic"),
    "Bold": ("cmunsx", 700, "Bold"),
    "BoldItalic": ("cmunso", 700, "Bold Italic"),
}
PRIMARY_NAME_IDS = (1, 2, 3, 4, 6, 16, 17, 21, 22)


def features(font: TTFont, table: str) -> tuple[int, tuple[str, ...]]:
    if table not in font:
        return (0, ())
    data = font[table].table
    return (len(data.LookupList.Lookup), tuple(sorted(r.FeatureTag for r in data.FeatureList.FeatureRecord)))


def check() -> list[str]:
    results = []
    for style, (stem, weight, subfamily) in STYLES.items():
        reference = TTFont(ROOT / "sources/kappa-page/upstream-import" / f"{stem}.otf")
        for ext, directory in (("ttf", "ttf"), ("woff2", "webfonts")):
            path = ROOT / "fonts/kappa-page" / directory / f"KappaPage-{style}.{ext}"
            with TTFont(path) as font:
                names = font["name"]
                primary = " ".join(
                    record.toUnicode() for record in names.names if record.nameID in PRIMARY_NAME_IDS
                )
                assert "CMU Sans Serif" not in primary and "CMUSansSerif" not in primary, path
                assert names.getDebugName(1) == "Kappa Page", path
                assert names.getDebugName(2) == subfamily, path
                assert names.getDebugName(6) == f"KappaPage-{style}", path
                assert font["OS/2"].usWeightClass == weight, path
                assert "SIL Open Font License, Version 1.1" in (names.getDebugName(13) or ""), path
                assert "Andrey V. Panov" in (names.getDebugName(0) or ""), path
                assert font.getBestCmap() == reference.getBestCmap(), path
                for table in ("GSUB", "GPOS"):
                    assert features(font, table) == features(reference, table), (path, table)
            results.append(f"PASS {path.relative_to(ROOT)}: names, OFL, cmap, GSUB/GPOS")
        reference.close()
    css = (ROOT / "fonts/kappa-page/css/kappa-page.css").read_text(encoding="utf-8")
    assert css.count("@font-face") == 4
    assert "font-family: 'Kappa Page'" in css
    assert (ROOT / "proofs/kappa-page.html").is_file()
    results.append("PASS CSS declarations and print proof")
    return results


if __name__ == "__main__":
    for result in check():
        print(result)
