# Hostile release review

| Attack | Mechanical evidence | Verdict |
|---|---|---|
| Packaging silently edits a theorem or proof | 190 source SHA-256 and Git blob checks; Commit A-to-Commit B diff over `O3`, `V7`, and `V7.lean` | REJECTED |
| Entire historical O3 tree is copied | import traversal selects exactly 33 O3 modules | REJECTED |
| An obsolete packaged route gains current credit | nine sentinel module groups are absent from the recomputed closure | REJECTED |
| Missing local dependency is hidden | imports are recomputed from source and their root closure must equal all 190 manifested modules | REJECTED |
| A build succeeds through a proof escape hatch | source-aware token scan rejects `sorry`, `admit`, `axiom`, `unsafe`, and `native_decide` | REJECTED |
| The 22-export claim is only a Markdown count | the exact names occur in both `#check` and `#print axioms`; the audit file is elaborated | REJECTED |
| Extra axioms are hidden | every runtime `#print axioms` result is compared with the exact accepted set | REJECTED |
| The 63-interface claim hides unresolved rows | exactly 63 typed ledger rows must be present and each must be `PASS` | REJECTED |
| Lean or Mathlib drift | toolchain and Mathlib revision are checked against immutable pins | REJECTED |
| Manuscript evidence is misrepresented as copied or rechecked | source hashes are labeled provenance-only; `paper/**` is absent | REJECTED |
| Public package pretends to be the mathematical source | both manifests retain `eb1b55d...` as the mathematical certification commit | REJECTED |
| A commit falsely embeds its own SHA | package identity is explicitly `SELF`, resolved by Git and fixed externally by the tag | REJECTED |
| Historical 63-character carrier hash is propagated | authoritative 64-character `70eae2...d58127` value is recorded | REJECTED |

The source mathematical hostile review additionally checked causal/runtime, rate, lower-bound qualification, and current-versus-obsolete theorem failure modes. This extraction does not reopen those proofs; it preserves their certified bytes and audits their public closure.

The supported conclusion remains narrow: the frozen R2/R2C1 mathematical proof surface represented by 22 named results and 63 theorem-strength interfaces has current Lean proof/declaration coverage under the recorded axiom policy. No prose, citation, novelty, attribution, empirical, or publication claim follows.
