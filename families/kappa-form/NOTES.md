`Kappa Form` is upstream-informed by Open Sans.

Current state:
- `upstream/opensans` is the read-only provenance source.
- `sources/kappa-form/upstream-import` contains the imported non-condensed UFOs, designspaces, and feature source used as the upstream baseline.
- `sources/kappa-form/ufo/masters` contains the current canonical master UFOs.
- `sources/kappa-form/ufo/instances` is reserved for future generated instances.
- `sources/kappa-form/designspace` contains tracked KM-owned designspace files for the family.

Status:
- source naming and metadata are now adopted into KM-owned naming
- condensed styles are intentionally excluded from milestone 1
- milestone-1 builds currently use the adopted master UFOs directly
- visual baseline is now approved and frozen

Upstream source format:
- UFOs
- designspace
- feature source
- original `.glyphs` files retained only in `upstream/opensans/original source`

UFO-first plan:
1. keep the imported Open Sans UFOs and designspaces as the upstream reference baseline;
2. maintain KM-owned master UFOs and designspace as the canonical editable source layer;
3. introduce generated instance UFOs only after the Open Sans interpolation path is cleaned up enough to trust as a baseline;
4. freeze a baseline before any visual redesign.

Current progress:
- master UFOs now exist in `sources/kappa-form/ufo/masters` as `KappaForm-*`
- tracked KM-owned designspaces now exist in `sources/kappa-form/designspace`
- copied Open Sans notices now exist in `licenses/kappa-form`
- current baseline is visually approved against Open Sans and frozen
- deferred redesign notes live in `families/kappa-form/REDESIGN.md`
