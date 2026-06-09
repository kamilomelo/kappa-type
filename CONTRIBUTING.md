# Contributing

Kappa Type is a font engineering repository, not just a packaging repo.

## Ground Rules

- preserve upstream copyright and OFL notices
- do not reintroduce upstream Reserved Font Names into modified outputs
- do not commit proprietary reference fonts
- keep `upstream/` read-only and untracked
- prefer source adoption and proof-led review over ad hoc binary edits

## Working Model

1. inspect upstream behavior first
2. import or refresh KM sources through the provided scripts
3. rebuild
4. review proofs
5. only then make intentional visual changes

## Current Status

The four active families currently have frozen approved baselines:
- `Kappa Text`
- `Kappa Mark`
- `Kappa Mono`
- `Kappa Spin`

If you want to begin redesign work, start from the relevant `families/*/REDESIGN.md` file rather than changing outlines blindly.

## Useful Commands

```bash
./scripts/bootstrap.sh
./scripts/build.sh
./scripts/proof.sh
./scripts/validate.sh
```

## Public Repo Rule

Anything under `references/` that is not open and redistributable must remain local and untracked.
