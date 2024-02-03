#import "long-page.typ": *
#import "@preview/physica:0.7.5": *
#import "@preview/lemmify:0.1.4": *
#import "prelude.typ": *



#let authors = "KonjacSource"
#let title = "谈一下(数学)归纳法"
#let pagebr = pagebreak

#set document(author: authors, title: title)
#set page(width: 595.28pt, height: auto, margin: (x: 40pt, y: auto))
#v(9.6pt)
#text(2em, weight: 700, title)\

#authors
#pagebreak()

#set text(
    font:("Times New Roman", "Noto Serif CJK SC"),
    style:"normal",
    weight:"regular",
    size: 10pt,
    lang: "zh"
)

#set math.equation(numbering: "(1)")

#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() ==  eq {
    // Override equation references.
    numbering(
      el.numbering,
      ..counter(eq).at(el.location())
    )
  } else {
    // Other references as usual.
    it
  }
}

#let (define, rules) = new-theorems("thm-group", ("define": [定义]))
#show: rules
#let (axiom, rules) = new-theorems("thm-group", ("axiom": [公理]))
#show: rules
#let (theorem, rules) = new-theorems("thm-group", ("theorem": [定理]))
#show: rules
#let (remark, rules) = new-theorems("thm-group", ("remark": text(font:("Times New Roman", "Noto Serif CJK SC"),size: 10pt)[注]))
#show: rules
#let (lemma, rules) = new-theorems("thm-group", ("lemma": [引理]))
#show: rules
#let (corollary, rules) = new-theorems("thm-group", ("corollary": [推论]))
#show: rules
#let (proposition, rules) = new-theorems("thm-group", ("proposition": [命题]))
#show: rules
#let (example, rules) = new-theorems("thm-group", ("example": [例]))
#show: rules
#let (proof, rules) = new-theorems("thm-group", ("proof": [证明]))
#show: rules
#let (assume, rules) = new-theorems("thm-group", ("assume": [假设]))
#show: rules

#show thm-selector("thm-group", subgroup: "proof"): it => box(
  [#it #align(right, text(10pt)[$square.stroked.big$]) ] ,
  inset: 1em
)
#show thm-selector("thm-group", subgroup: "theorem"): it => box(
  it,
  stroke: rgb(160,224,255) + 3pt,
  inset: 1em,
  fill: rgb(244,252,255)
)
#show thm-selector("thm-group", subgroup: "define"): it => box(
  it,
  stroke: rgb(255,216,128) + 3pt,
  inset: 1em,
  fill: rgb(255,253,240)
)
#show thm-selector("thm-group", subgroup: "remark"): it => box(
  text(font: ("Times New Roman","KaiTi"), size: 11pt)[#it],
  stroke: rgb(160,224,160) + 3pt,
  inset: 1em,
  fill: rgb(242,250,242)
)
#show thm-selector("thm-group", subgroup: "proposition"): it => box(
  it,
  stroke: color.mix(purple, white) + 3pt,
  inset: 1em,
  fill: rgb(253,248,254)
)
#show thm-selector("thm-group", subgroup: "lemma"): it => box(
  it,
  stroke: rgb(160,224,255) + 3pt,
  inset: 1em,
  fill: rgb(244,252,255)
)
#show thm-selector("thm-group", subgroup: "axiom"): it => box(
  it,
  stroke: color.mix(purple, white) + 3pt,
  inset: 1em,
  fill: rgb(253,248,254)
)
#show thm-selector("thm-group", subgroup: "assume"): it => box(
  it,
  stroke: color.mix(purple, white) + 3pt,
  inset: 1em,
  fill: rgb(253,248,254)
)
#set heading(numbering: "1.A")

#let herm = textmap("Hermitian") 

// #theorem(name: "Some theorem")[
//   Theorem content goes here.
// ]<thm-label>

// #proof[
//   Complica proof. 
// ]<proof-label>
// ***************************************************************************** //

#let (solve, rules) = new-theorems("thm-group", ("solve": [解]))
#show: rules

