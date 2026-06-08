# Kappa Text Source Audit

Date: 2026-06-08

Scope:
- canonical UFO imports
- upstream variable-font inputs
- feature source
- font metadata
- build fidelity

## Current Build Boundary

`Kappa Text` is upstream-informed by Readerly.

Current source path:
- `sources/kappa-text/upstream-import` keeps the imported variable-font inputs
- `sources/kappa-text/ufo` holds binary-derived UFO imports

Current staged flow:
1. build real Readerly reference TTFs through `upstream/readerly/build.py`
2. import those statics into UFO packages
3. adopt KM-owned source metadata
4. rebuild KM TTFs from those UFOs with `fontmake`

## Current State

Observed source model:
- 4 binary-derived UFOs
  - `KappaText-Regular.ufo`
  - `KappaText-Italic.ufo`
  - `KappaText-Bold.ufo`
  - `KappaText-BoldItalic.ufo`
- upstream variable TTF inputs:
  - `Newsreader-VariableFont_opsz,wght.ttf`
  - `Newsreader-Italic-VariableFont_opsz,wght.ttf`

## Findings

### 1. Source naming and metadata adoption are now in place

Status: fixed for current baseline

Current state:
- family name is `Kappa Text`
- style names are normalized
- PostScript names are `KappaText-*`
- style-map naming is populated
- KM metadata policy is applied during import/adoption

### 2. Typography payload remains significant and must be preserved carefully

Status: still true

Observed:
- imported feature source carries substantial typography behavior, including kerning, ligatures, marks, substitutions, and localized behavior
- this remains the main value in the current source import

### 3. Feature and positioning payload is significant

Status: preserve carefully

The imported `features.fea` includes:
- `languagesystem` declarations
- `GSUB` substitutions
- `GDEF`
- `markClass` definitions
- ligatures
- pair positioning / kerning

This is the main value in the current source import and must not be casually rewritten.

### 4. Kerning/groups are flattened in the current import

Status: important limitation

Observed in inspected UFOs:
- `0` groups
- `0` kerning entries in UFO data structures

However, pair positioning exists in `features.fea`.

That means:
- typography behavior is currently living in feature text rather than structured UFO kerning/groups
- adoption work must preserve feature text very carefully

### 5. Weight/style mapping is currently weak

Status: fixed for current baseline

Current state:
- style naming is normalized
- Bold now rebuilds with `weightClass=700`
- imported metrics and style data are preserved during binary-to-UFO import

### 6. Text-face sensitivity is higher than the other families

Status: note

Even minor non-outline changes can matter more in a text face:
- spacing
- kerning
- overlap handling
- mark behavior
- ligature behavior

This family should be treated more conservatively than `Kappa Mono`.

### 7. Readerly drift was present and is now fixed

Status: fixed for current baseline

The earlier simplified reference build path caused visible drift from Readerly in:
- size
- weight
- text texture
- vertical metrics

Current state:
- reference build now wraps the real upstream Readerly build
- `Kappa Text` now matches Readerly reference metrics and advance widths in the checked samples

## Current Baseline

Approved state:
- Readerly-faithful baseline accepted
- current visual differences from Bookerly are expected design differences, not build bugs

Bookerly note:
- Bookerly is kept only as a private reference sample
- any future Bookerly-inspired work should be explicit, deferred, and independently designed

## Initial Recommendations

Priority 1:
- do not change visual behavior yet
- adopt only source metadata first
- preserve imported feature text unchanged

Priority 2:
- normalize family/style/PostScript naming
- define KM metadata policy
- verify style mapping for bold and bold italic imports

Priority 3:
- add proof coverage focused on reading texture and punctuation before any deeper source edits

## Recommended Next Step

Perform a non-visual adoption pass for `Kappa Text`:
- normalize family names
- normalize style names
- normalize PostScript names
- normalize style-map and preferred family/subfamily naming
- apply KM metadata policy
- preserve `features.fea` unchanged

Current progress:
- source adoption script exists in `scripts/adopt-kappa-text-sources.py`
- import flow now reapplies KM source metadata after binary UFO import
- proof coverage should use `proofs/kappa-text.html` for visual comparison before any design edits
- redesign planning now lives in `families/kappa-text/REDESIGN.md`
