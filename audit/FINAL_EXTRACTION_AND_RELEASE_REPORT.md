# Final extraction and release report

## Immutable bindings

```text
SOURCE_REPOSITORY: yuningyang19/parameter_free_gradient
SOURCE_MATHEMATICAL_CERTIFICATION_COMMIT: eb1b55d448496dca56a87001e4d792c483e057ce
SOURCE_RELEASE_VERIFICATION_COMMIT: 68a9994277a4fbc671d5c61f4a00b902f4b73871
TARGET_REPOSITORY: yuningyang19/parameter_free_gradient_p
TARGET_BRANCH: main
TARGET_CERTIFIED_SOURCE_SNAPSHOT_COMMIT: f5094d1ab0cf53c2a56067604513a6bfbea26086
TARGET_PUBLIC_PACKAGE_COMMIT: SELF (`git rev-parse HEAD`)
LEAN_TOOLCHAIN: leanprover/lean4:v4.33.0
MATHLIB_COMMIT: db584cd6d46c92f209a44c0f1c829460d327499d
```

## Extracted surface

```text
MATHEMATICAL_LEAN_FILES: 190
V7_CURRENT_PROOF_AND_AUDIT_MODULES: 144
V7_CURRENT_STATEMENT_AND_ROOT_MODULES: 13
O3_LOAD_BEARING_INFRASTRUCTURE_MODULES: 33
NAMED_RESULTS: 22
THEOREM_STRENGTH_INTERFACES: 63
NEGATIVE_SENTINELS: 9
```

The dependency closure was mechanically reconstructed from eleven Stage-8/release roots. Historical O3 packages, research prompts, manuscript sources, temporary evidence, experiments, and every file not required by the current proof closure were intentionally omitted. No license file was invented.

## Reproduction commands

```bash
lake exe cache get
lake clean
lake build
python3 scripts/verify_source_identity.py
python3 scripts/verify_certification.py
```

## Gate verdicts

```text
COMMIT_A_FRESH_CLONE: PASS
COMMIT_A_COLD_BUILD: PASS (8896 jobs)
SOURCE_BYTE_IDENTITY: PASS (190/190)
TARGET_CURRENT_PROOF_MODULES: PASS (144/144)
TARGET_NAMED_RESULTS: 22/22
TARGET_INTERFACES: 63/63
TARGET_EXTRA_AXIOMS: 0/22
TARGET_NEGATIVE_SENTINELS_IN_CLOSURE: 0/9
TARGET_PROOF_HOLE_SCAN: PASS
TARGET_SOURCE_IDENTITY_TO_EB1B55: PASS
MATHEMATICAL_LEAN_BYTES_CHANGED_DURING_PACKAGING: NO
PUBLIC_REPRODUCIBILITY_PACKAGE: PASS
CERTIFICATION_BOUNDARY: PASS
```

The post-Commit-B third-party fresh-clone gate and exact public commit ID are necessarily external to this commit's tree: the immutable tag and Git object identity bind them without rewriting either published commit. The release is valid only when that external run produces the same verdicts.
