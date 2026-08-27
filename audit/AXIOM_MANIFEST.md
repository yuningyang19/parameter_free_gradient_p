# Axiom manifest

`V7.Proofs.Stage8Main.WholePaperAudit` runs `#print axioms` on the exact 22 certified exports. Every export reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

The deterministic verification script elaborates that audit entry point and compares every reported set with this exact ordered list. It also performs a source-aware scan, excluding comments and strings, for `sorry`, `admit`, top-level `axiom`, `unsafe`, and `native_decide` across all 190 certified Lean files.

```text
NAMED_EXPORTS: 22
NAMED_EXPORTS_WITH_EXTRA_AXIOMS: 0/22
PROOF_HOLE_OR_ESCAPE_HATCH_SCAN: PASS
```
