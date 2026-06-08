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
- `sources/kappa-spin/designspace/Comfortaa.designspace` connects masters and instances

## Current State

Observed source model:
- 3 master UFOs
  - `Comfortaa-Light.ufo`
  - `Comfortaa-Regular.ufo`
  - `Comfortaa-Bold.ufo`
- 5 instance UFOs
  - `Comfortaa-Light.ufo`
  - `Comfortaa-Regular.ufo`
  - `Comfortaa-Medium.ufo`
  - `Comfortaa-SemiBold.ufo`
  - `Comfortaa-Bold.ufo`
- 1 designspace file

Current interpolation structure:
- weight axis from `300` to `700`
- mapped design values from `60` to `104`
- bracket rule present for `hryvnia`

## Findings

### 1. Source naming is still fully upstream-shaped

Status: not yet adopted

Current family/source naming still uses:
- `Comfortaa`
- `Comfortaa-*`

Unlike `Kappa Mark`, this family has not yet been renamed/adopted into KM-owned source naming.

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

Status: cleanup required later

Observed in the masters:
- family name is still `Comfortaa`
- no PostScript font name set in the inspected masters
- vendor ID is `CYRE`
- manufacturer/designer are still upstream values
- guideline residue is still present

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

## Recommended Next Step

Create a `Kappa Spin` adoption pass similar to `Kappa Mark`, but with extra care for:
- multi-master designspace integrity
- grouped kerning preservation
- bracket rule preservation
- instance naming consistency
