# Source binding

```text
Original source repository:
https://github.com/yuningyang19/parameter_free_gradient

Original mathematical certification commit:
eb1b55d448496dca56a87001e4d792c483e057ce

Original independent release-verification commit:
68a9994277a4fbc671d5c61f4a00b902f4b73871

Companion repository:
https://github.com/yuningyang19/parameter_free_gradient_p

Target certified source snapshot commit:
f5094d1ab0cf53c2a56067604513a6bfbea26086

Target public package commit:
SELF (the commit containing this file; resolve with `git rev-parse HEAD`)
```

`SELF` is intentional: inserting a commit's own SHA into its tree changes that SHA. The immutable Git object selected by `v1.0-certified`, plus `git rev-parse HEAD`, supplies the exact public-package identity without circularity.

The extraction manifest records the source Git blob, source SHA-256, and target SHA-256 for every one of the 190 mathematical/infrastructure Lean files. All proof-carrying bytes come from `eb1b55d448496dca56a87001e4d792c483e057ce`. Public maps and claim-boundary metadata were derived from `68a9994277a4fbc671d5c61f4a00b902f4b73871`.

## Frozen manuscript hashes recorded by the source release

The manuscript is intentionally absent from this repository and is not reverified here. For provenance only, the source release recorded:

```text
paper/manuscript_v7/main.tex:
bc9c5d10dc47a9beb38fe60a64cf7873c7c3d5a414a4c5ab7fb4362b9e5b9e2c

paper/manuscript_v7/pgtwo_section.tex:
9b3ed506acf303c4076829d5a2622ae3b0240e8b6c56d7cd3125d229611602d7
```

An old Stage-8 Markdown table transcribed the `TrialOutcomeCertificationStatement` carrier hash with 63 hexadecimal characters by omitting `18`. The independently recomputed authoritative hash used here is:

```text
70eae257d1d1e1603cdc69e7167cc183b6d91ff8b23c5a427e027510d58127
```

This was an evidence-table typo, not mathematical drift.
