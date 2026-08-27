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

Source bindings used for this package are:

- paper repository `yuningyang19/parameter_free_gradient`, branch
  `paper/manuscript-v7-narrow-repair`, mathematical authority commit
  `68483ace24e4e6e6094f6116fd5f4214f6676d7f`;
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
python3 scripts/verify_palomar.py
```

The official Palomar comparator is an additional release gate, not something
this repository's local audit claims to replace. A registry submission also
requires a public repository and an explicitly selected compatible root
license. Those two publication choices are intentionally not made by this
mathematical packaging change.

See `PUBLIC_SURFACE_AUDIT.md` for statement binding and
`VERIFICATION_REPORT.md` for the reproducibility contract.
