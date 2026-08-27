# Theorem-strength interface coverage: 63/63

Authoritative source inventory: `formalization/v7_migration/PHASE2_SIGNATURE_MAP.md` at source release-verification commit `68a9994277a4fbc671d5c61f4a00b902f4b73871`. That source-only file is intentionally not copied into this companion. Classification codes are: **C** transparent frozen carrier/model interface; **P** kernel-proved directly; **F** discharged as a field/conjunct of a proved named carrier; **R** exact approved low-level reuse. No row is unresolved.

| ID | Class | Concrete current V7 discharge | Status |
|---|---|---|---|
| U01 | C | `MethodInput`, `conjugateExponent`, and `1<p` binders in frozen public statements | PASS |
| U02 | P/F | `StrictLocalMethod`, `RandomizedStrictLocalMethod`, `StrictRunConsistent`; Stage 7 `MeasurableTrace` and randomized/expected proofs | PASS |
| U03 | F/P | `SecantInitialization`; `V7.anchor`; `Stage8Main.currentExecution` and `V7.main` preserve the count boundary | PASS |
| U04 | P | `V7.deterministicFiniteHorizonImpossibility` in Stage 6 | PASS |
| U05 | P | `Stage6StrictDeterministic.affineTrace_runConsistent` and `HSelection`; affine transcript is built before `H` | PASS |
| U06 | P | Stage 6 `ScalarHard`/`HardInstance`, including `strictHardFamily`, derivative and `StrictHardInstance` | PASS |
| U07 | P/F | Stage 6 `hard_runConsistent_of_affine` and the exact `R`, `L`, `LR/eps=4` fields of `strictHardInstance` | PASS |
| U08 | P/F | `V7.randomizedFiniteHorizonImpossibility`; Stage 7 `Randomized` chooses one deterministic `H` for the seed family | PASS |
| U09 | P | Stage 7 measurable `strictHittingTime` proof and `V7.infiniteWorstCaseExpectedHittingTime` | PASS |
| U10 | P | `V7.oneDimensionalInteriorLpTransfer` | PASS |
| U11 | C/F | `PositiveInstance`, `minimizerDistance`, `conditionNumber`, `conditionBar`; used by `currentExecution` | PASS |
| U12 | C/F | `DeterministicExactPairAlgorithm`, `GeneratedBy`, `ChargedKnownParameterRun`; discharged by Stage 5 lower/upper proofs | PASS |
| U13 | P/F | `V7.normingDirection_correct`, `V7.anchor`, and anchor execution use | PASS |
| U14 | P/F | `UpperModelGuard`, Stage 1 guard theorems, and `V7.anchor` descent spine | PASS |
| U15 | C/P | `BregmanRemainder`, upper/gradient/cocoercivity guards; Stage 1 and Stage 2 guard theorems | PASS |
| U16 | C/F | `ScaleCorrect` and the proved `TrialCertificate` fields of all three local trials | PASS |
| U17 | C/P | `EuclideanInterpolationGuard`; all ordered pairs in `OGMGAssumptions`; `V7.finiteDataOGMG` | PASS |
| U18 | C/F | `LocalTrialAction` and `O3.Action` expose query/done only; genuine machines in Stages 1, 3, 4, 8 | PASS |
| U19 | F/P | Charged cached `x0` in local/known-parameter carriers; Stage 8 first real query and count identity | PASS |
| U20 | C/P | `ControllerVisit`, `ControllerPath`; Stage 2 certification and Stage 8 `controllerPath_append`/invariants | PASS |
| U21 | C/P | `LocalTrialAction`, `LocalTrial.Executes`, `CachedPair`; Stage 8 `runtimeTrial_spec` and refinement | PASS |
| U22 | P/F | `V7.trialOutcomeCertification`, `V7.geometricTrialAmortization`, Stage 8 indexed realized-path application | PASS |
| B01 | P | `V7.belowTrial` current finite no-log carrier | PASS |
| B02 | P | `belowH`, `belowHstar`, `belowMirrorMap`; `V7.belowGeometry` | PASS |
| B03 | C/P | `CocoercivityGuard`, `ScaleCorrect`; Stage 2 certification and Stage 3 guard discharge | PASS |
| B04 | F | Exact plateau fields in proved `BelowPrimalAssumptions`/`BelowCoefficientAssumptions` chain | PASS |
| B05 | F/P | Stage 3 `PrimalTrajectory` and `V7.belowPrimal` prove exact chronology | PASS |
| B06 | F/P | Stage 3 coefficient support and `BelowXRecurrence` in the primal proof chain | PASS |
| B07 | P | Stage 3 residual constructions and `V7.belowPointwiseResidualIdentity` | PASS |
| B08 | P/F | Stage 3 `DualTrajectory`/`AnalyticBridge`; `V7.belowTerminalGradient` uses direct finite `sInf` | PASS |
| B09 | F | Exact `MD/eps`, horizon and count fields of `V7.belowTrial` | PASS |
| B10 | P/F | Stage 3 `Machine`, `Shapes`, `Semantics`, `Contract`: cached start, Phase I, charged prefix | PASS |
| B11 | P/F | Same Stage 3 operational chain: reused endpoint, Phase II, charged prefix | PASS |
| B12 | P | `V7.belowGuardScaling` with all three exact clauses and `1<p` repair | PASS |
| B13 | P/F | `V7.belowTrial` certificate and both no-log call bounds | PASS |
| E01 | P | `V7.euclideanGap` | PASS |
| E02 | P | `V7.finiteDataOGMG` | PASS |
| E03 | P/F | `V7.euclideanTrial`; Stage 1 E03 genuine machine, exact failure/success traces and `2m+n+1` | PASS |
| A01 | P | `aboveH`, `aboveHstar`, `aboveMirrorMap`; `V7.aboveGeometry` | PASS |
| A02 | P/F | Stage 4 coefficient/trajectory proof of general positive nondecreasing plateau support and dynamics | PASS |
| A03 | P | Stage 4 `PrimalResidual`, `PrimalEnergy`, and mixed-residual lower bound | PASS |
| A04 | P/F | `V7.aboveWeightErrorBalance`, explicit error constants/sum, exact `aboveHp` horizon | PASS |
| A05 | P | `V7.abovePointwiseResidualIdentity` | PASS |
| A06 | P/F | Stage 4 `DualEnergy`/`AnalyticPrefix`: exact causal chronology and finite `sInf` | PASS |
| A07 | F | Terminal-gradient conclusion of `V7.aboveTrial` | PASS |
| A08 | P/F | Stage 4 `Constants`, `WeightBalance`, `PhaseBounds`; exact `p/(p+2)` balance | PASS |
| A09 | P/F | Stage 4 Phase-I trajectory/analytic/certificate spine of `V7.aboveTrial` | PASS |
| A10 | P/F | Stage 4 Phase-II spine and queried terminal observation in the current certificate | PASS |
| A11 | P/F | `V7.belowGuardScaling` normalization pattern instantiated by current above-trial input | PASS |
| A12 | P/F | Stage 4 genuine `LocalTrial`, exact two query prefixes, cached endpoint, no hidden channel | PASS |
| A13 | P | `V7.knownParameterAboveTwoUpper`, charged `x0`, current exponent | PASS |
| L01 | P/F | Stage 5 kernel calculus/global C2/Hessian/constructor chain and `SmoothingKernelConstructionStatement` | PASS |
| L02 | P | Stage 5 infimal attainment/locality, envelope derivative, approximation and smoothness of `localSmoothingValue` | PASS |
| L03 | P/F | Stage 5 construction/symmetry/completion data: exact parameters, unused coordinate, signs, cap, causal trace, `T<=d` | PASS |
| L04 | P | `V7.aboveLowerExactPairCompletion` | PASS |
| L05 | P | `V7.aboveLowerQueryGap` | PASS |
| L06 | P | `V7.aboveLowerOutsideGradient` | PASS |
| L07 | P | `V7.aboveLowerBaseGradient` | PASS |
| L08 | P | `V7.aboveLowerOptimizerRadius`, with `rT` before completion | PASS |
| L09 | P/F | `V7.knownParameterAboveTwoLower`: physical `L,R`, `512`, selected horizon, fixed-`p` large-`d` clause | PASS |
| G01 | C/P | `localCostExponent`, `CurrentMainRate`; Stage 8 exact three-way normalization | PASS |
| G02 | P/F | `V7.geometricTrialAmortization`; Stage 8 actual ragged visits/reports and `reportCalls_bound` | PASS |
| G03 | P | `V7.main`: causal method, immediate charged query, termination witness, queried return, exact inputs | PASS |

Count: U = 22, B = 13, E = 3, A = 13, L = 9, G = 3; total = **63**.

```text
THEOREM_STRENGTH_INTERFACE_COVERAGE: 63/63
UNRESOLVED_INTERFACE_COUNT: 0
```
