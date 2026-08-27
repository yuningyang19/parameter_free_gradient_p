# Certified source snapshot

This commit contains a byte-identical extraction of the current certified Lean
proof surface from
[`yuningyang19/parameter_free_gradient`](https://github.com/yuningyang19/parameter_free_gradient)
at mathematical certification commit
`eb1b55d448496dca56a87001e4d792c483e057ce`.

The extracted package contains the mechanically reconstructed 144-module V7
proof closure, the frozen V7 statement/root layer, and only the 33 O3 modules
that are transitively load-bearing for those V7 roots. The extraction manifest
records the source Git blob and SHA-256 identities for all 190 Lean files.

This snapshot certifies only the frozen mathematical proof surface represented
by 22 named results and 63 theorem-strength interfaces. It does not certify
manuscript prose, citations, novelty, attribution, empirical claims outside the
formal carriers, or publication suitability.
