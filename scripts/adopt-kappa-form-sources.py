#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path

from fontTools.designspaceLib import DesignSpaceDocument
from ufoLib2 import Font


ROOT_DIR = Path(__file__).resolve().parent.parent
SOURCE_BASE = ROOT_DIR / "sources" / "kappa-form"
MASTER_DIR = SOURCE_BASE / "ufo" / "masters"
DESIGNSPACE_DIR = SOURCE_BASE / "designspace"
FAMILY_NAME = "Kappa Form"
TRIMMED_FAMILY = FAMILY_NAME.replace(" ", "")
MANUFACTURER = "KM-X Group"
VENDOR_ID = "KMXG"
TRADEMARK = "Kappa Form is a trademark of KM-X Group."
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
    "SemiBold": 600,
    "Bold": 700,
    "ExtraBold": 800,
    "Light Italic": 300,
    "Italic": 400,
    "SemiBold Italic": 600,
    "Bold Italic": 700,
    "ExtraBold Italic": 800,
}


def style_from_stem(stem: str) -> str:
    stem = stem.removeprefix("OpenSans-").removeprefix("KappaForm-")
    mapping = {
        "LightItalic": "Light Italic",
        "SemiBoldItalic": "SemiBold Italic",
        "ExtraBoldItalic": "ExtraBold Italic",
        "BoldItalic": "Bold Italic",
        "Italic": "Italic",
        "Light": "Light",
        "SemiBold": "SemiBold",
        "ExtraBold": "ExtraBold",
        "Bold": "Bold",
        "Regular": "Regular",
    }
    return mapping[stem]


def source_style_token(style: str) -> str:
    return style.replace(" ", "")


def style_map_family(style: str) -> str:
    if style in {"Regular", "Italic", "Bold", "Bold Italic"}:
        return FAMILY_NAME
    return f"{FAMILY_NAME} {style.replace('Italic', '').strip()}"


def style_map_style(style: str) -> str:
    if style == "Regular":
        return "regular"
    if style == "Italic":
        return "italic"
    if style == "Bold":
        return "bold"
    if style == "Bold Italic":
        return "bold italic"
    if "Italic" in style:
        return "italic"
    return "regular"


def postscript_name(style: str) -> str:
    return f"{TRIMMED_FAMILY}-{style.replace(' ', '')}"


def rename_ufo(path: Path) -> Path:
    style = style_from_stem(path.stem)
    new_path = path.with_name(f"{TRIMMED_FAMILY}-{source_style_token(style)}.ufo")
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
    info.postscriptFontName = postscript_name(style)
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


def normalize_designspace(path: Path, kind: str) -> Path:
    doc = DesignSpaceDocument.fromfile(path)

    for source in doc.sources:
        if source.filename and "Condensed" in source.filename:
            continue
        style = style_from_stem(Path(source.filename).stem) if source.filename else source.styleName or "Regular"
        source.name = f"{TRIMMED_FAMILY} {style}"
        source.familyName = FAMILY_NAME
        source.styleName = style
        if source.filename is not None:
            source.filename = f"../ufo/masters/{TRIMMED_FAMILY}-{source_style_token(style)}.ufo"
        source.path = None

    doc.sources = [s for s in doc.sources if not (s.filename and "Condensed" in s.filename)]

    kept_instances = []
    for instance in doc.instances:
        style_name = instance.styleName or "Regular"
        if "Condensed" in style_name or "Thin" in style_name:
            continue
        source_style = "Regular" if style_name == "Regular" else style_name
        style = source_style
        instance.name = f"{TRIMMED_FAMILY} {style}"
        instance.familyName = FAMILY_NAME
        instance.styleName = style
        instance.styleMapFamilyName = style_map_family(style)
        instance.styleMapStyleName = style_map_style(style)
        instance.filename = f"../ufo/instances/{TRIMMED_FAMILY}-{source_style_token(style)}.ufo"
        instance.path = None
        kept_instances.append(instance)
    doc.instances = kept_instances

    if path.name == "OpenSans-Roman-Full.designspace":
        new_name = "KappaForm-Roman.designspace"
    elif path.name == "OpenSans-Italic-Full.designspace":
        new_name = "KappaForm-Italic.designspace"
    else:
        new_name = path.name.replace("OpenSans", TRIMMED_FAMILY)
    new_path = path.with_name(new_name)
    if new_path.exists() and new_path != path:
        new_path.unlink()
    doc.write(new_path)
    if new_path != path:
        path.unlink()
    return new_path


def main() -> None:
    for path in sorted(MASTER_DIR.glob("*.ufo")):
        if "Condensed" in path.name or "Thin" in path.name:
            continue
        renamed = rename_ufo(path)
        normalize_ufo(renamed)

    for path in sorted(MASTER_DIR.glob("OpenSans-Condensed*.ufo")):
        path.rename(path.with_suffix(".ufo.disabled"))
    for path in sorted(MASTER_DIR.glob("OpenSans-Thin*.ufo")):
        path.rename(path.with_suffix(".ufo.disabled"))

    for path in sorted(DESIGNSPACE_DIR.glob("*.designspace")):
        if path.name not in {"OpenSans-Roman-Full.designspace", "OpenSans-Italic-Full.designspace"}:
            path.unlink()
            continue
        normalize_designspace(path, "roman" if "Roman" in path.name else "italic")

    feature_src = DESIGNSPACE_DIR / "OpenSans.fea"
    if feature_src.exists():
        feature_src.rename(DESIGNSPACE_DIR / "KappaForm.fea")


if __name__ == "__main__":
    main()
