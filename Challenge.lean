import Mathlib

/-!
# Three public-core results for parameter-free gradient minimization

This is the Palomar-facing statement surface.  It contains the exact transparent
definitions needed by the three certified V7 carriers and exactly three theorem
placeholders.  Its only import is Mathlib; in particular, it does not import the
existing V7 proof development.
-/

open scoped BigOperators
open MeasureTheory

namespace O3

/-- A point of the finite-dimensional real space `ℝ^d`. -/
abbrev Point (d : ℕ) := Fin d → ℝ

/-- The coordinate pairing between two vectors. -/
def pairing {d : ℕ} (x y : Point d) : ℝ := ∑ i, x i * y i

/-- The real conjugate exponent `p / (p - 1)`. -/
noncomputable def conjugateExponent (p : ℝ) : ℝ := Real.conjExponent p

/-- The `p`-power sum used to define the literal finite-dimensional `ℓ_p` norm. -/
noncomputable def lpPower (p : ℝ) {d : ℕ} (x : Point d) : ℝ := ∑ i, |x i| ^ p

/-- The literal finite-dimensional `ℓ_p` norm for a real exponent. -/
noncomputable def lpNorm (p : ℝ) {d : ℕ} (x : Point d) : ℝ :=
  (lpPower p x) ^ (1 / p)

/-- The vector type used by the exact-pair oracle model. -/
abbrev Vec (d : ℕ) := Point d

/-- A supplied exact local value-gradient oracle. -/
structure PairOracle (d : ℕ) where
  value : Vec d → ℝ
  gradient : Vec d → Vec d

/-- One exact value-gradient observation at a queried point. -/
structure Observation (d : ℕ) where
  point : Vec d
  value : ℝ
  gradient : Vec d

/-- Evaluate an exact-pair oracle at one point. -/
def PairOracle.observe {d : ℕ} (oracle : PairOracle d) (x : Vec d) : Observation d :=
  ⟨x, oracle.value x, oracle.gradient x⟩

/-- Numerical data supplied to the runtime method, excluding hidden problem parameters. -/
structure MethodInput (d : ℕ) where
  p : ℝ
  eps : ℝ
  x0 : Vec d
  z0 : Vec d
  M0 : ℝ

/-- A deterministic machine action: return a point or query the oracle. -/
inductive Action (d : ℕ) (State : Type) where
  | done (point : Vec d)
  | query (point : Vec d) (next : Observation d → State)

/-- A deterministic first-order state machine fixed before the oracle is supplied. -/
structure FirstOrderMethod (d : ℕ) where
  State : Type
  initial : MethodInput d → State
  action : State → Action d State

/-- The returned point and the chronological list of counted oracle observations. -/
structure RunResult (d : ℕ) where
  returned : Vec d
  queries : List (Observation d)

/-- Fuel-bounded execution of a deterministic exact-pair method. -/
def FirstOrderMethod.runFuel {d : ℕ} (method : FirstOrderMethod d)
    (oracle : PairOracle d) : ℕ → method.State → List (Observation d) → Option (RunResult d)
  | 0, _, _ => none
  | fuel + 1, state, history =>
      match method.action state with
      | .done x => some ⟨x, history⟩
      | .query x next =>
          let obs := oracle.observe x
          method.runFuel oracle fuel (next obs) (history ++ [obs])

/-- Execute a method from the state determined by the supplied public input. -/
def FirstOrderMethod.run {d : ℕ} (method : FirstOrderMethod d)
    (oracle : PairOracle d) (input : MethodInput d) (fuel : ℕ) : Option (RunResult d) :=
  method.runFuel oracle fuel (method.initial input) []

/-- The supplied vector function represents the Fréchet derivative of the objective. -/
def IsCoordinateGradient {d : ℕ} (f : Vec d → ℝ) (grad : Vec d → Vec d) : Prop :=
  ∀ x, DifferentiableAt ℝ f x ∧ ∀ h, fderiv ℝ f x h = pairing (grad x) h

