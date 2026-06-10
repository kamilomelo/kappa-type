# Kappa Form Source Audit

Date: 2026-06-10

Scope:
- canonical master UFOs
- designspace files
- feature source
- font metadata

## Current Build Boundary

`Kappa Form` is upstream-informed by Open Sans.

Current source path:
- `sources/kappa-form/upstream-import` keeps the imported upstream UFOs, designspaces, and `OpenSans.fea`
- `sources/kappa-form/ufo/masters` holds the canonical KM-owned master UFOs
- `sources/kappa-form/ufo/instances` is reserved for future generated instance UFOs
- `sources/kappa-form/designspace` holds the canonical KM-owned designspace files

## Current State

Target family scope for milestone 1:
- non-condensed styles only
- upright and italic
- no redesign yet

Expected style set:
- Light
- Regular
- Bold
- ExtraBold
- Light Italic
- Italic
- Bold Italic
- ExtraBold Italic

## Initial Findings

### 1. Upstream source quality is strong

Status: good

Open Sans already ships upstream UFOs and designspaces, so `Kappa Form` can be treated as a real UFO/designspace family instead of a binary-import family.

### 2. Condensed branch is intentionally excluded

Status: by design

Upstream includes condensed styles and wider designspace complexity. Milestone 1 excludes them to keep the baseline clean and reviewable.

### 3. KM-owned naming is required throughout

Status: pending visual approval

Canonical sources, designspace references, PostScript names, and metadata should all use:
- `Kappa Form`
- `KappaForm-*`

### 4. Feature source must be preserved

Status: preserve unchanged for now

The imported `OpenSans.fea` should remain intact during milestone 1 unless a build issue forces a minimal technical fix.

### 5. Designspace interpolation is not yet baseline-clean

Status: deferred

Open Sans upstream designspaces can be adopted into KM-owned naming, but the current static instance generation path throws glyph-swap interpolation errors for some heavier styles.

For milestone 1:
- keep the designspaces tracked
- build from the adopted master UFOs directly
- defer trusted instance generation until the interpolation path is audited properly

### 6. Current master-UFO build is viable

Status: good

The current KM build completes successfully from the adopted master UFOs and produces:
- Light
- Regular
- Bold
- ExtraBold
- Light Italic
- Italic
- Bold Italic
- ExtraBold Italic

Observed build caveat:
- `ufo2ft` warns that kerning features are written manually in the source, so implicit UFO kerning is dropped in favor of the feature source

For milestone 1 this is acceptable, because preserving the upstream feature-driven kerning behavior is preferable to rewriting it.

## Recommended Next Step

Current state after adoption:
- build completes from adopted KM-owned master UFOs
- non-condensed Open Sans baseline is visually acceptable
- current baseline is now frozen
- designspace interpolation cleanup remains deferred

Deferred redesign work should begin only when explicitly requested.
