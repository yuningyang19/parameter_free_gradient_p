# Parameter-Free Gradient Lean Companion

This repository is the Lean 4 companion formalization for the current parameter-free gradient-norm optimization manuscript. The certified source was extracted byte-for-byte from the mathematical certification commit of the development repository and independently rebuilt after extraction. The certification covers the frozen mathematical proof surface represented by 22 named results and 63 theorem-strength interfaces.

The three principal exports are:

- `V7.scaleIdentificationImpossibility` — strict-oracle scale-identification impossibility;
- `V7.knownParameterAboveTwoOptimality` — known-parameter optimality above two;
- `V7.main` — the current parameter-free runtime theorem.

## Reproduce

Install the toolchain named in `lean-toolchain`, then run:

```bash
lake exe cache get
lake clean
lake build
python3 scripts/verify_source_identity.py
python3 scripts/verify_certification.py
```

The package pins Lean `v4.33.0` and Mathlib commit `db584cd6d46c92f209a44c0f1c829460d327499d`. The verification scripts check the 190-file source manifest, recompute the 144-module V7 proof closure and its 33 load-bearing O3 dependencies, reject nine obsolete dependency sentinels and proof escape hatches, check 63/63 interface rows, and elaborate the 22-export whole-paper axiom audit.

## Certification boundary

Lean certification here is deliberately narrow. It covers the frozen R2/R2C1 mathematical carriers and proof surface. It does **not** certify manuscript prose, citations, attribution, novelty, empirical claims outside the carriers, or publication suitability. Historical O3 packages are not advertised as current theorems and were omitted unless mechanically required by the current V7 closure.

See [source binding](audit/SOURCE_BINDING.md), the [22-result theorem map](audit/THEOREM_MAP.md), the [63-interface ledger](audit/INTERFACE_COVERAGE.md), and the [reproducibility guide](REPRODUCIBILITY.md).

## Palomar-facing surface

The optional Palomar-facing package exposes exactly the three principal exports
in root `Challenge.lean` and `Solution.lean`; the remaining 19 named results stay
inside the certified proof closure. Run `python3 scripts/verify_palomar.py` for
the challenge leakage, solution elaboration, and three-export axiom audits. See
the [public-surface audit](palomar/PUBLIC_SURFACE_AUDIT.md) for the exact boundary
and the still-open registry publication prerequisites.