/-- The set of global minimizers of an objective. -/
def MinimizerSet {d : ℕ} (f : Vec d → ℝ) : Set (Vec d) :=
  {x | ∀ y, f x ≤ f y}

/-- The infimal `ℓ_p` distance from `x0` to the minimizer set. -/
noncomputable def minimizerDistance {d : ℕ} (p : ℝ) (f : Vec d → ℝ)
    (x0 : Vec d) : ℝ :=
  sInf ((fun x => lpNorm p (x - x0)) '' MinimizerSet f)

/-- Lipschitz continuity of a gradient from `ℓ_p` to `ℓ_q`. -/
def IsLpSmooth {d : ℕ} (p q L : ℝ) (grad : Vec d → Vec d) : Prop :=
  ∀ x y, lpNorm q (grad x - grad y) ≤ L * lpNorm p (x - y)

/-- Convexity of a real-valued objective on the whole ambient space. -/
def IsConvexObjective {d : ℕ} (f : Vec d → ℝ) : Prop := ConvexOn ℝ Set.univ f

end O3

namespace V7

/-- The ambient finite-dimensional point type. -/
abbrev Point := O3.Point

/-- The exact value-gradient oracle type. -/
abbrev PairOracle := O3.PairOracle

/-- The exact value-gradient observation type. -/
abbrev Observation := O3.Observation

/-- The coordinate pairing, re-exported in the current statement namespace. -/
abbrev pairing {d : ℕ} (x y : Point d) : ℝ := O3.pairing x y

/-- The literal finite-dimensional `ℓ_p` norm. -/
noncomputable abbrev lpNorm (p : ℝ) {d : ℕ} (x : Point d) : ℝ := O3.lpNorm p x

/-- The real conjugate exponent. -/
noncomputable abbrev conjugateExponent (p : ℝ) : ℝ := O3.conjugateExponent p

/-- Primitive numerical input for the positive secant-initialized runtime model. -/
structure MethodInput (d : ℕ) where
  p : ℝ
  eps : ℝ
  x0 : Point d
  z0 : Point d
  M0 : ℝ

/-- Chronological post-initialization runtime data. -/
structure PairRunResult (d : ℕ) where
  returned : Point d
  trace : List (Observation d)

/-- The number of post-initialization exact-pair calls. -/
def PairRunResult.postInitializationCallCount (run : PairRunResult d) : ℕ :=
  run.trace.length

/-- Every recorded observation is the exact oracle response at its recorded point. -/
def TraceExact (oracle : PairOracle d) (trace : List (Observation d)) : Prop :=
  ∀ obs ∈ trace, obs = oracle.observe obs.point

/-- A point occurs among the chronological queried observations. -/
def WasQueried (trace : List (Observation d)) (x : Point d) : Prop :=
  ∃ obs ∈ trace, obs.point = x

/-- The returned point is one of the points actually queried. -/
def PairRunResult.returnedWasQueried (run : PairRunResult d) : Prop :=
  WasQueried run.trace run.returned

/-- Convert the current runtime input to the underlying state-machine input. -/
def MethodInput.toO3 (input : MethodInput d) : O3.MethodInput d :=
  ⟨input.p, input.eps, input.x0, input.z0, input.M0⟩

/-- One deterministic method family selected before the runtime exponent and dimension. -/
abbrev RuntimeMethodFamily := (d : ℕ) → O3.FirstOrderMethod d

/-- The runtime method executes to the stated returned point and exact trace. -/
def Executes (method : O3.FirstOrderMethod d) (input : MethodInput d)
    (oracle : PairOracle d) (run : PairRunResult d) : Prop :=
  ∃ (fuel : ℕ) (oldRun : O3.RunResult d),
    method.run oracle input.toO3 fuel = some oldRun ∧
    run.returned = oldRun.returned ∧ run.trace = oldRun.queries

