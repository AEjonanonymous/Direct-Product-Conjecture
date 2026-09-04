# Finite-Sum Inequality Chain for Modular Reduction

This repository contains a Lean 4 formalization of an arithmetic inequality derivation, mechanically verifying the lower bound reduction for multi-instance communication complexity.

## Overview (`Solution.lean`)

The formalization structurally connects coordinate decomposition bounds, drift sums, and single-instance parameter substitutions through the Lean 4 kernel using `linarith` and `Finset` summations. 

* **Step 1 & 2 (`step1_and_2_measure_expansion`)**: Binds communication value and joint information cost against the sum of coordinate components.
* **Step 3 (`step3_drift_bound`)**: Controls cross-coordinate conditioning drift and parameter differences across information slices.
* **Step 4 (`step4_single_instance_substitution`)**: Substitutes single-instance information cost bounds across the $k$-fold coordinate sum.
* **Main Theorem (`direct_product_lower_bound`)**: Establishes the direct product lower bound inequality mapping $CC_\epsilon \ge k \cdot R_\delta - o(k)$.

## Verification Target

The project is structured for mechanical verification under Lean 4 and Mathlib, validating the order-theoretic inequality chain.
