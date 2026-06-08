# Kappa Mark Source Audit

Date: 2026-06-08

Scope:
- canonical master UFOs
- canonical instance UFOs
- designspace files
- feature source
- font metadata

## Current Build Boundary

`Kappa Mark` now builds from KM-owned UFO/designspace sources, not directly from ABeeZee Glyphs files.

Normal builds should not refresh `Kappa Mark` from upstream.

If a fresh upstream reimport is needed, run:

```bash
KAPPA_MARK_REIMPORT_FROM_UPSTREAM=1 ./scripts/import-ufo-sources.sh
```

Current design freeze:
- no kerning edits
- no spacing edits
- no feature behavior edits
- no outline edits
- no visual changes unless explicitly approved after proof review

Visual baseline status:
- visually inspected against ABeeZee
- overall size and alphabet comparison accepted
- minor sub-pixel rendering differences are accepted for this stage
- this state should be treated as the approved KM baseline before intentional redesign

## Current State

Clean:
- canonical source filenames use `KappaMark-*`
- family naming uses `Kappa Mark`
- PostScript naming uses `KappaMark-*`
- designspace files point to `KappaMark-*` UFO packages
- upright and italic both build successfully from KM instance UFOs
- canonical UFO metadata now uses KM-owned vendor/designer/manufacturer fields
- stale `openTypeHeadCreated` export timestamps have been removed
- editor guideline residue has been removed from masters and instances
- Glyphs-specific `com.schriftgestaltung.*` lib baggage has been stripped from the canonical UFOs

Expected upstream-derived metadata retained on purpose:
- copyright notice references `ABeeZee`
- OFL provenance remains upstream-derived

## Findings

### 1. Build dependency boundary is clean

Status: good

The normal `Kappa Mark` build path now runs from:
- `sources/kappa-mark/ufo/instances`

Upstream Glyphs sources remain reference material only:
- `sources/kappa-mark/upstream-import`

### 2. Naming layer is clean

Status: good

Canonical source layer uses:
- `Kappa Mark` as family name
- `KappaMark-Regular` and `KappaMark-Italic` as PostScript names
- KM-owned designspace filenames and UFO package names

### 3. Features are valid but still upstream-shaped

Status: acceptable for now

Current feature files are mostly automatic exports and include:
- `aalt`
- `ccmp`
- `locl`
- `sups`
- `frac`
- `ordn`
- `case`

These are usable, but they are still essentially imported source behavior rather than deliberately curated KM feature architecture.

### 4. UFO lib metadata is now reduced to build-relevant keys

Status: improved

The canonical UFOs now keep only the keys needed for build behavior and source organization, such as:
- `com.github.googlei18n.ufo2ft.featureWriters`
- `com.github.googlei18n.ufo2ft.filters`
- `public.*`
- `designspace.location` and `public.skipExportGlyphs` on instances

Most Glyphs-specific `com.schriftgestaltung.*` import residue has been removed.

### 5. Master UFOs have no explicit groups, but large kerning tables

Status: review recommended

Observed:
- Regular: 4468 kerning pairs, 0 groups
- Italic: 4575 kerning pairs, 0 groups

This is not invalid, but it is a sign that the source is carrying pair-level kerning rather than a cleaner grouped kerning structure.

For long-term maintainability, this should be reviewed.

### 6. Core font metadata is now explicitly KM-owned

Status: improved

Current canonical source policy:
- `openTypeOS2VendorID = KMXG`
- `openTypeNameManufacturer = KM-X Group`
- `openTypeNameDesigner = KM-X Group`
- `openTypeHeadCreated` removed from canonical UFOs

This makes the source package feel first-party while still preserving upstream copyright and OFL provenance.

### 7. Guideline residue has been removed

Status: improved

The suspicious imported guideline values, including the `y=9992` residue in the regular master, have been removed from the canonical UFOs.

### 8. Italics are retained intentionally

Status: accepted

Italic sources do not currently create a structural problem.

They add maintenance surface, but there is no immediate technical reason to remove them.

## Immediate Recommendations

Priority 1:
- keep italics
- keep the current canonical UFO/designspace structure
- stop treating upstream import as part of the normal build story

Priority 2:
- keep the current metadata policy stable
- review whether the remaining `ufo2ft` build keys are the right long-term canonical set

Priority 3:
- review kerning structure and decide whether pair-only kerning is acceptable
- decide whether feature files should remain auto-exported or be rewritten as curated KM feature source
- keep kerning changes slow and observable; see `families/kappa-mark/KERNING.md`

## Suggested Next Cleanup Pass

1. Decide whether the remaining `ufo2ft` lib keys should stay in the canonical UFOs.
2. Review kerning maintainability using `families/kappa-mark/KERNING.md`.
3. Decide whether pair-only kerning should be preserved or migrated toward grouped kerning.
4. Decide whether feature files should remain imported or be rewritten as curated KM feature source.