/-- The two supplied points give an exact nondegenerate observable secant scale. -/
def SecantInitialization (input : MethodInput d) (oracle : PairOracle d) : Prop :=
  input.z0 ≠ input.x0 ∧
  oracle.gradient input.z0 ≠ oracle.gradient input.x0 ∧
  input.M0 =
    lpNorm (conjugateExponent input.p)
      (oracle.gradient input.z0 - oracle.gradient input.x0) /
      lpNorm input.p (input.z0 - input.x0) ∧
  0 < input.M0

/-- The oracle's gradient field is the coordinate representation of its derivative. -/
def IsCoordinateGradient (oracle : PairOracle d) : Prop :=
  O3.IsCoordinateGradient oracle.value oracle.gradient

/-- The global minimizer set of the oracle objective. -/
def MinimizerSet (oracle : PairOracle d) : Set (Point d) :=
  O3.MinimizerSet oracle.value

/-- Infimal `ℓ_p` distance from the initial point to the minimizer set. -/
noncomputable def minimizerDistance (p : ℝ) (oracle : PairOracle d)
    (x0 : Point d) : ℝ :=
  O3.minimizerDistance p oracle.value x0

/-- Smoothness of the oracle gradient in the `ℓ_p/ℓ_q` geometry. -/
def IsLpSmooth (p L : ℝ) (oracle : PairOracle d) : Prop :=
  O3.IsLpSmooth p (conjugateExponent p) L oracle.gradient

/-- Proof-side certificate for one convex smooth positive-model objective. -/
structure PositiveInstance (p : ℝ) (d : ℕ) (x0 : Point d) where
  oracle : PairOracle d
  L : ℝ
  L_pos : 0 < L
  coordinateGradient : IsCoordinateGradient oracle
  convex : O3.IsConvexObjective oracle.value
  minimizerNonempty : (MinimizerSet oracle).Nonempty
  smooth : IsLpSmooth p L oracle

/-- The exact infimal `ℓ_p` distance from `x0` to the instance minimizer set. -/
noncomputable def PositiveInstance.R (inst : PositiveInstance p d x0) : ℝ :=
  minimizerDistance p inst.oracle x0

/-- The dimensionless condition number `L R / eps`. -/
noncomputable def conditionNumber (inst : PositiveInstance p d x0) (eps : ℝ) : ℝ :=
  inst.L * inst.R / eps

/-- The truncated condition number `max 1 (L R / eps)`. -/
noncomputable def conditionBar (inst : PositiveInstance p d x0) (eps : ℝ) : ℝ :=
  max 1 (conditionNumber inst eps)

/-- The one-dimensional real point type used for the strict-oracle obstruction. -/
abbrev StrictPoint := Point 1

/-- One strict-model exact-pair observation. -/
abbrev StrictObservation := Observation 1

/-- A finite chronological strict-model transcript. -/
abbrev StrictTranscript := List StrictObservation

/-- Natural Borel structure on a strict exact-pair observation. -/
instance : MeasurableSpace StrictObservation :=
  MeasurableSpace.comap
    (fun obs => (obs.point, obs.value, obs.gradient)) inferInstance

/-- Cylinder sigma algebra on finite strict exact-pair transcripts. -/
@[instance_reducible] def strictTranscriptMeasurableSpace :
    MeasurableSpace StrictTranscript :=
  MeasurableSpace.generateFrom {s : Set StrictTranscript |
    (∃ n : ℕ, s = {trace | trace.length = n}) ∨
    ∃ (k : ℕ) (B : Set StrictObservation), MeasurableSet B ∧
      s = {trace | ∃ obs ∈ B, (trace.drop k).head? = some obs}}

/-- The measurable structure used for finite strict transcripts. -/
instance : MeasurableSpace StrictTranscript := strictTranscriptMeasurableSpace

