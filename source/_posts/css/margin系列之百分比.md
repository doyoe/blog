title: margin系列之百分比
date: 2013-11-30 11:15:00
categories: CSS
author: 杜瑶
tags: [margin, w3c, margin百分比]
---

## 你可能从没注意过它

在 [margin系列之keyword auto](http://blog.doyoe.com/~posts/css/2013-11-29-margin%E7%B3%BB%E5%88%97%E4%B9%8Bkeyword%20auto.md) 中，说过了 `margin` 值为 `auto` 的情况，这次要聊的是值为百分比的情形。

我必须承认这是一个非常基础的知识点，但有一段时间我发现很多人对此有错误的认知。偶尔在面试或者分享的时候，我会问到这个问题，有人会脱口而出的告诉我他对此的感性理解。

或许现在大多数人对此不屑一顾，但我仍想说一说，这样以后就可以不再问类似的问题了。

## 假设有这样一个场景

仍然以一个问题来开始，这是我之前在 [微博](http://weibo.com/doyoe) 发过的，原文是这样的：

<!--more-->

假设一个块级包含容器，宽1000px，高600px，块级子元素定义 `margin:10% 5%;` 大家说说 `margin` 的 `top, right, bottom, left` 计算值最终是多少？

我记得得到不少 `100px 30px 100px 30px` 的反馈，我们来还原代码：

### CSS:

```css
#demo{
	width: 1000px;
	height: 600px;
}
#demo p{
	margin: 10% 5%;
}
```

### HTML:
```html
<div id="demo">
	<p>恩，注意看我所在的位置。</p>
</div>
```

事实告诉我们结果是 `100px 50px 100px 50px`，不论结果是否符合你的预期，我们先来看demo验证一下：[margin百分比结果猜想](//demo.doyoe.com/css/margin/percentage.htm)，当然，你也根据上面还原的代码自己创建一个例子。

## 为什么会这样？

诧异吗？不用怀疑浏览器出了问题，因为这是正确的实现。

规范中注明 `margin` 的百分比值参照其包含块的宽度进行计算。

当然，它不会这么简单，和上篇文章 keyword auto 一样，这只发生在默认的 `writing-mode: horizontal-tb;` 和 `direction: ltr;` 的情况下。

当书写模式变成纵向的时候，其参照将会变成包含块的高度。我们改变一下上面例子中的CSS书写模式：

### CSS:

```css
#demo{
	-webkit-writing-mode: vertical-rl; /* for browsers of webkit engine */
	writing-mode: tb-rl; /* for ie */
}
```

在 #demo 中添加这2句，其它code不变。也有个例子供观：[书写模式影响margin百分比的参照对象](//demo.doyoe.com/css/margin/percentage2.htm)。

恩，这回的结果是 `60px 30px 60px 30px` ，因为其参照对象变成了包含块的高度。

## 顺带再说说

你是否觉得这不符合常规的感性认知？感性认知更多感觉应该横向参照包含块宽度，纵向参照包含块高度。

其实这是为了要横向和纵向2个方向都创建相同的margin，如果它们的参照物不一致，那就无法得到两个方向相同的留白。

你可能会问那为什么要选择宽度做参照而不是高度呢？

这其实更多的要从CSS设计意图上去想，因为CSS的基础需求是排版，而通常我们所见的横排文字，其水平宽度一定（仔细回想一下，如果没有显式的定义宽度或者强制一行显示，都会遇到边界换行，而不是水平延展），垂直方向可以无限延展。但当书写模式为纵向时，其参照就变成了高度而不再是宽度了。

还记得我们在 [margin系列之keyword auto](http://blog.doyoe.com/~posts/css/2013-11-29-margin%E7%B3%BB%E5%88%97%E4%B9%8Bkeyword%20auto.md) 留了个问题：为什么 `margin: auto;` 无法再纵向上垂直居中？其实原因也是上面所说的，因为纵向是可以无限延展的，所以没有一个一定的值可以被参照被用来计算。

## 受书写模式影响的其它特性：

* margin折叠
* margin的keyword auto value
* padding的百分比值

## 可参考：

* http://dev.w3.org/csswg/css-box/#the-margin-properties
* http://dev.w3.org/csswg/css-box/#ltpercentagegt
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