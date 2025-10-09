#import "/trees/typst/shared.typ" : *
#import "/trees/typst/prelude.typ" : *

#show: start

*Excercise 2.3* 证明 $(gamma . a) compose delta = (gamma compose delta) . a[delta]$

此命题描述了如何将替换 $delta$ 作用在另一个替换 $gamma$ 上, 即逐项替换.

对 $(gamma . a) compose delta$ 使用 $eta$-rule, 我们得到 

$
  (gamma . a) compose delta = (weaken compose (gamma . a) compose delta) . this[gamma . a] [delta] = (gamma compose delta) . a[delta]

$