/-- A deterministic strict-local method with transcript-measurable actions and output. -/
structure StrictLocalMethod where
  eps : ℝ
  x0 : StrictPoint
  nextQuery : StrictTranscript → StrictPoint
  output : ℕ → StrictTranscript → StrictPoint
  nextQuery_measurable : Measurable nextQuery
  output_measurable : ∀ N, Measurable (output N)

/-- A measurable seed-indexed family of strict-local methods. -/
structure RandomizedStrictLocalMethod (Ω : Type*) [MeasurableSpace Ω] where
  run : Ω → StrictLocalMethod
  joint_nextQuery_measurable : Measurable
    (fun z : Ω × StrictTranscript => (run z.1).nextQuery z.2)
  joint_output_measurable : ∀ N, Measurable
    (fun z : Ω × StrictTranscript => (run z.1).output N z.2)

/-- Coerce a randomized strict method to its seed-indexed deterministic family. -/
instance [MeasurableSpace Ω] : CoeFun (RandomizedStrictLocalMethod Ω)
    (fun _ => Ω → StrictLocalMethod) := ⟨RandomizedStrictLocalMethod.run⟩

/-- Exactness of every observation in a strict transcript. -/
def StrictTranscriptExact (oracle : PairOracle 1) (trace : StrictTranscript) : Prop :=
  TraceExact oracle trace

/-- Every one of the first `N` recorded queries has gradient larger than `eps`. -/
def StrictAllFirstNQueriesFail (eps : ℝ) (oracle : PairOracle 1)
    (trace : StrictTranscript) (N : ℕ) : Prop :=
  trace.length = N ∧
  ∀ obs ∈ trace, eps < |oracle.gradient obs.point 0|

/-- A finite transcript-measurable output also has gradient larger than the target. -/
def StrictFiniteOutputFails (method : StrictLocalMethod) (oracle : PairOracle 1)
    (trace : StrictTranscript) (N : ℕ) : Prop :=
  method.eps < |oracle.gradient (method.output N trace) 0|

/-- A queried point or finite transcript-measurable output succeeds by horizon `N`. -/
def StrictSuccessThrough (method : StrictLocalMethod) (oracle : PairOracle 1)
    (trace : StrictTranscript) (N : ℕ) : Prop :=
  (∃ obs ∈ trace.take N, |oracle.gradient obs.point 0| ≤ method.eps) ∨
  |oracle.gradient (method.output N trace) 0| ≤ method.eps

