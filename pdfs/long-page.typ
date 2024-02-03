// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(title: "", authors: (), logo: none, tag:[], body) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(width: 595.28pt, height: auto, margin: (x: 40pt, y: auto))
  // set text(font: "Linux Libertine", lang: "en")
  
  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  v(0.6fr)
  if logo != none {
    align(right, image(logo, width: 26%))
  }
  v(9.6fr)

  text(2em, weight: 700, title)

  // Author information.
  v(595.28pt)
  pad(
    top: 0.7em,
    right: 20%,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start, strong(author))),
    ),
  )
  tag
  pagebreak()


  // Main body.
  set par(justify: true)
  set text(hyphenate: false)
  show: columns.with(1, gutter: 1.3em)

  body
}
