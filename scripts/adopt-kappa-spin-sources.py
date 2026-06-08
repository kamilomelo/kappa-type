#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path

from fontTools.designspaceLib import DesignSpaceDocument
from ufoLib2 import Font


ROOT_DIR = Path(__file__).resolve().parent.parent
SOURCE_BASE = ROOT_DIR / "sources" / "kappa-spin"
FAMILY_NAME = "Kappa Spin"
TRIMMED_FAMILY = FAMILY_NAME.replace(" ", "")
TRADEMARK = "Kappa Spin is a trademark of KM-X Group."
MANUFACTURER = "KM-X Group"
VENDOR_ID = "KMXG"
KEEP_LIB_KEYS = {
    "com.github.googlei18n.ufo2ft.featureWriters",
    "com.github.googlei18n.ufo2ft.filters",
    "designspace.location",
    "public.glyphOrder",
    "public.openTypeCategories",
    "public.postscriptNames",
    "public.skipExportGlyphs",
}
WEIGHT_CLASS_BY_STYLE = {
    "Light": 300,
    "Regular": 400,
    "Medium": 500,
    "SemiBold": 600,
    "Bold": 700,
}


def style_from_stem(stem: str) -> str:
    for style in ("SemiBold", "Medium", "Light", "Bold"):
        if stem.endswith(f"-{style}"):
            return style
    return "Regular"


def style_map_family(style: str) -> str:
    if style == "Regular":
        return FAMILY_NAME
    if style == "Bold":
        return FAMILY_NAME
    return f"{FAMILY_NAME} {style}"


def style_map_style(style: str) -> str:
    if style == "Bold":
        return "bold"
    return "regular"


def ps_name(style: str) -> str:
    return f"{TRIMMED_FAMILY}-{style}"


def rename_ufo(path: Path) -> Path:
    style = style_from_stem(path.stem)
    new_path = path.with_name(f"{TRIMMED_FAMILY}-{style}.ufo")
    if path != new_path:
        path.rename(new_path)
    return new_path


def normalize_ufo(path: Path) -> None:
    style = style_from_stem(path.stem)
    font = Font.open(path)
    info = font.info

    info.familyName = FAMILY_NAME
    info.styleName = style
    info.styleMapFamilyName = style_map_family(style)
    info.styleMapStyleName = style_map_style(style)
    info.openTypeNamePreferredFamilyName = FAMILY_NAME
    info.openTypeNamePreferredSubfamilyName = style
    info.postscriptFontName = ps_name(style)
    info.openTypeNameManufacturer = MANUFACTURER
    info.openTypeNameManufacturerURL = ""
    info.openTypeNameDesigner = MANUFACTURER
    info.openTypeNameDesignerURL = ""
    info.openTypeOS2VendorID = VENDOR_ID
    info.openTypeOS2WeightClass = WEIGHT_CLASS_BY_STYLE[style]
    info.openTypeHeadCreated = None
    info.trademark = TRADEMARK
    info.guidelines = []

    for key in list(font.lib.keys()):
        if key not in KEEP_LIB_KEYS:
            del font.lib[key]

    font.save(overwrite=True)


def normalize_designspace(path: Path) -> Path:
    doc = DesignSpaceDocument.fromfile(path)

    for source in doc.sources:
        style = style_from_stem(Path(source.filename).stem) if source.filename else source.styleName or "Regular"
        source.name = f"{TRIMMED_FAMILY} {style}"
        source.familyName = FAMILY_NAME
        source.styleName = style
        if source.filename is not None:
            source.filename = str(source.filename).replace("Comfortaa", TRIMMED_FAMILY)
        source.path = None

    for instance in doc.instances:
        style = style_from_stem(Path(instance.filename).stem) if instance.filename else instance.styleName or "Regular"
        instance.name = f"{TRIMMED_FAMILY} {style}"
        instance.familyName = FAMILY_NAME
        instance.styleName = style
        instance.styleMapFamilyName = style_map_family(style)
        instance.styleMapStyleName = style_map_style(style)
        if instance.filename:
            instance.filename = str(instance.filename).replace("Comfortaa", TRIMMED_FAMILY)
        instance.path = None

    new_path = path.with_name(path.name.replace("Comfortaa", TRIMMED_FAMILY))
    if new_path != path and new_path.exists():
        new_path.unlink()
    doc.write(new_path)
    if new_path != path:
        path.unlink()
    return new_path


def main() -> None:
    roots = [
        SOURCE_BASE / "ufo" / "masters",
        SOURCE_BASE / "ufo" / "instances",
    ]

    for root in roots:
        if not root.exists():
            continue
        for path in sorted(root.glob("*.ufo")):
            renamed = rename_ufo(path)
            normalize_ufo(renamed)

    designspace_dir = SOURCE_BASE / "designspace"
    for path in sorted(designspace_dir.glob("*.designspace")):
        normalize_designspace(path)


if __name__ == "__main__":
    main()
