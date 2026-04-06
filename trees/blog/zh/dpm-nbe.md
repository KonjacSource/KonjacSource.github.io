---
title: 一种在 NbE 中实现依赖模式匹配的方法
date: Apr. 6. 2026
---

我在本科最后一年做过一个玩具项目，叫 [ShiTT](https://github.com/KonjacSource/ShiTT2)（半年前我把它完全重写了一遍）。它是一个 Agda 风格的依赖类型检查器，基于 Andras Kovacs 的 [elaboration-zoo](https://github.com/AndrasKovacs/elaboration-zoo)，并支持依赖模式匹配（Dependent Pattern Matching, DPM）。我觉得有必要写一篇文章，分享一些自己想到的有趣思路。

其中一个最有挑战的问题是：如何在 NbE（Normalization by Evaluation）语境下实现 DPM。众所周知，当我们用 `refl` 去匹配类型 $Id(u, v)$ 时，需要对项 $u$ 和 $v$ 做 unification。这个过程本质上是在构造一个替换，并把它应用到分支体上。但在 NbE 的实现里，通常并没有一个简单直接的替换机制。

## 一个朴素方案

以 [elaboration-zoo/02-typecheck-closures-debruijn](https://github.com/AndrasKovacs/elaboration-zoo/tree/master/02-typecheck-closures-debruijn) 为例，它有一个求值环境，里面保存了所有变量的值。一个直觉做法是：通过修改求值环境中被 unification 变量的值来实现 DPM。比如：

$$
\begin{aligned}
&f : (x : \mathbb{N}) \to Id\ x\ 0 \to ... \\
&f\ x\ * = ?_1
\end{aligned}
$$

如果占位符 $*$ 是变量模式 $h$，那么 $?_1$ 的类型检查上下文应为：

$$
x : \mathbb{N},\ h : Id\ x\ 0
$$

对应的求值环境应为：

$$
\mathbf{Env} = x \mapsto x,\ h \mapsto h
$$

如果 $*$ 是构造子模式 `refl`，那么求值环境应为：

$$
\mathbf{Env} = x \mapsto 0
$$

这样一来，右侧表达式里所有出现的 $x$ 都会直接求值成 $0$。但这个办法有个问题：这种 unification 会破坏求值环境的 well-formedness。

求值环境存储的是所有变量的值，而 $\mathbf{Value}$ 类型可以看成是范式（normal form）的表示。我们把 $x$ 的值从“变量”改成了“其他值”，这可能会让依赖于 $x$ 的其他变量变得 ill-formed。比如环境里有 $y \mapsto x + 1$，当我们把 $x$ 改成 $0$ 后，$y$ 就变成 $0 + 1$，这不是范式。继续下去，依赖于 $y$ 的值也会被连锁污染。

## 一个更好的方案

一种变通方式是：每次需要做 unification 时，都把环境整体更新一遍。

假设我们有一个 well-formed 环境 $E$，其中 $(x \mapsto x) \in E$。现在有一个 unification 赋值 $x = v$（$v$ 是一个值）。上面已经说明，直接在 $E$ 里把 $x$ 替成 $v$ 会失败。于是我们引入新操作 $\mathbf{updateVal}$：

$$
\begin{aligned}
&\mathbf{updateVal} : \mathbf{Env}^! \to \mathbf{Value} \to \mathbf{Value} \\
&\mathbf{updateVal}\ env\ v = \mathbf{eval}\ env\ v\ (\mathbf{quote}\ (\mathbf{length}\ env\ v)\ v)
\end{aligned}
$$

这里的 $\mathbf{Env}^!$ 表示环境不一定 well-formed。也许有更聪明的 $\mathbf{updateVal}$ 实现方式，不需要先 quote 再 eval，但先用这个定义就够了。

可以把 $\mathbf{updateVal}$ 理解成 $\mathbf{Value}$ 上的替换操作。例如：

$$
\mathbf{updateVal}\ (E[x \mapsto v])\ t = t[v/x]
$$

其中 $E[x \mapsto v]$ 是把 $v$ 在环境 $E$ 中朴素替换给 $x$ 得到的结果（正如前面所说，这个结果通常是 ill-formed 的）。

接下来定义 $\mathbf{updateEnv}$：

$$
\begin{aligned}
&\mathbf{updateEnv} : \mathbf{Env}^! \to \mathbf{Env} \\
&\mathbf{updateEnv}\ env\ v = \mathbf{map}\ (\mathbf{updateVal}\ (\mathbf{length}\ env\ v))\ env\ v
\end{aligned}
$$

也就是把 $\mathbf{updateVal}(E[x \mapsto v])$ 映射到 $E[x \mapsto v]$ 的每个值上。于是我们得到：

$$
E' := \mathbf{updateEnv}(E[x \mapsto v])
$$

那么 $E'$ 是否 well-formed？是不是我们想要的环境？答案是肯定的。

我们可以用一个“层级参数”来定义环境的 ill-formed 程度。给定环境 $E$ 下的值 $v$：

- 如果 $v$ 中任意自由变量 $x$ 都满足 $eval\ E\ x = x$，就说 $v$ 是 well-formed 的，或称它是 $0$-ill-formed。
- 如果 $v$ 中存在自由变量 $x$，使得 $eval\ E\ x = v'$ 且 $v'$ 是 $n$-ill-formed，就说 $v$ 是 $(n+1)$-ill-formed。
- 若一个环境含有某个 $n$-ill-formed 的值，就说这个环境是 $n$-ill-formed。

例如：

$$
\begin{aligned}
&\text{well-formed: }\quad x \mapsto x,\ y \mapsto x + 1 \\
&\text{1-ill-formed: }\quad x \mapsto 0,\ y \mapsto x + 1 \\
&\text{2-ill-formed: }\quad x \mapsto 0,\ y \mapsto x + 1,\ z \mapsto y + 1
\end{aligned}
$$

可以证明：如果 $E$ 是 $(n+1)$-ill-formed，那么 $\mathbf{updateEnv}\ E$ 是 $n$-ill-formed。

当 $E$ 是 well-formed 的、且 $\mathbf{eval}\ E\ x = x$，并且 $E$ 中有其他变量依赖 $x$ 时，很容易看出 $E[x \mapsto v]$ 是 1-ill-formed；再对它应用 $\mathbf{updateEnv}$ 就能恢复为 well-formed 环境。

把 $\mathbf{updateEnv}$ 的类型改写得更直观一些：

$$
\mathbf{updateEnv} : \mathbf{Env}^{!(n+1)} \to \mathbf{Env}^{!n}
$$

其中 $!n$ 表示 ill-formed 层级。

另外，不要忘了：更新环境之后，也要同步更新类型检查上下文中的所有类型。

## 限制依赖模式匹配

这个方法有效，但有性能代价。每次 unification 都要重新求值整个环境，开销比较大。一个方案是限制上下文长度。比如下面这段 Agda：

```agda
module M (x : Nat) where

  f : Id x 0 -> ...
  f refl = ...
```

函数 `f` 可以对外层模块变量 $x$ 做 unification。在 ShiTT 中，我们可以限制依赖模式匹配的能力，只允许对“当前函数中新引入”的变量做 unification（我还没实现）。于是可改写为：

```agda
module M (x : Nat) where

  f' : (x : Nat) -> Id x 0 -> ...
  f' x refl = ...

  f = f' x
```

对于支持 `match` 表达式的语言，这个限制还有一个额外理由 [LightQuantum]("https://yanningchen.me") 告诉我的。

先看如下数据类型：

```agda
data T : Set -> Set where
  C : T Bool
```

再看一个包含 `match` 的函数：

```agda
f : (A : Set) -> T A -> A
f A = λ t -> match t with
            | C => true -- 此处可推出 A = Bool
```

于是我们可以定义：

```agda
g1, g2 : T Nat -> Nat
g1 = f Nat

g2 = λ t -> match t with
           | C => true
```

`g1` 是良类型的，而 `g2` 不是；但又能观察到：

$$
g2 = f\ A\ [Nat/A] = g1
$$

也就是说，替换并不保持类型！

解决方式和前面一致：限制依赖模式匹配，要求所有参与 unification 的变量都必须出现在 `match` 表达式中。

于是上面的代码应改写为：

```agda
f A = λ t -> match A , t with
            | .Bool , C => true
```

这样之后，`g2 ≠ f A [Nat / A]`，并且它按预期不再是良类型。

虽然 Agda 没有原生 `match` 表达式支持，[但有会导致同类问题的 lambda-case 表达式](https://github.com/agda/agda/issues/8192)。不过他们似乎把 lambda-case 当作顶层模式匹配的语法糖处理，因此在 Agda 的表达式层面，替换依然是保类型的（因为 Agda 表达式里并没有模式匹配）。

基于这两点，我认为对依赖模式匹配做一定能力限制是个不错的主意。

## 参考资料

- [小小的老子🫡. ShiTT](https://github.com/KonjacSource/ShiTT2)
- [Andras Kovacs. elaboration-zoo](https://github.com/AndrasKovacs/elaboration-zoo)
- [Ulf Norell. Towards a practical programming language based on dependent type theory](https://www.cse.chalmers.se/~ulfn/papers/thesis.pdf)
- [Jesper Cockx and Andreas Abel. Elaborating Dependent (Co)pattern Matching](https://jesper.sikanda.be/files/elaborating-dependent-copattern-matching.pdf)
