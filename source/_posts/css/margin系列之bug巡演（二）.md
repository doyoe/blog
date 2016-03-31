title: margin系列之bug巡演（二）
date: 2013-12-17 11:15:00
categories: CSS
author: 杜瑶
tags: [margin, w3c, margin bug]
---

## IE6/7 clear引发的margin-top bug

我知道，这是一个被谈及较少的bug，但我几乎可以肯定你在遇见过的同时并没有把它当成是一个bug。

## w3c关于 clear 特性的描述

设置了 `clear` 为非 `none` 值的元素，其顶部 `border` 边界在垂直方向不允许出现在之前的浮动元素底部 `margin` 之上。

<!--more-->

什么意思呢？用段代码来阐述：

### HTML

    <div class="a">float:left</div>
    <div class="b">clear:left</div>

### CSS

    .a{
        float:left;
        height:30px;
        margin:20px;
    }
    .b{
        clear:left;
        height:30px;
        margin-top:-30px;
    }

如上代码，你认为 `.b` 是否会相对自身向上偏移 30px 呢？然后盖住 `.a` 底部 10px？如果你真这么猜想，那就错了。

来看上述代码，我们会得到什么样的结果，如 `图一`：

![clear margin](http://demo.doyoe.com/css/margin/images/clear-margin.png)（图一）

恩，你觉得这可能会是落后浏览器才这样，比如IE6/7。很高兴的告诉你，其实高级浏览器才这样，IE6/7的表现会是之前你猜想的那样，如下 `图二`：

![clear margin](http://demo.doyoe.com/css/margin/images/clear-margin-on-ie67.png)（图二）

不论你相信与否，看个例子你就明白了 `DEMO1`：[clear margin 猜想](http://demo.doyoe.com/css/margin/bug/clear-margin.html)，你会发现就算将 `margin-top` 去掉，`.b` 的位置也丝毫不会改变。

## 为什么会这样？

我们已经说过设置了 `clear` 为非 `none` 值的元素其顶部 `border` 边界不允许出现在之前浮动元素的底部margin边界之上。也就是说必须在垂直方向上递次堆叠却不能重合。

所以说高级浏览器是遵循w3c规范的，而IE6/7的实现明显有悖该规则。

虽然拥有 `clear` 特性的元素其 `border` 顶部边界不允许超越之前浮动元素的底部margin边界之上，但是其margin可以和之前浮动元素的任何区域重合。我们稍微改下之前代码：

### HTML

    <div class="a">float:left</div>
    <div class="b">clear:left</div>

### CSS

    .a{
        float:left;
        height:30px;
        margin:20px;
    }
    .b{
        clear:left;
        height:30px;
        margin-top:50px;
    }

我们将 `.b` 的 `margin-top` 修改为一个正值，能得到如下 `图三`：

![clear margin](http://demo.doyoe.com/css/margin/images/clear-margin-2.png)（图三）

图中的黄色区域是 `.b` 的 `margin-top`，你会发现，它可以和 `.a` 的任何区域重合。同时，你也可以发现 `图三` 和 `图一` 居然是一样的效果，`.b` 的实际位置都没变化过。来看例子 `DEMO2`：[clear margin 验证](http://demo.doyoe.com/css/margin/bug/clear-margin-2.html)

这是否说明拥有 `clear` 特性的元素对其之前的浮动元素没有任何影响？因为不论是正值还是负值，其位置都不会发生变化。

如果你这样想，那你就又错了。

## 拥有clear特性的元素其margin紧邻之前的浮动元素依然有效

是的，在某个临界值，这一切会发生改变，并非全然无效。

这个临界值是什么？

临界值是包含块内浮动元素的实际高度，即浮动元素的 margin + border + padding + height，拿我们的 `DEMO2` 来详述：

`DEMO2` 中的浮动元素 `.a` 的实际高度为 30 + 20*2 = 70px，也就说当 `.b` 的 `margin-top` 大于 70px 时，超过的部分将会使得 `.b` 发生偏移。

### CSS

    .b{
        clear:left;
        height:30px;
        margin-top:100px;
    }

我们将 `DEMO2` 中的 `margin-top` 改成 100px，再看看具体情况 `DEMO3`：[clear margin 验证2](http://demo.doyoe.com/css/margin/bug/clear-margin-3.html)，你可以手动的修改其 `margin-top` 值，看看临界值是否如前所述。

## 解决方案

IE6/7下由 `clear` 特性引发的 `margin-top` bug，并没有像 double margin 那样的万精油 `display:inline` 解决方案，所以需要寻求的是让IE6/7和其它浏览器绕过此问题来进行解决。

例如：

* 尽量避免为设置了 `clear` 为非 `none` 值的元素定义margin-top；
* 如果必须，可以将拥有 `clear` 特性的元素作为容器，在其子元素上设置margin-top；
* 视情况换成padding-top；

## 要注意的问题

`.a` 和 `.b` 需要在处在同一个块级上下文内，或者其包含块拥有 `padding-top/border-top`，否则临界值情况将失效，不过任何IE目前都不需要此前置条件。用IE和非IE查看 `DEMO4`：[clear margin 验证3](http://demo.doyoe.com/css/margin/bug/clear-margin-4.html)


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