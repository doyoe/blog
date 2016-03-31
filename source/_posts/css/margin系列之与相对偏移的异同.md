title: margin系列之与相对偏移的异同
date: 2013-12-02 11:15:00
categories: CSS
author: 杜瑶
tags: [margin, w3c, margin偏移]
---

## 也许我们是一样的

可能大家都用会 `margin` 或者相对偏移的 `top, right, bottom, left` 来做一些类似元素偏移的事，其实我也会。这回我们只聊 `relative` 下的 `top, right, bottom, left` 。

比如说我们想让一个 div 向下偏移 50 个像素，通常会这样：

### Case 1:

```css
#demo .margin-top{
	margin-top: 50px;
}
```

### Case 2:

```css
#demo .relative-top{
	position:relative;
	top: 50px;
}
```

### HTML:
```HTML
<div id="demo">
	<div class="margin-top">我是margin-top:50px</div>
	<div class="relative-top">我是relative top:50px</div>
</div>
```

上述2种方式，我们都可以完成 div 向下偏移 50 个像素的需求。来看看 `DEMO1`: [margin-top vs. relative top](http://demo.doyoe.com/css/margin/margin-top-vs-relative-top.htm)

<!--more-->

## 其实它们真的有相似的地方

从上面的例子，可以发现不论是 `margin-top` 还是 `relative top` 都是以自身作为参照物进行偏移的。

顺带说一下 `absolute` 偏移相对的是包含块，并且其偏移值是从包含块的 `padding` 区域开始计算。

## 但它们真的不一样，我们来看看规范怎么说：

### margin:
> 原文：Margins in CSS serve to add both horizontal and vertical space between boxes.

> 翻译：CSS中的margin用来添加盒子之间的水平和垂直间隙。

### top, right, bottom, left:
> 原文：An element is said to be positioned if its ‘position’ property has a value other than ‘static’. Positioned elements generate positioned boxes, and may be laid out according to the following four physical properties: top, right, bottom, left.

> 翻译：一个元素的position属性值如果不为static则发生定位。定位元素会产生定位盒，并且会根据 top, right, bottom, left 这4个物理属性进行排版布局。

意思很明白，`margin` 是用来增加自身与它人之间的空白，而 `top, right, bottom, left` 是用来对自身进行排版，作用完全不同。

也就是说 `margin` 是互动的，因为它要影响它人；而 `top, right, bottom, left `是孤独的，它只是自己一个人玩，不影响它人。

## 回到之前那个例子
在 `DEMO1` 中，我们看到2个方法都可以做到向下偏移50px，不过它们的意义不太一样。

margin的case: 让该div的顶部与其相邻的元素（这里即其包含块）留有50px的空白。

top的case: 让该div距离其包含块顶部边缘50px，因为是 `relative` ，所以这里是距离div自己的顶部边缘。

## 我们大胆假设一下
如果我们设置 `margin-bottom` 和 `bottom` 的值也为50px，它们的表现将完全不一样，你觉得呢？ 恩，试试：

### Case 1:

```css
#demo .margin-bottom{
	margin-bottom: 50px;
}
```

### Case 2:

```css
#demo .relative-bottom{
	position: relative;
	bottom: 50px;
}
```

### HTML:
```HTML
<div id="demo">
	<p class="margin-bottom">我是margin-bottom:50px</p>
	<p class="relative-bottom">我是relative bottom:50px</p>
</div>
```

验证猜想的时刻到了，来看看 `DEMO2`: [对margin-bottom和bottom的表现猜想](http://demo.doyoe.com/css/margin/margin-bottom-vs-relative-bottom.htm)

结果有出乎你的意料吗？好吧，不论怎么，解释下为什么会这样？

前面我们说过 `margin` 是用来增加自身与它人之间的间隙，所以它距包含块底部有50px，这应该能理解？那为什么 `bottom`会跑到上面去？相信仔细看了之前的描述，你应该知道。因为它要相对自己的底部边缘有50px，恩，不是-50px，所以它等于是向上偏移了50px，很简单，不是吗？

还有一个细节你注意到了吗？`bottom` 没有撑开它的包含块，仔细看看它的包含块的背景色区域。这正好也验证了之前说的 `top, right, bottom, left` 是孤独的，它只是自己一个人玩，不影响它人。

## 孤独患者
我们将 `DEMO1` 稍改改，为其加上一点上下文，再看看结果：

### Case 1:

```css
#demo .margin-top p{
	margin-top: 50px;
}
```

### Case 2:

```css
#demo .relative-top p{
	position:relative;
	top: 50px;
}
```

### HTML:
```HTML
<div id="demo">
	<div class="margin-top">
		<p>我是margin-top:50px</p>
		我是一段随便什么上下文
	</div>
	<div class="relative-top">
		<p>我是relative top:50px</p>
		我是一段随便什么上下文
	</div>
</div>
```

迫不及待的要看看实际例子了，不是么？`DEMO3`: [再次验证一下top, right, bottom, left是孤独患者](http://demo.doyoe.com/css/margin/margin-top-vs-relative-top-2.htm)

至此可以再次说明 `top, right, bottom, left` 真的和其上下文一毛钱关系都没有，绝对的孤单患者。

所以 `margin` 和 `top, right, bottom, left ` 分别要在什么场景使用，应该可以有考量的依据了，不是么？enjoy it.

## 似乎还漏了点啥
差点就这么结篇了，想起还有点遗漏的地方。

当position为relative时，如果top和bottom都是auto，则它们的计算值是0，right和left亦然；如果top和bottom其中一个为auto，则auto相当于另一个的负值，即top = -bottom，right和left亦然；如果top和bottom的值都不为auto，则忽略bottom，如果right和left的值都不为auto，则忽略right。

好吧，不得不再写个例子：`DEMO4`: [top, right, bottom, left详述](http://demo.doyoe.com/css/margin/top-right-bottom-left.htm)

至于margin，就留给大家思考一下也不错 ^_^

enjoy it again.

## 可参考：

* http://dev.w3.org/csswg/css-box/#the-margin-properties
* http://dev.w3.org/csswg/css-position/#box-offsets-trbl

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