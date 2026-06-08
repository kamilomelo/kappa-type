# Kappa Spin Source Audit

Date: 2026-06-08

Scope:
- canonical master UFOs
- canonical instance UFOs
- designspace file
- font metadata
- kerning/group structure

## Current Build Boundary

`Kappa Spin` is upstream-informed by Comfortaa.

Current source path:
- `sources/kappa-spin/upstream-import` keeps the upstream Glyphs source as reference input
- `sources/kappa-spin/ufo/masters` holds the current canonical master UFOs
- `sources/kappa-spin/ufo/instances` holds build-oriented instance UFOs
- `sources/kappa-spin/designspace/KappaSpin.designspace` connects masters and instances

## Current State

Observed source model:
- 3 master UFOs
  - `KappaSpin-Light.ufo`
  - `KappaSpin-Regular.ufo`
  - `KappaSpin-Bold.ufo`
- 5 instance UFOs
  - `KappaSpin-Light.ufo`
  - `KappaSpin-Regular.ufo`
  - `KappaSpin-Medium.ufo`
  - `KappaSpin-SemiBold.ufo`
  - `KappaSpin-Bold.ufo`
- 1 designspace file

Current interpolation structure:
- weight axis from `300` to `700`
- mapped design values from `60` to `104`
- bracket rule present for `hryvnia`

## Findings

### 1. Source naming is now KM-owned

Status: fixed for current baseline

Current family/source naming now uses:
- `Kappa Spin`
- `KappaSpin-*`

Designspace, masters, and instances now all use KM-owned filenames and family naming.

### 2. Kerning structure is healthier than Kappa Mark

Status: good, but conversion warnings still matter

Observed in masters:
- `415` groups
- `969` kerning pairs

That is a better long-term maintenance shape than pair-only kerning.

### 3. Conversion warnings remain the main risk

Status: review required

The upstream Glyphs-to-UFO conversion emits many missing kerning-class warnings.

This does not mean the font is broken, but it does mean:
- the import is noisier than `Kappa Mark`
- group/kerning integrity needs careful review before calling the source fully clean

### 4. Metadata is still upstream-era

Status: largely fixed for current baseline

Current state in the adopted sources:
- family name is `Kappa Spin`
- PostScript names are `KappaSpin-*`
- vendor ID is `KMXG`
- manufacturer/designer are `KM-X Group`
- guideline residue has been removed

Still intentionally upstream-derived:
- copyright and OFL provenance

### 5. Glyph count and source complexity are much larger

Status: note

Observed:
- `884` glyphs in each inspected master

This family is materially larger than `Kappa Mark`, so cleanup needs to be more careful and incremental.

## Initial Recommendations

Priority 1:
- do not change the visual design yet
- do not rewrite kerning yet
- keep the current interpolation model intact

Priority 2:
- adopt the source naming into KM-owned filenames, family names, and designspace references
- preserve interpolation and kerning/group structure while doing so

Priority 3:
- only after adoption, review metadata policy, guideline residue, and remaining import baggage

## Current Baseline

Current state after adoption:
- build completes from KM-owned instance UFOs
- grouped kerning remains intact
- bracket rule for `hryvnia` remains intact
- the remaining known risk is still the noisy upstream conversion warnings
- visual comparison against Comfortaa is acceptable
- `Kappa Spin` is now frozen as the approved baseline

Deferred watchlist:
- variants of the letter `O`

The next appropriate step is future redesign work only when explicitly requested.

## Recommended Next Step

Future redesign work should begin from the frozen baseline, starting with the recorded watchlist glyphs.
