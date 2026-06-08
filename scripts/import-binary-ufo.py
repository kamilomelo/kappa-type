#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

from fontFeatures.ttLib import unparse
from fontTools.ttLib import TTFont
from ufoLib2 import Font


def reverse_cmap(font: TTFont) -> dict[str, list[int]]:
    mapping: dict[str, list[int]] = {}
    best = font.getBestCmap() or {}
    for codepoint, glyph_name in best.items():
        mapping.setdefault(glyph_name, []).append(codepoint)
    return mapping


def set_info(ufo: Font, font: TTFont) -> None:
    name_table = font["name"]
    os2 = font["OS/2"] if "OS/2" in font else None
    post = font["post"] if "post" in font else None
    hhea = font["hhea"] if "hhea" in font else None

    ufo.info.familyName = name_table.getDebugName(1)
    ufo.info.styleName = name_table.getDebugName(2)
    ufo.info.openTypeNamePreferredFamilyName = name_table.getDebugName(16) or name_table.getDebugName(1)
    ufo.info.openTypeNamePreferredSubfamilyName = name_table.getDebugName(17) or name_table.getDebugName(2)
    ufo.info.postscriptFontName = name_table.getDebugName(6)
    ufo.info.unitsPerEm = font["head"].unitsPerEm
    if hhea is not None:
        ufo.info.ascender = hhea.ascent
        ufo.info.descender = hhea.descent
        ufo.info.openTypeHheaAscender = hhea.ascent
        ufo.info.openTypeHheaDescender = hhea.descent
        ufo.info.openTypeHheaLineGap = hhea.lineGap
    if post is not None:
        ufo.info.italicAngle = post.italicAngle
    if os2 is not None:
        ufo.info.openTypeOS2WeightClass = os2.usWeightClass
        ufo.info.openTypeOS2WidthClass = os2.usWidthClass
        ufo.info.openTypeOS2TypoAscender = os2.sTypoAscender
        ufo.info.openTypeOS2TypoDescender = os2.sTypoDescender
        ufo.info.openTypeOS2TypoLineGap = os2.sTypoLineGap
        ufo.info.openTypeOS2WinAscent = os2.usWinAscent
        ufo.info.openTypeOS2WinDescent = os2.usWinDescent
        if getattr(os2, "sxHeight", 0) > 0:
            ufo.info.xHeight = os2.sxHeight
        if getattr(os2, "sCapHeight", 0) > 0:
            ufo.info.capHeight = os2.sCapHeight


def extract_features(font: TTFont) -> str:
    try:
        feature_text = unparse(font).asFea()
        return normalize_feature_text(feature_text)
    except Exception as exc:  # pragma: no cover
        return f"# feature extraction failed: {exc}\n"


def normalize_feature_text(feature_text: str) -> str:
    lines = feature_text.splitlines()
    languagesystem_lines: list[str] = []
    other_lines: list[str] = []

    for line in lines:
        if line.startswith("languagesystem "):
            languagesystem_lines.append(line)
        else:
            other_lines.append(line)

    if not languagesystem_lines:
        return feature_text

    dflt_lines = [line for line in languagesystem_lines if line.strip() == "languagesystem DFLT dflt;"]
    non_dflt_lines = [line for line in languagesystem_lines if line.strip() != "languagesystem DFLT dflt;"]
    ordered_lines = dflt_lines + non_dflt_lines + other_lines
    return "\n".join(ordered_lines) + "\n"


def import_binary_ufo(input_path: Path, output_path: Path) -> None:
    if output_path.exists():
        shutil.rmtree(output_path)

    font = TTFont(str(input_path))
    ufo = Font()
    set_info(ufo, font)
    ufo.features.text = extract_features(font)

    glyph_order = font.getGlyphOrder()
    ufo.glyphOrder = glyph_order
    unicode_map = reverse_cmap(font)
    glyph_set = font.getGlyphSet()
    hmtx = font["hmtx"]

    for glyph_name in glyph_order:
        glyph = ufo.newGlyph(glyph_name)
        glyph.width = hmtx[glyph_name][0]
        glyph.unicodes = unicode_map.get(glyph_name, [])
        glyph_set[glyph_name].drawPoints(glyph.getPointPen())

    output_path.parent.mkdir(parents=True, exist_ok=True)
    ufo.save(output_path)


def main() -> None:
    parser = argparse.ArgumentParser(description="Import a compiled OpenType font into a UFO package.")
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    import_binary_ufo(Path(args.input), Path(args.output))


if __name__ == "__main__":
    main()