/-- `L` is the least global Lipschitz constant of the one-dimensional gradient. -/
def ExactGradientLipschitzConstant (oracle : PairOracle 1) (L : ℝ) : Prop :=
  (∀ x y, |oracle.gradient x 0 - oracle.gradient y 0| ≤ L * |x 0 - y 0|) ∧
  ∀ L' : ℝ,
    (∀ x y, |oracle.gradient x 0 - oracle.gradient y 0| ≤ L' * |x 0 - y 0|) →
    L ≤ L'

/-- Coercivity of a real objective expressed in the one-dimensional coordinate. -/
def IsCoerciveReal (f : StrictPoint → ℝ) : Prop :=
  ∀ B : ℝ, ∃ R : ℝ, 0 ≤ R ∧ ∀ x, R ≤ |x 0| → B ≤ f x

/-- `xstar` is the unique global minimizer of `f`. -/
def UniqueMinimizer (f : StrictPoint → ℝ) (xstar : StrictPoint) : Prop :=
  (∀ x, f xstar ≤ f x) ∧ ∀ x, f x = f xstar → x = xstar

/-- The affine-quadratic-affine hard family for strict scale identification. -/
noncomputable def strictHardFamily (eps : ℝ) (x0 : StrictPoint) (H : ℝ)
    (x : StrictPoint) : ℝ :=
  let g := 2 * eps
  let z := x 0 - x0 0
  if z ≤ H then -g * z
  else if z ≤ 3 * H then -g * z + (g / (2 * H)) * (z - H) ^ 2
  else g * z - 4 * g * H

/-- The coordinate derivative of the strict hard family. -/
noncomputable def strictHardDerivative (eps : ℝ) (x0 : StrictPoint) (H : ℝ)
    (x : StrictPoint) : StrictPoint :=
  fun _ =>
    let g := 2 * eps
    let z := x 0 - x0 0
    if z ≤ H then -g else if z ≤ 3 * H then g * (z / H - 2) else g

/-- The exact normalized smooth, convex, coercive hard-instance certificate. -/
def StrictHardInstance (eps : ℝ) (x0 : StrictPoint) (H L R : ℝ)
    (oracle : PairOracle 1) (xstar : StrictPoint) : Prop :=
  0 < H ∧
  oracle.value = strictHardFamily eps x0 H ∧
  oracle.gradient = strictHardDerivative eps x0 H ∧
  O3.IsConvexObjective oracle.value ∧
  IsCoerciveReal oracle.value ∧
  O3.IsCoordinateGradient oracle.value oracle.gradient ∧
  UniqueMinimizer oracle.value xstar ∧
  ExactGradientLipschitzConstant oracle L ∧
  0 < L ∧ R = |xstar 0 - x0 0| ∧ L * R / eps = 4

/-- The affine oracle transcript shared before the hidden hard transition. -/
noncomputable def strictAffineOracle (eps : ℝ) (x0 : StrictPoint) : PairOracle 1 :=
  { value := fun x => -(2 * eps) * (x 0 - x0 0)
    gradient := fun _ _ => -(2 * eps) }

/-- A normalized strict instance with `L R / eps = 4`. -/
def StrictNormalizedInstance (eps : ℝ) (x0 : StrictPoint) (L R : ℝ)
    (oracle : PairOracle 1) (xstar : StrictPoint) : Prop :=
  O3.IsConvexObjective oracle.value ∧ IsCoerciveReal oracle.value ∧
  O3.IsCoordinateGradient oracle.value oracle.gradient ∧
  UniqueMinimizer oracle.value xstar ∧
  ExactGradientLipschitzConstant oracle L ∧
  0 < L ∧ R = |xstar 0 - x0 0| ∧ L * R / eps = 4

/-- The first queried-or-returned small-gradient time, with `⊤` for non-attainment. -/
noncomputable def strictHittingTime (method : StrictLocalMethod)
    (oracle : PairOracle 1) (traces : ℕ → StrictTranscript) : ENNReal :=
  sInf {t : ENNReal | ∃ N : ℕ, t = (N : ENNReal) ∧
    StrictSuccessThrough method oracle (traces N) N}

/-- A strict transcript follows the method's causal chronological query rule. -/
def StrictRunConsistent (method : StrictLocalMethod) (oracle : PairOracle 1)
    (trace : StrictTranscript) : Prop :=
  StrictTranscriptExact oracle trace ∧
  ∀ (t : ℕ) (ht : t < trace.length),
    (trace.get ⟨t, ht⟩).point =
      if t = 0 then method.x0 else method.nextQuery (trace.take t)

/-- Deterministic finite-horizon impossibility at fixed normalized condition. -/
noncomputable def DeterministicFiniteHorizonImpossibilityStatement : Prop :=
  ∀ (p eps : ℝ), 1 < p → 0 < eps →
    ∀ (method : StrictLocalMethod), method.eps = eps →
    ∀ (N : ℕ), 0 < N →
      ∃ affineTrace : StrictTranscript,
        affineTrace.length = N ∧
        StrictRunConsistent method (strictAffineOracle eps method.x0) affineTrace ∧
        ∃ (H L R : ℝ) (oracle : PairOracle 1) (xstar : StrictPoint),
          (∀ obs ∈ affineTrace, obs.point 0 - method.x0 0 < H) ∧
          method.output N affineTrace 0 - method.x0 0 < H ∧
          StrictHardInstance eps method.x0 H L R oracle xstar ∧
          StrictRunConsistent method oracle affineTrace ∧
          StrictAllFirstNQueriesFail eps oracle affineTrace N ∧
          StrictFiniteOutputFails method oracle affineTrace N

/-- Randomized finite-horizon impossibility using one hard instance for all seeds. -/
noncomputable def RandomizedFiniteHorizonImpossibilityStatement : Prop :=
  ∀ (p eps : ℝ), 1 < p → 0 < eps →
    ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
      (method : RandomizedStrictLocalMethod Ω) (x0 : StrictPoint),
      (∀ ω, (method ω).eps = eps ∧ (method ω).x0 = x0) →
      ∀ (N : ℕ) (delta : ℝ), 0 < N → 0 < delta → delta < 1 →
        ∃ affineTraces : Ω → StrictTranscript,
          (∀ ω, (affineTraces ω).length = N ∧
            StrictRunConsistent (method ω) (strictAffineOracle eps x0) (affineTraces ω)) ∧
          ∃ (H L R : ℝ) (oracle : PairOracle 1) (xstar : StrictPoint),
            StrictHardInstance eps x0 H L R oracle xstar ∧
            ∃ hardTraces : Ω → StrictTranscript,
              (∀ ω, (hardTraces ω).length = N ∧
                StrictRunConsistent (method ω) oracle (hardTraces ω)) ∧
              MeasurableSet {ω | (∀ obs ∈ affineTraces ω,
                  obs.point 0 - x0 0 < H) ∧
                (method ω).output N (affineTraces ω) 0 - x0 0 < H} ∧
              MeasurableSet {ω |
                StrictSuccessThrough (method ω) oracle (hardTraces ω) N} ∧
              ENNReal.ofReal (1 - delta) ≤ μ {ω |
                (∀ obs ∈ affineTraces ω, obs.point 0 - x0 0 < H) ∧
                (method ω).output N (affineTraces ω) 0 - x0 0 < H} ∧
              (∀ ω,
                ((∀ obs ∈ affineTraces ω, obs.point 0 - x0 0 < H) ∧
                  (method ω).output N (affineTraces ω) 0 - x0 0 < H) →
                hardTraces ω = affineTraces ω) ∧
              μ {ω | StrictSuccessThrough (method ω) oracle (hardTraces ω) N} ≤
                ENNReal.ofReal delta

/-- Infinite worst-case expected hitting time over normalized strict instances. -/
noncomputable def InfiniteWorstCaseExpectedHittingTimeStatement : Prop :=
  ∀ (p eps : ℝ), 1 < p → 0 < eps →
    ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
      (method : RandomizedStrictLocalMethod Ω) (x0 : StrictPoint),
      (∀ ω, (method ω).eps = eps ∧ (method ω).x0 = x0) →
      sSup {E : ENNReal |
        ∃ (L R : ℝ) (oracle : PairOracle 1) (xstar : StrictPoint)
          (traces : Ω → ℕ → StrictTranscript),
          StrictNormalizedInstance eps x0 L R oracle xstar ∧
          (∀ ω N, (traces ω N).length = N ∧
            StrictRunConsistent (method ω) oracle (traces ω N)) ∧
          (∀ ω N, traces ω N = (traces ω (N + 1)).take N) ∧
          Measurable (fun ω => strictHittingTime (method ω) oracle (traces ω)) ∧
          E = ∫⁻ ω, strictHittingTime (method ω) oracle (traces ω) ∂μ} = ⊤

/-- One-dimensional `ℓ_p` and `ℓ_q` norms are absolute value for every `p > 1`. -/
noncomputable def OneDimensionalInteriorLpTransferStatement : Prop :=
  ∀ (p : ℝ), 1 < p →
    (∀ x : StrictPoint, lpNorm p x = |x 0|) ∧
    (∀ x : StrictPoint, lpNorm (conjugateExponent p) x = |x 0|)

/-- The exact four-part carrier for the manuscript's scale-identification impossibility theorem. -/
noncomputable def ScaleIdentificationImpossibilityStatement : Prop :=
  DeterministicFiniteHorizonImpossibilityStatement ∧
  RandomizedFiniteHorizonImpossibilityStatement ∧
  InfiniteWorstCaseExpectedHittingTimeStatement ∧
  OneDimensionalInteriorLpTransferStatement

/-- A causal deterministic exact-pair algorithm for the known-parameter model. -/
structure DeterministicExactPairAlgorithm (d : ℕ) where
  nextQuery : Point d → List (Observation d) → Point d
  output : Point d → List (Observation d) → Point d

/-- A trace follows the algorithm's chronological query rule from `x0`. -/
def GeneratedBy (algorithm : DeterministicExactPairAlgorithm d) (x0 : Point d)
    (trace : List (Observation d)) : Prop :=
  ∀ (t : ℕ) (ht : t < trace.length),
    (trace.get ⟨t, ht⟩).point =
      if t = 0 then x0 else algorithm.nextQuery x0 (trace.take t)

/-- A charged exact run begins with `x0` and contains only exact observations. -/
def ChargedKnownParameterRun (algorithm : DeterministicExactPairAlgorithm d)
    (x0 : Point d) (oracle : PairOracle d) (trace : List (Observation d)) : Prop :=
  GeneratedBy algorithm x0 trace ∧ TraceExact oracle trace ∧
  trace ≠ [] ∧ (trace.head?.map O3.Observation.point) = some x0

/-- The current known-parameter upper bound for every fixed finite `p > 2`. -/
noncomputable def KnownParameterAboveTwoUpperStatement : Prop :=
  ∀ (p : ℝ), 2 < p → ∃ Cp : ℝ, 0 < Cp ∧
    ∀ (d : ℕ) (eps L R : ℝ), 0 < eps → 0 < L → 0 < R →
    ∀ x0 : Point d,
      ∃ algorithm : DeterministicExactPairAlgorithm d,
        ∀ inst : PositiveInstance p d x0,
          inst.L = L → inst.R ≤ R →
          ∃ trace : List (Observation d),
            let xhat := algorithm.output x0 trace
            ChargedKnownParameterRun algorithm x0 inst.oracle trace ∧
            WasQueried trace xhat ∧
            lpNorm (conjugateExponent p) (inst.oracle.gradient xhat) ≤ eps ∧
            (trace.length : ℝ) ≤
              Cp * (1 + (L * R / eps) ^ (p / (p + 2)))

/-- The current deterministic exact-pair lower bound with explicit dimension restriction. -/
noncomputable def KnownParameterAboveTwoLowerStatement : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ (p : ℝ), 2 < p → ∀ (d T : ℕ),
    2 ≤ d → 1 ≤ T → T ≤ d → ∀ (L R : ℝ), 0 < L → 0 < R →
    ∀ (x0 : Point d) (algorithm : DeterministicExactPairAlgorithm d),
      ∃ (inst : PositiveInstance p d x0) (trace : List (Observation d)) (Mpd : ℝ),
        inst.L = L ∧ inst.R = R ∧
        ChargedKnownParameterRun algorithm x0 inst.oracle trace ∧
        trace.length = T ∧ 0 < Mpd ∧
        Mpd ≤ (if p ≤ 3 * Real.log d then 5 * p
          else 15 * Real.exp (2 / 3) * Real.log d) ∧
        Mpd ≤ C * min p (Real.log d) ∧
        ∀ t < T, ∃ obs : Observation d,
          (trace.drop t).head? = some obs ∧
          lpNorm (conjugateExponent p) (inst.oracle.gradient obs.point) ≥
            L * R / (512 * Mpd * (T : ℝ) ^ (1 + 2 / p)) ∧
        (∀ eps : ℝ, 0 < eps →
          eps < L * R / (512 * Mpd * (T : ℝ) ^ (1 + 2 / p)) →
          ¬ ∃ t < T, ∃ obs : Observation d,
            (trace.drop t).head? = some obs ∧
            lpNorm (conjugateExponent p) (inst.oracle.gradient obs.point) ≤ eps) ∧
        (∀ eps : ℝ, 0 < eps →
          (T : ℝ) <
            (L * R / (512 * C * eps * min p (Real.log d))) ^
              (p / (p + 2)) →
          ¬ ∃ t < T, ∃ obs : Observation d,
            (trace.drop t).head? = some obs ∧
            lpNorm (conjugateExponent p) (inst.oracle.gradient obs.point) ≤ eps) ∧
        (p ≤ 3 * Real.log d → ∀ eps : ℝ, 0 < eps →
          (T : ℝ) < (L * R / (2560 * p * eps)) ^ (p / (p + 2)) →
          ¬ ∃ t < T, ∃ obs : Observation d,
            (trace.drop t).head? = some obs ∧
            lpNorm (conjugateExponent p) (inst.oracle.gradient obs.point) ≤ eps)

/-- The upper/lower conjunction for known-parameter optimality when `p > 2`. -/
noncomputable def KnownParameterAboveTwoOptimalityStatement : Prop :=
  KnownParameterAboveTwoUpperStatement ∧ KnownParameterAboveTwoLowerStatement

/-- The three-regime post-initialization oracle-count expression. -/
noncomputable def CurrentMainRate (p Cp C Kbar L M0 : ℝ) : ℝ :=
  if p < 2 then
    Cp * Kbar ^ (1 / 2 : ℝ) + Cp * Real.log (Real.exp 1 + L / M0)
  else if p = 2 then
    C * Kbar ^ (1 / 2 : ℝ) + C * Real.log (Real.exp 1 + L / M0)
  else
    Cp * Kbar ^ (p / (p + 2)) + Cp * Real.log (Real.exp 1 + L / M0)

/-- The current parameter-free runtime theorem carrier for all finite `p > 1`. -/
noncomputable def MainStatement : Prop :=
  ∃ family : RuntimeMethodFamily,
    ∃ C : ℝ, 0 < C ∧
      ∀ (p : ℝ), 1 < p →
        ∃ Cp : ℝ, 0 < Cp ∧
          ∀ (d : ℕ) (input : MethodInput d),
            input.p = p → 0 < input.eps → 0 < input.M0 →
            ∀ inst : PositiveInstance p d input.x0,
              SecantInitialization input inst.oracle →
              input.M0 ≤ inst.L →
              ∃ run : PairRunResult d,
                let Kbar := conditionBar inst input.eps
                Executes (family d) input inst.oracle run ∧
                TraceExact inst.oracle run.trace ∧
                run.trace ≠ [] ∧
                run.trace.head?.map O3.Observation.point = some input.x0 ∧
                run.returnedWasQueried ∧
                lpNorm (conjugateExponent p) (inst.oracle.gradient run.returned) ≤ input.eps ∧
                (run.postInitializationCallCount : ℝ) ≤
                  CurrentMainRate p Cp C Kbar inst.L input.M0

/-- Scale cannot be identified in the strict local exact-pair model at fixed `LR/eps`. -/
theorem scaleIdentificationImpossibility : ScaleIdentificationImpossibilityStatement := by
  sorry

/-- The known-parameter `p > 2` upper/lower pair has exponent `p/(p+2)`. -/
theorem knownParameterAboveTwoOptimality : KnownParameterAboveTwoOptimalityStatement := by
  sorry

/-- One runtime method family attains the current three-regime parameter-free rates. -/
theorem main : MainStatement := by
  sorry

end V7
