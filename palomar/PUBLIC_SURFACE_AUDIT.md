# Public surface audit

## Frozen authorities

- Manuscript mathematical authority: `68483ace24e4e6e6094f6116fd5f4214f6676d7f`.
- Lean mathematical certification: `eb1b55d448496dca56a87001e4d792c483e057ce`.
- Original-repository independent release verification:
  `68a9994277a4fbc671d5c61f4a00b902f4b73871`.
- Companion source snapshot: `f5094d1ab0cf53c2a56067604513a6bfbea26086`.
- Companion certified release before this packaging layer:
  `0a673d5c6efeefb4fdae872b7f829db1b692f3bb`.

## Three-way correspondence

| Public declaration | Manuscript label | Certified Lean carrier | Existing proof closure | Exact type, no rewrite | Axioms | Status |
| --- | --- | --- | --- | --- | --- | --- |
| `V7.scaleIdentificationImpossibility` | `thm:impossibility` | `V7.ScaleIdentificationImpossibilityStatement` | `V7.Proofs.Stage7StrictRandomizedExpected.Closure` | YES | `propext`, `Classical.choice`, `Quot.sound` | PASS |
| `V7.knownParameterAboveTwoOptimality` | `prop:pgtwo-optimality` | `V7.KnownParameterAboveTwoOptimalityStatement` | `V7.Proofs.Stage5AboveTwoLowerS5F.Closure` | YES | `propext`, `Classical.choice`, `Quot.sound` | PASS |
| `V7.main` | `thm:main` | `V7.MainStatement` | `V7.Proofs.Stage8Main.Closure` | YES | `propext`, `Classical.choice`, `Quot.sound` | PASS |

The challenge statement closure was obtained by expanding the environment
dependencies of the three certified carriers. It needs 134 local declarations
from the O3/V7 statement layer. The resulting root challenge has 555 lines and
25,833 bytes, below Palomar's 1,000-line and 100-KiB limits.

For all three rows: `MANUSCRIPT_STATEMENT_MATCH = PASS`,
`LEAN_EXPORT_MATCH = PASS`, `NO_SEMANTIC_WIDENING = PASS`, and
`CURRENT_PROOF_CLOSURE = PASS`.

## Leakage boundary

- `Challenge.lean` imports exactly `Mathlib` and no local O3/V7 proof module.
- It declares exactly the three public theorems and has exactly three expected
  `sorry` placeholders.
- `Solution.lean` has no `sorry`, `admit`, new `axiom`, `unsafe`, or
  `native_decide`; it imports only the three frozen proof closures.
- `comparator.json` selects exactly the three public theorem names and permits
  only the axioms already accepted by the certified companion.
- The other 19 named certified results remain internal proof dependencies.

## Mathematical byte preservation

This packaging layer changes no file under `O3/`, `V7/`, or `V7.lean` relative
to companion commit `0a673d5c6efeefb4fdae872b7f829db1b692f3bb`.
`scripts/verify_source_identity.py` independently checks all 190 extracted Lean
files against the frozen source manifest.

## Registry boundary

The local audit establishes the challenge shape, elaboration, leakage policy,
solution elaboration, and axiom set. It does not claim an official Palomar
comparator run. At the time of packaging, registry submission remains blocked
because the GitHub repository is private and no root license has been selected.
Consequently `formalization.yaml` is deliberately not fabricated.
