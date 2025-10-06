#import "/trees/typst/prelude.typ" : *
*Excercise 2.4* 给定 $Δ ⊢ 𝛾 : Γ$ 和 $Γ ⊢ A "type"$, 构造一个替换记作 $𝛾.A$, 满足 $Δ.A[𝛾] ⊢ 𝛾.A : Γ.A$. 

解.
观察 $gamma . A$ 的语境和类型 $Δ.A[𝛾] ⊢ 𝛾.A : Γ.A$, 注意到这相当于在一个更深的语境中添加一个新的, 类型为 $A$ 的项, 该项从哪来? 自然是更深语境中的 $A[gamma]$, 所以我们这样考虑, 首先我们有 weakening,

$
  Delta. A[gamma] tack weaken : Delta
$

通过复合 weakening, 我们可以 weaken 一个替换,
  
$
  Delta. A[gamma] tack gamma compose weaken : Gamma
$

在 $Delta. A[gamma]$ 下, 我们通过添加 $Delta, A[gamma] tack this : A[gamma compose weaken]$ 到这个替换的末尾, 来获得最终的代换,

$
  Delta. A[gamma] tack (gamma compose weaken) . this : Gamma. A
$

