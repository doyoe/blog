title: background系列之你不知道的background-position
date: 2016-3-28 11:15:00
categories: CSS
tags: [background, background-position, w3c, CSS应用]
---

## 这是一个有趣的话题

其实我并不确切的平时大家是怎么去应用或者玩转一个属性，一个值。我能肯定的是这些东西都有不少的可玩性。

我今天要聊的 `background-position` 应该已经被大家玩得色彩斑斓了。尤其是 `CSS Sprites` 流行的这些年，`background-position` 基本上是被应用最多的属性之一。

## 重拾旧趣

我们知道 `background-position` 是用来指定背景图像的偏移值的，能让一张图从特定的位置开始展现。而 `CSS Sprites` 就是通过将多个小图拼接成一张大图，然后利用 `background-position` 来指定需要显示的区域，以此达到合并HTTP请求的预期。

<!--more-->

## 一个足够简单的应用

为了回顾 `background-position` 的应用，接下来我将会用一个最简单的例子来代入，这里有一张由2个 `300*100px` 垂直拼接而成的图片作为背景图，如 `图0`：

![图0：简单的文字图片](http://demo.doyoe.com/css3/background-position/skin/text-image.png)

我现在需要 `图0` 在2个并排的div中分别显示不同的部分：

### HTML:
```html
<div class="part1"><!-- 显示图0上半部分 --></div>
<div class="part2"><!-- 显示图0下半部分 --></div>
```

于是我写了段简单的CSS，如下：

### CSS:
```css
div {
    width: 300px;
    height: 100px;
    background: gray url(../test.png) no-repeat;
}
.part1 {
    background-position: 0 0;
}
.part2 {
    background-position: 0 -100px;
}
```

很显然我可以得到预期，效果如 `图1`：

![图1：简单的CSS Sprites应用](http://demo.doyoe.com/css3/background-position/skin/normal.png)

这就是最典型的 `CSS Sprites` 使用场景。当然，你可以在线查看这个例子 `Demo1` [最简单的 background-position 应用](http://demo.doyoe.com/css3/background-position/normal.htm)。

## 默认值

由于 `background-position` 的默认值是 `0% 0%`，那么上述的CSS代码其实可以优化成：

```css
.part2 {
    background-position: 0 -100px;
}
```

因为 `.part1` 指定的值是 `0 0`，和默认值相同，所以可以省略。你会发现，对一个属性了解得更多，就更能帮助你写出简洁的代码。

## 百分比

我并不能确定大家是否使用过 `background-position` 的百分比，这里就权当大家对此并不甚了解。

### 试着使用百分比去实现上个例子

我相信肯定有童鞋会这样写：

```css
.part2 {
    /* background-position: 0 -100px; */
    background-position: 0 -50%;
}
```

按照一般的思维，上述两行代码应该是等价的，不是么？在开篇的时候我们就说了背景图 `图0` 的高度是 `200px`，那么 `-50%` 正好是 `-100px`。

不用着急，我们会用实际的例子来验证这个结果，来看 `Demo2` [检验 background-position 的百分比值](http://demo.doyoe.com/css3/background-position/percentage.htm)。

![图2：参照尺寸验证](http://demo.doyoe.com/css3/background-position/skin/percentage.png)

结果让人有点忧伤，这和我们的设想有点出入，这是为什么呢？

### 追本溯源

我们都知道一个百分比值，必然会需要有一个参照尺寸。举个例子来讲，假设我定义一个元素的宽度是 `50%`，那么这个元素的具体宽度就是：`包含块宽度 * 50%`。

所以，如果你需要使用百分比作为 `background-position` 的值，必须清楚它的参照尺寸是什么。

`w3c` 是这样描述 `background-position` 比分比值的：

> 原文：refer to size of background positioning area minus size of background image.
>
> 翻译：参照指定背景区域的尺寸减去背景图片的尺寸

这是什么意思呢？白话一点说：`background-position` 的百分比值参照的是设置背景的区域减去背景图的尺寸。

### 再出发

按照这个思路，我们将：

```css
.part2 {
    background-position: 0 -50%;
}
```

换算一下将会得到：

```css
.part2 {
    background-position: 0 50px;
}
```

换算过程为：(设置背景的区域高度 - 背景图的高度) \* -50%，即：(100 - 200) \* -50% = 50px

这就解释了 `Demo2` 为什么会得到 `图2` 的效果。但这显然并不是我们想要的，我们预期的效果是 `图1`。

根据上述的公式，我们可以逆推预期效果的百分比值是多少：

```
-100 / (100 - 200) = 100%
```

所以如果你要使用百分比，那么定义应该是这样的：

```css
.part2 {
    background-position: 0 100%;
}
```

其结果如 `Demo3` [正确使用 background-position 百分比](http://demo.doyoe.com/css3/background-position/percentage-value.htm)

这会终于得到我们的预期效果了，请看 `图3`

![图3：百分比的正确预期效果](http://demo.doyoe.com/css3/background-position/skin/normal.png)

了解了百分比的这个特性后，会帮助我们大大简化某些定义，比如我在 [Yo](https://github.com/doyoe/Yo) 里面对 [yo-score](http://blog.doyoe.com/Yo/demo/element/yo-score.html) 的处理，非常巧妙，有兴趣的童鞋可以自己研究一下，这里不细讲。

另外：需要注意的是百分比值会受 `background-size` 影响，因为 `background-size` 可以改变背景图像的大小。

## 多值

在 `CSS3` 中，对 `background-position` 属性进行了扩展，允许接受3到4个参数，用于指定背景图的起始方向和具体位置。

> 原文：If three or four values are given, then each &lt;percentage&gt; or &lt;length&gt; represents an offset and must be preceded by a keyword, which specifies from which edge the offset is given.
>
> 翻译：如果指定了三个或四个值，那么每个 &lt;percentage&gt; 或 &lt;length&gt; 之前必须有一个关键字，用于指定该方向的偏移量。

当指定3到4个参数时，不接受 `center` 关键字作为偏移量作为边界，只能使用 `top, right, bottom, left` 这4个关键字。

### 多值的意义

在此前，我们使用 `background-position` 只能让背景图从 `top, right, bottom, left, center` 这5个边界开始显示，但无法指定任意一个边界的偏移量。

举个例子：我想让一个背景图从右下角偏移 `20px`

你会发现如果没有多值扩展，你很难轻易做到这件事，除非你能确定容器的宽高永远都是显式定义好的，就算如此，其灵活性也一文不值。

### 多值的应用

如果利用多值特性，这将变得非常轻松，我们仍使用 `图0` 作为背景图，来做一个演示。

```
.demo {
    width: 400px;
    height: 400px;
    background: url(../test.png) no-repeat;
    background-position: right -300px bottom 20px;
}
```

这会终于得到我们的预期效果了，请看 `图4`

![图4：背景图多值应用](http://demo.doyoe.com/css3/background-position/skin/multi-value.png)

效果可以查看 `Demo4` [background-position 边界偏移](http://demo.doyoe.com/css3/background-position/multi-value.htm)。实际上，有了多值之后，我们可以让背景图在任意方位上偏移，你可能会发现，这甚至可以让你的结构写得更简单，嵌套变浅。

## 写在最后

当你深入了解了每个属性的每个定义，你的CSS世界又会变得和以前不一样。enjoy it.


## background系列文章：

* [background系列之你不知道的background-position](/2016/03/28/css/background系列之你不知道的background-position/)