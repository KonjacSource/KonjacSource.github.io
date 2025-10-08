#import "@preview/zh-kit:0.1.0": *

#let start(
  body,
) = {
  // Set the document's basic properties.
  set page(width: 60em, height: auto, margin: (x: 0.1em, y: 0em), fill: rgb(0, 0, 0, 0)); 
  set text(size: 26pt, top-edge: "bounds", bottom-edge: "bounds");
  show: doc => setup-base-fonts(
    doc,
    cjk-serif-family: ("霞鹜文楷 SC", "宋体"), // 优先使用霞鹜文楷 SC
    first-line-indent: 2em, // 设置首行缩进为2个字符宽度
  )

  body
}