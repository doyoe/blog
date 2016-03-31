title: margin系列之bug巡演
date: 2013-12-10 11:15:00
categories: CSS
author: 杜瑶
tags: [margin, w3c, margin bug]
---

## 我所知道的浏览器margin bug

* IE6浮动双倍margin bug；
* IE6浮动相邻元素3px bug；
* IE6/7 clear引发的margin-top bug；
* 待补充的有一堆

## 为bug生为bug死为bug欲仙欲死的日子

各浏览器的实现差异或者由此而引入的错误，一直都是前端开发人员的梦魇。相信大多数的前端都为此而精疲力尽过，浏览器bug你所知有几？

## IE6浮动双倍margin bug

这当是IE6最为经典的bug之一。高大上的前端，你肯定从未与其失之交臂过。

## 触发方式

* 元素被设置浮动
* 元素在与浮动一致的方向上设置margin值

<!--more-->

来看看详细的代码吧：

### HTML

    <div id="demo">
        <p>IE6下浮动方向上的margin值将会双倍于其指定值</p>
    </div>

### CSS

    #demo p{
        float:left;
        margin-left:10px;
    }

### 效果对比

![非IE6下浮动无双边距](http://demo.doyoe.com/css/margin/images/double-margin-non-ie6.png) （图一）

图一 是非IE6下的效果

![IE6下浮动双边距](http://demo.doyoe.com/css/margin/images/double-margin-on-ie6.png) （图二）

图二 是IE6下的效果

从图一和图二的对比，我们肉眼就可以发现区别。是的，IE6下左边的外边距变成了 `margin-left` 指定值的2倍，而其它浏览器下正常，这就是经典的IE6浮动元素双倍边距bug。来看看具体的例子：`DEMO1` [IE6浮动元素双倍margin bug重现](http://demo.doyoe.com/css/margin/bug/double-margin.html)

很开心告诉你，问题要比这还更复杂一些，接着往下看。

## 同个浮动方向的元素只有第一个元素会double margin

`double margin` 并不会发生在所有的浮动元素上，同个包含块内，在相同的浮动方向上，它只发生在第一个浮动元素上。

用代码说话：

### HTML

    <div id="demo">
        <p>第一个float:left</p>
        <p>第二个float:left</p>
        <p>第三个float:left</p>
    </div>

CSS Code不变，加多2个浮动元素，再来看具体情况，有图有真相：

![同个浮动方向的元素只有第一个元素会double margin](http://demo.doyoe.com/css/margin/images/double-margin-only-first-child-on-ie6.png) （图三）

看到图三结果一目了然，三个 `float:left` 的元素只有第一个元素才 `double margin` 了。用个例子来终结它：`DEMO2` [同个浮动方向的元素只有第一个元素会double margin](http://demo.doyoe.com/css/margin/bug/double-margin-2.html)

## double margin只发生在float:left时？

你觉得呢？结果当然不会是这样。在之前，我们只说过在同个浮动方向的第一个浮动元素会double margin，并没有说只有 `float:left` 才触发。

我们将 `DEMO1` 的CSS简单改改，HTML不变

### CSS

    #demo p{
        float:right;
        margin-right:10px;
    }

结果会是怎样呢？看 `图四`：

![IE6 double margin也会发生在float:right时](http://demo.doyoe.com/css/margin/images/double-margin-on-ie6-3.png) （图四）

在图四中，我们看到右侧的外边距明显比指定值 `margin-right:10px` 要大，恩，确实，它是20px，也double了。瞧瞧：`DEMO3` [IE6 double margin也会发生在float:right时](http://demo.doyoe.com/css/margin/bug/double-margin-3.html)

## 既有左浮动又有右浮动的情况将会是怎样呢？

我们先来将代码呈上：

### HTML

    <div id="demo">
        <p class="a">1 float:left</p>
        <p class="b">2 float:left</p>
        <p class="c">3 float:right</p>
        <p class="d">4 float:right</p>
    </div>

### CSS

    #demo .a,#demo .b{
        float:left;
        margin-left:10px;
    }
    #demo .c,#demo .d{
        float:right;
        margin-right:10px;
    }

是的，你可能想到了，第一个左浮动元素和第一个右浮动元素都将会出现 double margin。来看 `图五`：

![既有左浮动又有右浮动的情况](http://demo.doyoe.com/css/margin/images/double-margin-on-ie6-4.png) （图五）

左右都 double margin 了，这看似挺复杂，其实为什么会这样，前面都讲得比较明白了，所以应该能理解？本例也奉上：`DEMO4` [复杂的double margin](http://demo.doyoe.com/css/margin/bug/double-margin-4.html)

## double margin 不仅仅出现在margin-left/right

和大多数其它 `margin` 特性一样，double margin 也受书写模式 `writing-mode` 影响。我们在开篇所说的触发条件之一 `元素在与浮动一致的方向设置margin值` ，其实并不完全精确。当 `writing-mode` 为纵向时，会发生 double margin 的方向也相应变成了纵向。

当书写模式 `writing-mode` 纵向时，设置 `float:right` 时，会发生什么？来看代码：

### HTML

    <div id="demo">
        <p>书写模式改变双倍margin bug方向</p>
    </div>

### CSS

    #demo{
        -webkit-writing-mode:vertical-rl;
        writing-mode:tb-rl;
    }
    #demo p{
        float:right;
        margin:10px 0;
    }

CSS Code中，我们同时设置了 `margin-top/bottom` 的值都为 10px。你预期会 double 的方向是 top or bottom？不太确定？看到 `图六` 你就知道了：

![书写模式改变IE6浮动双倍margin bug方向](http://demo.doyoe.com/css/margin/images/double-margin-writing-mode-on-ie6.png) （图六）

图六清晰的验证了 `writing-mode` 会影响 double margin 的方向；并且当设置了 `float:right` 时，只有 `margin-bottom` 会 double。看看示例吧：`DEMO5` [书写模式改变IE6浮动双倍margin bug方向](http://demo.doyoe.com/css/margin/bug/double-margin-tbrl.html)

## `float:left` 时， double margin 的将会是 top or bottom？

大家再猜猜，在书写模式为纵向时，设置了 `float:left`，结果又将会如何？

我们只简单的将 `DEMO5` 中的CSS改成 `float:left` 其余不变，于是得到 `图七` 如下：

![书写模式改变IE6浮动双倍margin bug方向](http://demo.doyoe.com/css/margin/images/double-margin-writing-mode-on-ie6-2.png) （图七）

你会惊讶的发现，`margin-top/bottom` 两个方向都出现了 double，这真是一件好神奇的事，事实胜于雄辩：`DEMO6` [书写模式纵向时margin-top/bottom都将double](http://demo.doyoe.com/css/margin/bug/double-margin-tbrl-2.html)

写到这，关于IE6浮动双倍margin bug就说的差不多了，包括触发方式，各种情景下的变化，还有解决方案。哦，解决方案貌似还没写...

## fix IE6浮动双倍margin bug

我们以 `DEMO1` 作为需要fix的case

### 给IE6在会 double margin 的方向上设置小一倍的margin值，如下：

### CSS

    #demo p{
        float:left;
        margin-left:10px;
        _margin-left:5px;
    }

恩，IE6的hack，就不再赘述了。不过这种处理方式有一个明显的缺陷，那就是不够灵活，无法通用。因为当标准 margin 值改变时，这个值就得变化。所以不推荐使用这种方式。

### display:inline

### CSS

    #demo p{
    	_display:inline;
        float:left;
        margin-left:10px;
    }

恩，仍然是only ie6的hack，不过这个方案更Cool，它不需要care margin值到底是什么，足够灵活。看具体的例子吧：`DEMO7` [修复IE6浮动双倍margin bug](http://demo.doyoe.com/css/margin/bug/double-margin-fix.html)。至于为什么会有这种解法，我想只能问问微软的童鞋了。

完全没想到，单一个双边距bug就写了这么长的篇幅，本打算一篇文章涵盖一堆bug，看来得分篇了。

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