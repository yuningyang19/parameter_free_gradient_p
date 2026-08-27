import V7.ControllerStatements
import O3.Stage3AnchorNorming

namespace V7

theorem normingDirection_eq_anchorNormingVector (q : ℝ) (g : Point d) :
    normingDirection q g = O3.anchorNormingVector q g := rfl

theorem normingDirection_correct : NormingDirectionStatement := by
  intro p hp d g hg
  have hg0 : g ≠ 0 := by
    intro hzero
    subst g
    have hq0 : 0 < conjugateExponent p :=
      lt_trans zero_lt_one (O3.one_lt_conjugateExponent hp)
    simpa [O3.lpNorm_zero hq0] using hg
  rw [normingDirection_eq_anchorNormingVector]
  exact ⟨O3.Stage3Anchor.anchorNormingVector_lpNorm hp g hg0,
    O3.Stage3Anchor.pairing_anchorNormingVector hp g hg0⟩

end V7
