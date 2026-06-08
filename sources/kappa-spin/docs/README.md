Canonical source target: UFO-first.

Current directories:
- `upstream-import/`: imported Comfortaa Glyphs source and build config
- `ufo/masters/`: canonical master UFOs generated from the upstream Glyphs source
- `ufo/instances/`: instance UFOs generated from the designspace for build output work
- `designspace/`: tracked designspace files connecting the masters and instances

Upstream Glyphs sources remain the reference baseline; the KM-maintained source model for this family should now converge on master UFOs plus designspace.
Known issue: master and instance generation still emits many missing kerning-class warnings from the upstream data.
