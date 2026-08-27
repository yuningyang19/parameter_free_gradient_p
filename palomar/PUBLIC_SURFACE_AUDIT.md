# Public surface audit

## Frozen authorities

- Manuscript mathematical authority: `68483ace24e4e6e6094f6116fd5f4214f6676d7f`.
- Lean mathematical certification: `eb1b55d448496dca56a87001e4d792c483e057ce`.
- Original-repository independent release verification:
  `68a9994277a4fbc671d5c61f4a00b902f4b73871`.
- Companion source snapshot: `f5094d1ab0cf53c2a56067604513a6bfbea26086`.
- Companion certified release before this packaging layer:
  `0a673d5c6efeefb4fdae872b7f829db1b692f3bb`.

## Current policy binding

Retrieved on 2026-08-27:

- Palomar policy: `d5a647db3757303b1d928cfae4d3d232eed3e79e`;
- Palomar template: `128a6c5ce5f48622e69927ccd639cbff401022e8`;
- `formalization.yaml` schema repository:
  `99c678e569c7c4c0772db297c5ddd5e4c9b6322e` (schema v0.4);
- Comparator documentation: `8d84e678dc9954b12db91f7f3167a169b309e0c8`;
- Palomar submission taxonomy/toolchain snapshot:
  `e215b184d1b659e8e3e641162a7d63708678016f`.

The checked classifications are `math.OC` (Optimization and Control) and
`90C25` (Convex programming). The project uses Lean v4.33.0, above the current
Palomar minimum v4.28.0.

## Manuscript-tip reconciliation

The current manuscript branch tip
`4b6d77604d22fc91f86f67927d75d04ef7ce796c` changes no byte in any of the
three frozen source theorem blocks relative to mathematical authority
`68483ace24e4e6e6094f6116fd5f4214f6676d7f`:

| Source block | SHA-256 at both commits | Status |
| --- | --- | --- |
| `thm:impossibility` | `090644381fcf72892f6a7863d9cd395b76bc291aaf19e6055138e71c983a1eb6` | PASS |
| `prop:pgtwo-optimality` | `0f49f7e5509543bc845dbb20b2faef8007e23ea67be0cdd0dd5237f368ddb4b4` | PASS |
| `thm:main` | `64f4915387c574bac2ced58e0b2d0b45077583657dfee06702315348f828c056` | PASS |

## Three-way correspondence

| Public declaration | Manuscript label | Certified Lean carrier | Existing proof closure | Exact type, no rewrite | Axioms | Status |
| --- | --- | --- | --- | --- | --- | --- |
| `V7.scaleIdentificationImpossibility` | `thm:impossibility` | `V7.ScaleIdentificationImpossibilityStatement` | `V7.Proofs.Stage7StrictRandomizedExpected.Closure` | YES | `propext`, `Classical.choice`, `Quot.sound` | PASS |
| `V7.knownParameterAboveTwoOptimality` | `prop:pgtwo-optimality` | `V7.KnownParameterAboveTwoOptimalityStatement` | `V7.Proofs.Stage5AboveTwoLowerS5F.Closure` | YES | `propext`, `Classical.choice`, `Quot.sound` | PASS |
| `V7.main` | `thm:main` | `V7.MainStatement` | `V7.Proofs.Stage8Main.Closure` | YES | `propext`, `Classical.choice`, `Quot.sound` | PASS |

The challenge statement closure was obtained by expanding the environment
dependencies of the three certified carriers. It needs 134 local declarations
from the O3/V7 statement layer. The resulting root challenge remains below
Palomar's 1,000-line and 100-KiB limits; the exact current counts are reported
by `scripts/verify_palomar.py`.

It is above Palomar's 300-line warning threshold. This warning is documented
rather than hidden: the file keeps the transparent carrier closure and exact
types, and no compression by opaque wrappers or semantic rewriting is used.

For all three rows: `MANUSCRIPT_STATEMENT_MATCH = PASS`,
`LEAN_EXPORT_MATCH = PASS`, `NO_SEMANTIC_WIDENING = PASS`, and
`CURRENT_PROOF_CLOSURE = PASS`.

## Leakage boundary

- `Challenge.lean` imports exactly `Mathlib` and no local O3/V7 proof module.
- It exposes exactly three Comparator-selected theorem holes and has exactly
  three expected `sorry` placeholders. Six proof-complete auxiliary theorems
  reproduce source-generated numeral-instance constants required by
  Comparator's transitive declaration-closure comparison; none is a public
  hole or a configured headline result.
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
solution elaboration, metadata/licence agreement, and axiom set. The repository
is public and GitHub detects the canonical root `LICENSE` as Apache-2.0, matching
`formalization.yaml`. These facts make the package eligible for official
submission; they do not themselves claim an official Comparator/NanoDa pass,
editorial clearance, registration, novelty, or endorsement.

## Official Comparator closure correction

The first official Palomar mechanical run for companion commit
`668cc312ff917d9cb897195e60fc0c5bc59530df` built the full project and exported
all three solutions, then rejected the declaration closure at
`V7.CurrentMainRate`. The source declarations were compiled in separate Lean
modules, whereas the Mathlib-only challenge must be one trusted file. Lean's
instance cache therefore attached extensionally equal numeral proofs to
different generated constant names.

The correction does not change `O3/`, `V7/`, `V7.lean`, a carrier proposition,
or `comparator.json`. It recreates the six source-generated auxiliary theorem
constants and binds them locally while elaborating the copied carriers. The
pinned Comparator revision
`575674928e239f5bc452aab72d1dd7b0f1326494`, with toolchain-matched
`lean4export` revision `15f6055e299ad5b89345e533cc2192f4cc00f659`, then reports an exact local
declaration-closure match. This local result is a pre-submission check, not a
claim that a replacement official Palomar run has already passed.
