#import "/typst/shared.typ" : *
#import "/typst/prelude.typ" : *

#show: start

考虑一个语境中的项, $Gamma tack a : A$, 可将其看作一个函数 $tack a' : (gamma : Gamma) -> A'[gamma]$, 注意 $Gamma tack A bold("type")$, 我们也可以将 $A$ 看作 $tack A' : Gamma -> bold("type")$, 而一个替换 $Delta tack gamma : Gamma$ 可以看作语境 $Delta$ 下的一列实参, 类型恰好满足 telescope $Gamma$, 于是我们将执行替换看作函数应用, 即 $Delta tack a' [gamma] : A[gamma]$. 因此替换后的语境自动继承了 $gamma$ 的语境.

$id_Delta$ 即是语境 $Delta$ 中所有变量的指代, 例 $id_(a : A, b : B) = a.b$