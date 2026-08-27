# Palomar three-result public surface

This directory records the narrow Palomar-facing layer for the certified Lean
companion. The public challenge is deliberately limited to three declarations:

1. `V7.scaleIdentificationImpossibility`;
2. `V7.knownParameterAboveTwoOptimality`;
3. `V7.main`.

`Challenge.lean` imports only Mathlib and contains the transparent statement
closure plus exactly those three placeholders. `Solution.lean` imports the
existing certified proof closures and checks the corresponding exports; it does
not restate or reprove them. The other 19 certified named results remain part of
the load-bearing proof closure and are not promoted to headline challenges.

The three declarations say, respectively:

1. at fixed `LR/epsilon = 4`, every prescribed finite horizon of a strict
   local exact-pair method can be defeated by a one-dimensional smooth convex
   instance, with deterministic, randomized, and worst-case expected-time
   consequences;
2. for fixed finite `p > 2` with known parameters, the upper and lower
   polynomial exponent is `p/(p+2)`, with the lower bound retaining its stated
   horizon, dimension, and `min{p, log d}` qualifications;
3. after a supplied nondegenerate secant initialization, one explicit
   deterministic family returns a queried small-gradient point without knowing
   `L`, `R`, or `f*`, with the three stated `p`-regime costs and additive
   calibration term.

Source bindings used for this package are:

- paper repository `yuningyang19/parameter_free_gradient`, branch
  `paper/manuscript-v7-narrow-repair`, mathematical authority commit
  `68483ace24e4e6e6094f6116fd5f4214f6676d7f`; the current branch tip
  `4b6d77604d22fc91f86f67927d75d04ef7ce796c` has byte-identical copies of
  the three theorem blocks;
- Lean repository `yuningyang19/parameter_free_gradient_p`, branch `main`, base
  commit `0a673d5c6efeefb4fdae872b7f829db1b692f3bb`;
- frozen Lean source certification commit
  `eb1b55d448496dca56a87001e4d792c483e057ce`.

The full companion certifies 22 named manuscript results and 63
theorem-strength interfaces. That Lean certification does not certify prose,
citations, attribution, novelty, or publication suitability. Historical O3
packages are not advertised here as current theorems.

Run the local package audit with:

```bash
ruby scripts/validate-formalization.rb
python3 scripts/verify_palomar.py
```

The repository is public, the root licence is Apache-2.0, and
`formalization.yaml` declares the same SPDX identifier. The 555-line Challenge
is below Palomar's hard limits but above its 300-line auditability warning; it
is retained because mechanically compressing the transparent carrier closure
would add semantic risk.

The official Palomar Comparator plus NanoDa replay remains an external release
gate, not something this repository's local audit claims to replace. Its
protected execution requires Linux/Landrun and the version-matched
lean4export/NanoDa tools. Registration also remains a separate author decision
after the submitter has seen the Palomar review.

See `PUBLIC_SURFACE_AUDIT.md` for statement binding and
`VERIFICATION_REPORT.md` for the reproducibility contract.
