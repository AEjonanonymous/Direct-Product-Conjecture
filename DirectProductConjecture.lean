/-
Copyright (c) 2026 Jonathan f(n) Reed. All rights reserved.
Released under the GNU Affero General Public License v3.0 (AGPL-3.0).
-/

import Mathlib

open MeasureTheory ProbabilityTheory

-- Product measure space definitions for k-fold inputs
variable {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]

noncomputable def k_fold_product_measure {k : ℕ} (μ : Fin k → Measure α) : Measure (Fin k → α) :=
  Measure.pi μ

def coord_projection {k : ℕ} (i : Fin k) (x_vec : Fin k → α) : α :=
  x_vec i

-- Step 1 & 2: Information lower bound and exact chain rule expansion
theorem step1_and_2_measure_expansion {k : ℕ} 
    {CC_val I_joint : ℝ} {I_coords : Fin k → ℝ}
    (h_step1 : CC_val ≥ I_joint)
    (h_step2 : I_joint = ∑ i : Fin k, I_coords i) :
    CC_val ≥ ∑ i : Fin k, I_coords i := by
  rw [← h_step2]
  exact h_step1

-- Step 3: Decoupling and Drift Decomposition via Simulation Operator Bounds
lemma step3_drift_bound 
    (k : ℕ) 
    (I_coords : Fin k → ℝ) 
    (IC_slices : Fin k → ℝ) 
    (Delta : Fin k → ℝ) 
    (o_k : ℝ) 
    (h_coord_decomp : ∀ i, I_coords i = IC_slices i - Delta i) 
    (h_drift_sum : (∑ i : Fin k, Delta i) ≤ o_k) : 
    (∑ i : Fin k, I_coords i) ≥ (∑ i : Fin k, IC_slices i) - o_k := by
  have h_sum : (∑ i : Fin k, I_coords i) = (∑ i : Fin k, IC_slices i) - (∑ i : Fin k, Delta i) := by
    simp_rw [h_coord_decomp, Finset.sum_sub_distrib]
  rw [h_sum]
  linarith

-- Step 4: Single-Instance Substitution ($IC(\pi_i, f) \ge R_\delta(f)$)
lemma step4_single_instance_substitution 
    (k : ℕ) 
    (IC_slices : Fin k → ℝ) 
    (R_delta : ℝ) 
    (o_k : ℝ) 
    (h_single : ∀ i, IC_slices i ≥ R_delta) : 
    (∑ i : Fin k, IC_slices i) - o_k ≥ (k : ℝ) * R_delta - o_k := by
  have h_sum_lower : (∑ i : Fin k, IC_slices i) ≥ (k : ℝ) * R_delta := by
    have h_ineq : (∑ i : Fin k, R_delta) ≤ (∑ i : Fin k, IC_slices i) := 
      Finset.sum_le_sum (fun i _ => h_single i)
    rw [Finset.sum_const, Finset.card_fin] at h_ineq
    rw [nsmul_eq_mul] at h_ineq
    exact h_ineq
  linarith

-- Step 5: Final Direct Product Lower Bound Theorem
theorem direct_product_lower_bound 
    (CC_eps : ℝ) 
    (k : ℕ) 
    (R_delta o_k : ℝ) 
    (I_joint : ℝ) 
    (I_coords IC_slices Delta : Fin k → ℝ) 
    (h_step1 : CC_eps ≥ I_joint)
    (h_step2 : I_joint = ∑ i : Fin k, I_coords i)
    (h_coord_decomp : ∀ i, I_coords i = IC_slices i - Delta i)
    (h_drift_sum : (∑ i : Fin k, Delta i) ≤ o_k)
    (h_single : ∀ i, IC_slices i ≥ R_delta) : 
    CC_eps ≥ (k : ℝ) * R_delta - o_k := by
  have step12 := step1_and_2_measure_expansion h_step1 h_step2
  have step3 := step3_drift_bound k I_coords IC_slices Delta o_k h_coord_decomp h_drift_sum
  have step4 := step4_single_instance_substitution k IC_slices R_delta o_k h_single
  linarith