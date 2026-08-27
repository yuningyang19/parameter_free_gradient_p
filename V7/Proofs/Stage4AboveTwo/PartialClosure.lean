import V7.Proofs.Stage4AboveTwo.PrimalResidual

/-!
Kernel-checked Stage-4 prefix retained by the narrow-repair run.

This is deliberately not named `Closure`: the terminal primal-energy bridge,
dual terminal energy, and causal `aboveTrial` remain outside the checked prefix.
-/

#check V7.aboveGeometry
#check V7.aboveWeightErrorBalance
#check V7.abovePointwiseResidualIdentity
#check V7.Stage4AboveTwo.scalar_power_deficit_le
#check V7.Stage4AboveTwo.mixedVectorResidual_lower
#check V7.Stage4AboveTwo.aboveMixedResidual_lower
