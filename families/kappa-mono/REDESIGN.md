# Kappa Mono Future Redesign Backlog

Status: deferred

Current rule:
- do not change the visual behavior of `Kappa Mono` during source-cleanup work
- treat the current KM source state as the approved visual baseline

Future redesign targets already identified:
- numeral: `0`
- numeral: `3`
- lowercase: `g`

Suggested redesign workflow when the time comes:
1. clone the current approved baseline into a review branch or milestone snapshot
2. change only one target area at a time
3. regenerate proofs after each step
4. compare against the approved baseline before accepting the change
5. keep programming-oriented proof strings up to date as new weak spots are found

Current proof watch strings live in:
- `proofs/kappa-mono.html`

Current non-goals:
- no spacing redesign yet
- no feature behavior redesign yet
- no outline redesign yet
