# Parameter-Free Gradient Lean Companion

This repository is the Lean 4 companion formalization for the current parameter-free gradient-norm optimization manuscript. The certified source was extracted byte-for-byte from the mathematical certification commit of the development repository and independently rebuilt after extraction. The certification covers the frozen mathematical proof surface represented by 22 named results and 63 theorem-strength interfaces.

The three principal exports are:

- `V7.scaleIdentificationImpossibility` — strict-oracle scale-identification impossibility;
- `V7.knownParameterAboveTwoOptimality` — known-parameter optimality above two;
- `V7.main` — the current parameter-free runtime theorem.

In plain language, the first theorem shows that a strict local exact
value-gradient method cannot discover the missing scale within any prescribed
finite horizon, even while `LR/epsilon = 4`; it includes deterministic,
randomized finite-horizon, and worst-case expected-hitting-time forms. The
second theorem combines a dimension-free known-parameter upper bound for fixed
finite `p > 2` with the matching polynomial lower exponent `p/(p+2)`, subject
to the stated horizon and dimension qualifications. The third theorem gives
one explicit deterministic post-secant-initialization method family, unaware of
`L`, `R`, and `f*`, with the `1/2`, `1/2`, and `p/(p+2)` regimes and the stated
additive calibration cost. The exact quantifiers and models are in
[`Challenge.lean`](Challenge.lean).

## Reproduce

Install the toolchain named in `lean-toolchain`, then run:

```bash
lake exe cache get
lake clean
lake build
python3 scripts/verify_source_identity.py
python3 scripts/verify_certification.py
ruby scripts/validate-formalization.rb
python3 scripts/verify_palomar.py
```

The package pins Lean `v4.33.0` and Mathlib commit `db584cd6d46c92f209a44c0f1c829460d327499d`. The verification scripts check the 190-file source manifest, recompute the 144-module V7 proof closure and its 33 load-bearing O3 dependencies, reject nine obsolete dependency sentinels and proof escape hatches, check 63/63 interface rows, and elaborate the 22-export whole-paper axiom audit.

## Certification boundary

Lean certification here is deliberately narrow. It covers the frozen R2/R2C1 mathematical carriers and proof surface. It does **not** certify manuscript prose, citations, attribution, novelty, empirical claims outside the carriers, or publication suitability. Historical O3 packages are not advertised as current theorems and were omitted unless mechanically required by the current V7 closure.

See [source binding](audit/SOURCE_BINDING.md), the [22-result theorem map](audit/THEOREM_MAP.md), the [63-interface ledger](audit/INTERFACE_COVERAGE.md), and the [reproducibility guide](REPRODUCIBILITY.md).

## Palomar-facing surface

The Palomar-facing package exposes exactly the three principal exports
in root `Challenge.lean` and `Solution.lean`; the remaining 19 named results stay
inside the certified proof closure. Run `python3 scripts/verify_palomar.py` for
the metadata/licence, challenge leakage, solution elaboration, and three-export
axiom audits. The submission entry points are [`formalization.yaml`](formalization.yaml),
[`Challenge.lean`](Challenge.lean), [`Solution.lean`](Solution.lean), and
[`comparator.json`](comparator.json). See the
[public-surface audit](palomar/PUBLIC_SURFACE_AUDIT.md) for the exact boundary.

This repository is public and its root snapshot licence is Apache-2.0. Official
Comparator/NanoDa verification and editorial review remain external Palomar
gates; a local green build is not registration or endorsement. Submissions use
the [Palomar submission service](https://submit.palomar-registry.org/) and an
exact 40-character commit, never a mutable branch name. Inside its own tree the
current immutable commit is represented as `SELF`; resolve it with
`git rev-parse HEAD`, as explained in [the reproducibility guide](REPRODUCIBILITY.md).
