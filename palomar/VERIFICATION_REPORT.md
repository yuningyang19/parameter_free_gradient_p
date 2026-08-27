# Verification report

The release candidate is accepted locally only if all commands below pass from
a clean checkout with the pinned Lean and Mathlib revisions:

```bash
lake exe cache get
lake clean
lake build
python3 scripts/verify_source_identity.py
python3 scripts/verify_certification.py
ruby scripts/validate-formalization.rb
python3 scripts/verify_palomar.py
```

The complete cold build on GitHub commit
`b541040aa1ff004f265ef53135c1d3d9f344f998` succeeded on 2026-08-27 and
reported `Build completed successfully (8907 jobs)`. Its subsequent source
identity, certification, and public-surface steps all passed in workflow run
`33046105875`.

The earlier run `33043804909` for packaging commit
`217d6761aed58295dde3484624c4bd8acb220527` did not report a Lean error. Its
hosted runner exhausted its filesystem while the cold build was still active
and terminated with `No space left on device`. The succeeding `b541040...`
tree changes only the canonical root `LICENSE` relative to `217d676...`, so its
green 8,907-job build and full audit stack reconcile that infrastructure-only
failure. Commit `d8b898660732d51719c99be9e0b66b46ce51d040`
separately frees unused preinstalled hosted-runner toolchains before future cold
builds; it changes no mathematical or Palomar Lean file.

The local package audit status after adding v0.4 metadata is:

```text
PALOMAR_PUBLIC_SURFACE_GATE: PASS
FORMALIZATION_YAML: PASS
ROOT_LICENSE: Apache-2.0
PUBLIC_HEADLINE_RESULTS: 3
IMPOSSIBILITY_STATEMENT_MATCH: PASS
PGTWO_OPTIMALITY_STATEMENT_MATCH: PASS
MAIN_STATEMENT_MATCH: PASS
CHALLENGE_LEAKAGE_AUDIT: PASS
SOLUTION_BUILD: PASS
SOURCE_IDENTITY: PASS (190/190)
EXISTING_22_RESULT_CERTIFICATION: PASS
EXISTING_63_INTERFACE_CERTIFICATION: PASS
AXIOM_AUDIT: PASS
MATHEMATICAL_CARRIER_DRIFT: NONE
NEW_BRANCH_CREATED: NO
OFFICIAL_COMPARATOR_LOCAL_RUN: NOT_SUPPORTED
```

The three statement-match rows are bound in `PUBLIC_SURFACE_AUDIT.md`; the
machine audit checks the metadata/licence contract, challenge names, import
boundary, placeholder count, solution imports, elaboration, and axioms.

The macOS packaging host does not provide the Linux/Landrun, Go, and Cargo
environment required for the official protected Comparator/NanoDa workflow.
That fact is recorded as `NOT_SUPPORTED`, not as a local pass. Palomar's
official mechanical verifier must still check the exact immutable submission
commit. Its result, the final GitHub Actions result, the editorial review, and
any registration are external facts and are deliberately not hard-coded into
this self-referential Git tree.
