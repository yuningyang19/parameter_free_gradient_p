# Reproducibility

The supported verification procedure starts from a fresh clone and does not update any dependency:

```bash
git clone https://github.com/yuningyang19/parameter_free_gradient_p.git
cd parameter_free_gradient_p
git checkout <exact-40-character-commit>
lake exe cache get
lake clean
lake build
python3 scripts/verify_source_identity.py
python3 scripts/verify_certification.py
ruby scripts/validate-formalization.rb
python3 scripts/verify_palomar.py
```

`lake exe cache get` fetches artifacts for the revisions already fixed by `lake-manifest.json`; it does not change the lockfile. `lake clean` removes the package build output so all 190 local Lean modules are elaborated again. To test without the Mathlib binary cache, omit the cache command; that is slower but uses the same pinned source graph.

Expected terminal verdicts include `SOURCE_IDENTITY_TO_EB1B55: PASS`, `NAMED_RESULTS: 22/22`, `THEOREM_STRENGTH_INTERFACES: 63/63`, `EXTRA_AXIOMS: 0/22`, and `CERTIFICATION: PASS`.

The annotated `v1.0-certified` tag fixes the original certified-source release.
For a Palomar submission, check out the exact 40-character commit named by the
submission or registry record instead of relying on that earlier tag, then run
the same commands. Official Comparator execution additionally requires the
Linux/Landrun, lean4export, and NanoDa environment described by Palomar; the
Palomar submission verifier supplies that protected environment.

The public package commit is represented inside its own immutable tree as
`SELF`; resolve it with `git rev-parse HEAD`. This avoids the impossible
requirement that a Git commit contain its own SHA while retaining an
unambiguous, mechanically resolvable binding. The Palomar submission and any
registry record fix that exact object externally.
