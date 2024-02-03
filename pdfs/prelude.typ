#import "@preview/physica:0.7.5": *

#let otimes = [$ times.circle $]
#let oplus = [$ plus.circle $]
#let Otimes = [$ times.big.circle $]
#let Oplus = [$ plus.big.circle $]
#let umin = $union.minus$

#let Hilbert = [$ cal(H) $]

#let title(level) = str => text(size: 12pt + level, weight: "bold", str)
#let section = title(8pt)
#let subsection = title(4pt)


#let inf = [$infinity$]

#let kaiti(content) = text(font: ("Times New Roman","KaiTi"))[#content]

#let al = [$angle.l$]
#let ar = [$angle.r$]

#let prod = [$product$]

#let DP(x) = [$prod_#x$]
#let DS(x) = [$sum_#x$]

#let inner(v,w) = [$al #v, #w ar$] 

#let textmap(c) = $display(op(arrow.r.long, limits: #true)_(#text(7pt,c)))$
#let lmap = $display(op(arrow.r.long, limits: #true)_(#text(7pt)[linear]))$

#let Tensor = $cal(T)$

#let eps = $epsilon$

#let cdots = $dots.c$

#let cmt(s, bef:$because$) = $underline(overline(#bef #s))$

#let where = $"其中,"$

#let todo = text(fill: red)[!TODO!]

#let nosum(x) = $cancel(sum_(#x))$

#let easy = "易证, 略之."

#let trivial = "显然."

#let comp = $circle.tiny$

#let sub = $subset.eq$

#let cdot = $dot.c$



#let dbar = $đ$

#let ed(a:[a],d:[d]) = $#d _#a$

#let cF = $cal(F)$

#let up(a) = $""^#a$
#let down(a) = $""_#a$

#let inte = $integral$
#let iinte = $integral.double$
#let iiinte = $integral.triple$
#let ointe = $integral.cont$
#let oiinte = $integral.surf$

#let lhs = "LHS"
#let rhs = "RHS"

#let arr(s) = textmap(s)

#let dal = $ballot$

#let dd4(a) = $dd(up(4) #a)$
#let dd3(a) = $dd(up(3) #a)$

#let Lag = $cal(L)$
