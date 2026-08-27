# Reproducibility

The supported verification procedure starts from a fresh clone and does not update any dependency:

```bash
git clone https://github.com/yuningyang19/parameter_free_gradient_p.git
cd parameter_free_gradient_p
git checkout v1.0-certified
lake exe cache get
lake clean
lake build
python3 scripts/verify_source_identity.py
python3 scripts/verify_certification.py
```

`lake exe cache get` fetches artifacts for the revisions already fixed by `lake-manifest.json`; it does not change the lockfile. `lake clean` removes the package build output so all 190 local Lean modules are elaborated again. To test without the Mathlib binary cache, omit the cache command; that is slower but uses the same pinned source graph.

Expected terminal verdicts include `SOURCE_IDENTITY_TO_EB1B55: PASS`, `NAMED_RESULTS: 22/22`, `THEOREM_STRENGTH_INTERFACES: 63/63`, `EXTRA_AXIOMS: 0/22`, and `CERTIFICATION: PASS`.

The public package commit is represented inside its own immutable tree as `SELF`; resolve it with `git rev-parse HEAD`. This avoids the impossible requirement that a Git commit contain its own SHA while retaining an unambiguous, mechanically resolvable binding. The annotated `v1.0-certified` tag fixes that object externally.
