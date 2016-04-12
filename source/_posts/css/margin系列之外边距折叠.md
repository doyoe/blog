title: margin系列之外边距折叠
date: 2013-12-04 11:15:00
categories: CSS
author: 杜瑶
tags: [margin, w3c, margin折叠]
---

## 不怀疑你也在工作中遇见过

几乎可以不用怀疑，前端工作中的你一定遇见过 `margin` 折叠。

不确定？别着急，你可能写过这样的代码：

### CSS:

```css
p{
	margin: 50px;
}
```

### HTML:

```html
<div id="demo">
	<p>我是一个华丽的段落，别看我文字少</p>
	<p>我是另一个华丽的段落</p>
</div>
```

大家觉得这 `2p` 之间会发生点什么？是会合体呢？还是分开？来看看 `DEMO1` [margin折叠](http://demo.doyoe.com/css/margin/collapse-margin.htm)

<!--more-->

好吧，它们真的合体了。按照常规思路，这 `2p` 之间的空白应该是第一个 `p` 的 `margin-bottom` 50px 加上第二 `p` 的 `margin-top` 50px，即 `50 + 50px = 100px` ，但结果总是出乎意料不是么？它们之间只剩下了 `50px`，这就是 `margin折叠`。所以任何人遇见过我都不会觉得意外，因为这样的Code看起来没有任何问题。

## 它们之间到底发生了些什么？

这 `2p` 内部到底发生了什么，才会有这样的表现？

早在CSS1中就有对 `margin` 折叠的说明，我们来看看：

> 原文：The width of the margin on non-floating block-level elements specifies the minimum distance to the edges of surrounding boxes. Two or more adjoining vertical margins (i.e., with no border, padding or content between them) are collapsed to use the maximum of the margin values. In most cases, after collapsing the vertical margins the result is visually more pleasing and closer to what the designer expects.

> 翻译：外边距用来指定非浮动元素与其周围盒子边缘的最小距离。两个或两个以上的相邻的垂直外边距会被折叠并使用它们之间最大的那个外边距值。多数情况下，折叠垂直外边距可以在视觉上显得更美观，也更贴近设计师的预期。

从这段话中，我们能获得一些有用的信息：

* 发生折叠需要是相邻的非浮动元素；
* 折叠发生在垂直外边距上，即margin-top/margin-bottom；
* 折叠后取其中最大的那个margin值作为最终值；

所以 `DEMO1` 中的 `2p` 符合折叠的条件，相邻且都不是浮动元素，于是它们就自然合体了。至于取最大的那个值作为折叠后的最终值，因为都是50px，所以无所谓谁谁谁了。

## 为什么会有margin折叠这样的设计？

从上文中，应该能知道个大概？在前面的文章中，我们说过，CSS的基本模型是排版。只是前端工程师现在做得更多的是 `布局` 而非 `文字排版`，但CSS并未界定这两者的区别。而 `margin` 折叠是为实现文本排版的段落间距而提供的特性。所以很多时候 `margin` 折叠的特性会带给我们诸多疑惑。

再回到 `DEMO1` 仔细看看，你会惊讶的发现，其实你只要设置每个 `p` 有相同的垂直外边距，由于发生会 `margin` 折叠，所有的 `p` 之间，及包含块与 `p` 之间的间隙都是相同的，非常美妙且实现简单，不是么？这正印证了我们引用 `CSS1` 中的那短话：多数情况下，折叠垂直外边距可以在视觉上显得更美观，也更贴近设计师的预期。

## 浮动元素真的不会发生margin折叠吗？

质疑精神一直都是进步最重要的驱动力之一，我们为什么不能呢？改下代码看看：

### CSS:

```css
p{
	float: left;
	margin: 50px;
}
```

只改CSS代码，HTML不变。迫不及待的想看到验证情况，来吧，还等什么。`DEMO2` [验证浮动元素是否会发生margin折叠](http://demo.doyoe.com/css/margin/float-collapse-margin.htm)。

结果告诉我们，真的没有折叠，`2p` 间的间隙足足有 `100px`。

剩下的2点大家就自行验证吧，相信你能得到满意的额测试结果。

## 仅此而已？

回想一下我们在 [margin系列之百分比](http://blog.doyoe.com/2013/11/30/css/margin系列之百分比/) 文中提到过受书写模式影响的一些特性，非常不幸，`margin` 折叠正好是其中之一。

是的，在CSS2及后续的规范中，将`margin` 折叠描述得更为详尽了。

在水平书写模式下，发生 `margin` 折叠的是垂直方向，即 `margin-top/margin-bottom`，在垂直书写模式下，`margin` 折叠发生在水平方向上，即 `margin-right/margin-left`。

## 现在我们来解释一下到底什么是margin折叠？

在CSS中，两个或以上的块元素（可能是兄弟，也可能不是）之间的相邻外边距可以被合并成一个单独的外边距。通过此方式合并的外边距被称为折叠，且产生的已合并的外边距被称为折叠外边距。

处于同一个块级上下文中的块元素，没有行框、没有间隙、没有内边距和边框隔开它们，这样的元素垂直边缘毗邻，则称之为相邻。

### 什么是垂直边缘毗邻？

* 元素的上外边距和其属于常规流中的第一个孩子的上外边距。
* 元素的下外边距和其属于常规流中的下一个兄弟的上外边距。
* 属于常规流中的最后一个孩子的下外边距和其父亲的下外边距，如果其父亲的高度计算值为 `auto`。
* 元素的上、下外边距，如果该元素没有建立新的块级格式上下文，且 `min-height` 的计算值为零、` height ` 的计算值为零或 `auto`、且没有属于常规流中的孩子。

说得很清楚了，我想是的。你可能需要注意的是发生 `margin` 折叠的元素不一定是兄弟关系，也能是父子或祖先的关系。

## 如何避免margin折叠？

我想肯定有人要问，那我不想有 `margin` 折叠的情况发生，该怎么办？其实从上面的规则中，我们已经可以抽出避免 `margin` 折叠的条件来。

* `margin` 折叠元素只发生在块元素上；
* 浮动元素不与其他元素 `margin` 折叠；
* 定义了属性overflow且值不为visible（即创建了新的块级格式化上下文）的块元素，不与它的子元素发生`margin` 折叠；
* 绝对定位元素的 `margin` 不与任何 `margin` 发生折叠。
* 特殊：根元素的 `margin` 不与其它任何 `margin` 发生折叠；
* 如果常规流中的一个块元素没有 `border-top`、`padding-top`，且其第一个浮动的块级子元素没有间隙，则该元素的上外边距会与其常规流中的第一个块级子元素的上外边距折叠。
  可能有些绕，我们验证一下 [`DEMO3`](http://demo.doyoe.com/css/margin/collapse-margin-verify.htm)，在其第一个浮动子元素加个全角空格做间隙，来个反证 [`DEMO4`](http://demo.doyoe.com/css/margin/collapse-margin-re-verify.htm)
* 如果一个元素的 `min-height` 属性为0，且没有上或下边框以及上或下内边距，且 `height` 为0或者 `auto`，且不包含行框，且其属于常规流的所有孩子的外边距都折叠了，则折叠其外边距。验证一下 [`DEMO5`](http://demo.doyoe.com/css/margin/collapse-margin-verify-2.htm)

## 这样干掉margin折叠

如果不想发生 `margin` 折叠，那么你可以根据上面的规则得到方法，不是么？我把它改成非块元素，让它浮动，让它绝对定位，让它 `overflow:hidden` [`DEMO6`](http://demo.doyoe.com/css/margin/destroy-collapse-margin-by-overflow.htm)，用边框隔开它们 [`DEMO7`](http://demo.doyoe.com/css/margin/destroy-collapse-margin-by-border.htm)...随你怎样，信手拈来。

今天状态不太好，有些地方写得欠妥，之后可能会修改一下。

BTW: 这篇文章里可能有不少之前文章中没出现过的名词，比如：块级上下文、行框、常规流，如果你对此不甚了解，可以先找资料看看，我以后会讲到。

enjoy it.


## 可参考：

* http://www.w3.org/TR/css3-box/#margins
* http://www.w3.org/TR/css3-box/#collapsing-margins
* http://dev.w3.org/csswg/css-box/#collapsing-margins
* http://www.w3.org/TR/CSS1/#vertical-formatting

## margin系列文章：

* [margin系列之布局篇](/2013/12/31/css/margin系列之布局篇/)
* [margin系列之bug巡演（三）](/2013/12/20/css/margin系列之bug巡演（三）/)
* [margin系列之bug巡演（二）](/2013/12/17/css/margin系列之bug巡演（二）/)
* [margin系列之内秀篇（二）](/2013/12/14/css/margin系列之内秀篇（二）/)
* [margin系列之bug巡演](/2013/12/10/css/margin系列之bug巡演/)
* [margin系列之内秀篇](/2013/12/06/css/margin系列之内秀篇/)
* [margin系列之外边距折叠](/2013/12/04/css/margin系列之外边距折叠/)
* [margin系列之与相对偏移的异同](/2013/12/02/css/margin系列之与相对偏移的异同/)
* [margin系列之百分比](/2013/11/30/css/margin系列之百分比/)
* [margin系列之keyword auto](/2013/11/29/css/margin系列之keyword%20auto/)