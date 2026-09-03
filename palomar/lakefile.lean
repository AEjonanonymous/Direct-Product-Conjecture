import Lake
open Lake DSL

package «DirectProductConjecture» where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «Challenge» where
  srcDir := "."

lean_lib «Solution» where
  srcDir := "."
