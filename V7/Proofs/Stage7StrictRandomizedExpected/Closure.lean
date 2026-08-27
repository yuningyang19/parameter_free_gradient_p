import V7.Proofs.Stage7StrictRandomizedExpected.Transfer

namespace V7

/-- The exact frozen four-part scale-identification impossibility carrier. -/
theorem scaleIdentificationImpossibility :
    ScaleIdentificationImpossibilityStatement := by
  exact ⟨deterministicFiniteHorizonImpossibility,
    randomizedFiniteHorizonImpossibility,
    infiniteWorstCaseExpectedHittingTime,
    oneDimensionalInteriorLpTransfer⟩

#check randomizedFiniteHorizonImpossibility
#check infiniteWorstCaseExpectedHittingTime
#check oneDimensionalInteriorLpTransfer
#check scaleIdentificationImpossibility

end V7
