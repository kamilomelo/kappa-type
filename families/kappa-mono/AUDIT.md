# Kappa Mono Source Audit

Date: 2026-06-08

Scope:
- canonical UFO imports
- upstream import assets
- feature source
- font metadata
- build fidelity

## Current Build Boundary

`Kappa Mono` is upstream-informed by Commit Mono.

Current design freeze:
- no spacing edits
- no feature behavior edits
- no outline edits
- no visual changes unless explicitly approved after proof review

Visual baseline status:
- visually reviewed against Commit Mono
- accepted as the KM baseline for future work

Current source path:
- `sources/kappa-mono/upstream-import` keeps the imported upstream OTF/VF assets
- `sources/kappa-mono/ufo` holds binary-derived UFO imports

Current staged flow:
1. copy upstream OTF reference assets into the staged reference area
2. import those OTFs into UFO packages
3. adopt KM-owned source metadata
4. rebuild KM TTFs from those UFOs

## Current State

Observed source model:
- 4 binary-derived UFOs
  - `KappaMono-Regular.ufo`
  - `KappaMono-Italic.ufo`
  - `KappaMono-Bold.ufo`
  - `KappaMono-BoldItalic.ufo`
- imported upstream binary assets:
  - regular/italic at 400
  - regular/italic at 700
  - variable font TTF

Current source policy:
- family naming uses `Kappa Mono`
- style naming uses `Regular`, `Italic`, `Bold`, `Bold Italic`
- PostScript naming uses `KappaMono-*`
- vendor ID uses `KMXG`
- manufacturer/designer use `KM-X Group`
- feature text remains imported from the upstream binaries
- upstream-derived `VF` output is not part of the intended KM release set

## Findings

### 1. Source naming is now internally KM-owned

Status: improved

The current UFOs now use:
- `Kappa Mono` as family name
- KM style names for all four styles
- `KappaMono-*` PostScript names
- KM style-map and preferred family/subfamily naming

The source is still binary-derived, but it is no longer carrying upstream family naming internally.

### 2. Metadata policy is now explicit, but still lightweight

Status: improved

Current source policy includes:
- `openTypeOS2VendorID = KMXG`
- `openTypeNameManufacturer = KM-X Group`
- `openTypeNameDesigner = KM-X Group`
- `postscriptIsFixedPitch = True`
- upstream copyright retained
- OFL license text retained

The source remains intentionally lightweight, but it now has explicit KM ownership metadata.

This is still simpler than `Kappa Mark`, and there is less source-level intent preserved overall.

### 3. Feature payload is large and valuable

Status: preserve carefully

The imported feature file is extensive and includes:
- classes
- substitutions
- alternate glyph behavior
- stylistic behavior

This is the main source asset that must not be casually damaged during cleanup.

Current rule:
- do not rewrite or trim `features.fea` during source adoption work

### 4. No kerning and no groups in the imported UFOs

Status: expected, but note

Observed:
- `0` groups
- `0` kerning pairs

For a monospaced family, this is not automatically a problem.

### 5. Editable-source fidelity remains the weakest of the active families

Status: structural limitation

The inspected upstream repo does not expose obvious editable `.glyphs` or `.ufo` sources.

That means:
- this family is currently the most import-driven
- long-term KM independence will depend on how well these UFOs can be normalized and maintained
- proof comparison against Commit Mono is especially important before trusting the source as long-term canonical input

## Initial Recommendations

Priority 1:
- do not change visual behavior yet
- treat the current imported UFOs as provisional canonical sources
- avoid touching feature behavior until proof coverage is stronger

Priority 2:
- keep the current KM metadata policy stable
- keep the imported feature text intact
- validate visually against Commit Mono before claiming the source as approved baseline

Priority 3:
- keep static TTFs as the first-class KM outputs for this family
- treat the Nerd-patched static TTFs as the primary mono release

## Recommended Next Step

Perform proof-led validation for `Kappa Mono`:
- compare the current KM outputs against Commit Mono
- confirm that source adoption stayed non-visual
- only then treat the imported UFOs as the approved baseline

Current progress:
- source adoption script exists in `scripts/adopt-kappa-mono-sources.py`
- import flow now reapplies KM source metadata after binary UFO import
- proof coverage should use `proofs/kappa-mono.html` for visual comparison before any design edits
