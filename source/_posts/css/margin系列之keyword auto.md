title: margin系列之keyword auto
date: 2013-11-29 11:15:00
categories: CSS
tags: [margin, w3c]
---

## margin的重要性：

有个不容置疑的事，前端开发人员没有人能够忽视CSS `margin`的重要性。CSS coding时，margin的使用频率就如同呼吸般频繁，如果我可以说得夸张点的话。

margin作为CSS盒模型基本组成要素之一，是非常Basis的一个技术手段，所以我想对于它的一些基本情况应该不用太介绍了？

## margin经常被用来做什么？

* 让块元素水平居中；
* 让元素之间留有舒适的留白；
* 处理特殊的first或last，大家懂的？
* 一些布局；

## 需要注意的地方：

* margin折叠；
* margin的百分比值；
* margin的auto值；
* margin和相对偏移top, right, bottom, left的异同；
* IE6浮动双margin Bug；
* IE6浮动相邻元素3px Bug；

看起来似乎有不少的知识点？恩，这些都是我们需要了解的，包括一些没有被列举出来的点。

今天要讲的其实只是其中很少的一部分，恩，标题里有：keyword auto

<!--more-->

## keyword auto

auto是margin的可选值之一。相信大家平时使用auto值时，最多的用法大概是 `margin: 0 auto;` 和 `margin: auto;`，恩，是的，块元素水平居中。让我们来看看代码实现：

### CSS:

```css
#demo{
	width: 500px;
	margin: auto; /* 或者 margin: 0 auto; */
}
```

### HTML:
```html
<div id="demo">
	<p>恩，我就是那个需要水平居中的家伙。</p>
</div>
```

为了更明显点，我们来看个例子：[margin实现块元素水平居中](//demo.doyoe.com/css/margin/horizontal-center.htm)。Cool，这么简单就实现了水平居中。

不过你可能也发现了不论是 `margin: auto;` 还是 `margin: 0 auto;` 效果都是一样的，都是让 #demo 水平居中了，但纵向并没有任何变化。

大家都知道 `margin` 是复合属性，也就是说 `margin: auto;` 其实相当于 `margin: auto auto auto auto;`，`margin: 0 auto;`相当于 `margin: 0 auto 0 auto;`，四个值分别对应上右下左。至于CSS中的上、右、下、左顺序就不做赘述了。

根据规范，`margin-top: auto;` 和 `margin-bottom: auto;`，其计算值为0。这也就解释了为什么 `margin: auto;` 等同于 `margin: 0 auto;`。但仅此而已吗？让我们来看看规范描述：

> 原文：On the A edge and C edge, the used value of ‘auto’ is 0.
>
> 翻译：如果场景是A和C，那么其 `auto` 计算值为 `0`。
>
> ![margin edge](//demo.doyoe.com/css/margin/images/margin.png)
>
> 更详细请参阅：[margin properties](//dev.w3.org/csswg/css-box/#the-margin-properties)

由此可见，它们还与书写模式 `writing-mode` 和 文档流方向 `direction` 有关。所以我们说 `margin: auto;` 等同于 `margin: 0 auto;` 是不太精准的，因为还有前置条件。

了解这些很重要，这有助于理解 `margin` 属性的设计意图。

OK，聊了这么多，我们回到默认的 `writing-mode: horizontal-tb;` 和 `direction: ltr;` 的情况继续往下，后面的话题都基于这个前提。

## 为什么auto能实现水平居中？

这是因为水平方向的 `auto`，其计算值取决于可用空间（剩余空间）。

> 原文：On the B edge and D edge, the used value depends on the available space.
>
> 翻译：如果场景是B和D，那么其 `auto` 计算值取决于可用空间。

想象这样一个场景，一个宽100px的p被包含在一个宽500px的div内，此时设置 p 的 margin-left 值为 auto，大家觉得结果会怎样？

### CSS:

```css
#demo{
	width: 500px;
}
#demo p{
	width: 100px;
	margin-left: auto;
}
```

### HTML:
```html
<div id="demo">
	<p>恩，我就是那个p。</p>
</div>
```

结果你猜到了吗？没猜到也不怕，用事实说话：[margin-left关键字auto结果猜想](//demo.doyoe.com/css/margin/margin-left-auto.htm)。

好了，结果得到了，p相对于包含块右对齐了，这与规范描述一致。`margin-left:auto;` 自动占据了包含块的可用空间，即 500 - 100px = 400px。也就是说auto最后的计算值为400px，即 `margin-left:400px;`。所以 `margin-right:auto;` 的结果会相当于左对齐。

到这里，相信大家都知道为什么 `margin: auto;` 和 `margin: 0 auto;` 能实现水平居中了。因为左右方向的auto值均分了可用空间，使得块元素得以在包含块内居中显示。

至于垂直方向上为什么无法居中，还有更深层的原因吗？大家可以思考一下。

## 可参考：

* http://www.w3.org/TR/css3-box/#margins
* http://dev.w3.org/csswg/css-box/#the-margin-properties
* http://dev.w3.org/csswg/css-box/#Calculating

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