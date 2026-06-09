# Public Repo Plan

This repository currently serves two roles at once:

1. internal working repository
2. public legal/distribution repository

That is workable, but not ideal for the long term.

## Recommendation

Use two layers:

### 1. Internal Master Repo

Keep the full engineering workflow here:
- `families/`
- `sources/`
- `scripts/`
- `proofs/`
- `references/`
- detailed audit and redesign notes

Purpose:
- ongoing design and engineering work
- proof-led review
- source adoption
- future divergence from upstreams

### 2. Lean Public Repo

Publish only what is needed for:
- legal provenance
- font distribution
- basic trust and discoverability

Recommended contents:
- `README.md`
- `LICENSE`
- `fonts/`
- `licenses/`
- a minimal `sources/` subset only if you want to expose editable source basis publicly

Purpose:
- distribution
- compliance
- simple public presentation

## If You Keep Only One Repo

If you do not want a second repo, then this repo should still be trimmed toward a public-facing distribution model.

Recommended public-facing keep set:
- `README.md`
- `LICENSE`
- `CONTRIBUTING.md`
- `fonts/`
- `licenses/`
- `.gitattributes`
- `.gitignore`

Recommended remove-or-ignore set:
- `proofs/`
- `references/`
- most `families/*/AUDIT.md`
- most `families/*/REDESIGN.md`
- most `scripts/` if you do not intend to present the engineering workflow publicly
- possibly `sources/` if the goal is only distribution and legal traceability

## Practical Public Models

### Model A: Distribution Repo

Keep:
- final TTFs
- final WOFF2s
- license files
- short README

Remove from tracked public view:
- proofs
- engineering scripts
- internal source notes
- redesign backlog

Best if:
- you mainly want a legal public home for the fonts
- you do not care about public engineering transparency

### Model B: Minimal Source Repo

Keep:
- final outputs
- license files
- minimal canonical source files
- very small build documentation

Remove:
- most process noise
- private reference notes
- most generated review material

Best if:
- you want the repo to remain a source repo
- but not a full engineering diary

## Recommended Choice For Kappa Type

Based on your stated goal, the best fit is:

- internal repo: full workflow
- public repo: lean distribution/source repo

If you want to stay with one repo for now, use a trimmed version of **Model B**.

## Proposed Lean Public Layout

```txt
README.md
LICENSE
CONTRIBUTING.md
.gitattributes
.gitignore

fonts/
licenses/

sources/
  kappa-mark/
  kappa-mono/
  kappa-spin/
  kappa-text/
```

Optional:
- a small `docs/` folder

Not recommended for the public repo:
- `proofs/`
- `references/`
- `tmp/`
- `upstream/`
- large workflow notes

## Suggested Next Cleanup Pass

If you later want to trim this repository in place, do it in this order:

1. shorten `README.md` further
2. remove `proofs/` from tracking
3. remove `references/` from tracking
4. decide whether `families/` stays public
5. decide whether `scripts/` stays public
6. decide whether `sources/` stays full or minimal

## Important Constraint

Do not remove:
- font binaries you intend to distribute
- upstream license and notice material
- enough provenance to explain what each family is derived from

The goal is to reduce noise, not to create mystery binaries.
