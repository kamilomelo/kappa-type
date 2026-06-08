Canonical source target: UFO-first.

Current directories:
- `upstream-import/`: imported ABeeZee Glyphs sources and build config
- `ufo/masters/`: canonical KM master UFOs generated from the upstream Glyphs source and then adopted into KM naming
- `ufo/instances/`: KM instance UFOs generated from the designspace for build output work
- `designspace/`: tracked KM designspace files connecting the masters and instances

Upstream Glyphs files remain reference material; the KM-maintained source model for this family should now converge on master UFOs plus designspace.

Operational rule:
- `Kappa Mark` builds from `ufo/instances/`
- normal builds do not regenerate these UFOs from ABeeZee
- upstream refresh is explicit: `KAPPA_MARK_REIMPORT_FROM_UPSTREAM=1 ./scripts/import-ufo-sources.sh`
