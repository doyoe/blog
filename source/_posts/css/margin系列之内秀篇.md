title: margin系列之内秀篇
date: 2013-12-06 11:15:00
categories: CSS
tags: [margin, w3c, margin应用]
---

## 最Cool的利器

一样东西在不同的场景，不同的人手里，所能做的事会有很大不同。我深切的以为 `margin` 绝对是 CSS 中最有能力的利器之一，不知大家以为然否？

前面几篇文章大概的讲了一些关于 `margin` 的特性，所以本篇会聊聊 `margin` 的实际应用场景，也算让自己休息一下，不用再讲知识点。

## 有个很典型的需求

<!--more-->

相信接下来这个需求，你十有八九实现过，甚至实现过多次，来看 `图一`：

![经典文本标题列表](http://demo.doyoe.com/css/margin/images/text-list.png)

我们看到这个图中，有个列表，每个列表项下面都有一条线，但最后一项没有。我们预期的代码是：

    <div id="demo">
        <h3>标题列表</h3>
        <ul>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
        </ul>
    </div>

如果每项都有条底线，我们可以很简单的做到，如下：

    #demo li{
        border-bottom: 1px solid #ccc;
    }

然而为了处理最后一项，事情就变得有点纠结了。我知道肯定有人要说，我们有 `:first-child`, `:nth-last-child(n)`, `:nth-last-of-type(n)` 之类的CSS3选择符，要处理这个，太easy了。恩，我也不得不承认，CSS3确认让事情变得简单多了。但我们可能需要面对一些国情，因为需要照顾一些弱小者，比如IE6-8，它们离CSS3的世界太远。

## 传说中的first/last解决方案

所以我们需要找别的方法，于是这样的代码，相信你见过无数遍了：

    <div id="demo">
        <h3>标题列表</h3>
        <ul>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li>&raquo; 有点累想歇一下好长一个标题</li>
            <li class="last">&raquo; 有点累想歇一下好长一个标题</li>
        </ul>
    </div>

我没乱说，你肯定见到类似的代码千百遍了？是的，它确实能够解决我们的问题，请看 `DEMO1` [传说中的first/last解决方案](http://demo.doyoe.com/css/margin/text-list-add-class-solution.htm)，代码如下：

	#demo .last{
        border-bottom: 0 none;
    }

使用特殊的class来单独处理这项，但我不是很喜欢这样的code，原因大致有：

* 需单独定义一个差异化的class；
* 不利于数据循环输出，因为还得判断是否最后一项；

## margin的神来之笔

基于以上的原因，肯定会有其它的解决方案出现，这时margin无疑是非常不错的选择，来看代码：

	#demo{
        overflow:hidden;
    }
    #demo ul{
        margin-bottom: -1px;
    }

CSS代码如上，HTML代码当时使用开篇时的那段，结果请看：`DEMO2` [margin解决方案](http://demo.doyoe.com/css/margin/text-list.htm)

是不是很Cool，完全避免了上述的问题，并且代码量很小。至于为什么可以这样实现，前几篇文章里有说过，margin是互动的，能影响其上下文的布局。本例中，当 `ul margin-bottom:-1px` ，其本身的高并不会被改变，但其相邻的元素则会往上 `1px` ，这时相邻的元素即其包含块 #demo，所以给 `#demo overflow:hidden` ，就直接将那 1px 的边框给裁剪掉了。

## 再来个相似的需求

看看下述的 `图二`，这应该也是一种非常常见的图片列表需求：

![经典图片列表](http://demo.doyoe.com/css/margin/images/img-list.png)

只关注图片之间的间隙，我们发现3张图片，却只有2个间隙。不论你是用 `margin-left` 或者说是 `margin-right` ，都无法直接达成这个需求。

当然，可以像 `DEMO1` 那样给第一个或者最后一个添加一个特殊类 first/last 来解决。但这种方式刚被说不喜欢，所以想想用 `margin` 方式吧，思路应该说是和 `DEMO2` 毫无二致。来看代码：

### CSS

	#demo{
        overflow:hidden;
    }
    #demo ul{
        margin-right:-10px;
    }

### HTML

    <div id="demo">
        <h3>图片列表</h3>
		<ul>
            <li><img src="images/1.jpg" alt="" /></li>
            <li><img src="images/2.jpg" alt="" /></li>
            <li><img src="images/1.jpg" alt="" /></li>
        </ul>
    </div>

恩，就这么简单，很美妙。效果可移步 `DEMO3` [margin处理图片列表间隙解决方案](http://demo.doyoe.com/css/margin/img-list.htm)

我知道不少人还会使用给图片列表容器加宽度的方式来进行处理，当然，它很OK，不过不够灵活，因为在不同场景下，宽度可能不一样，这样的code无法被提取为公用样式，复用性不强。

而 `margin` 的方式完全不care几乎任何场景，都可以使用，因为在大多数情况，我们这样一个图片模块都是自适应宽度的，因为它会处于某个layout下，宽度完全取决于layout，所以其实在真实场景下 #demo 的 `overflow` 并不是必须的，也就是说 `margin-right` 的负值理论上可以预设成一个很大的值。

### CSS

    #demo ul{
        margin-right:-100px; /* 这个可以设置得比li的间隙更大，所以理论上可以写一次而适用于真实场景的任何情况 */
    }

看我们简单还原的真实场景使用方式：`DEMO4` [模拟真实场景：margin处理图片列表间隙解决方案](http://demo.doyoe.com/css/margin/img-list-2.htm)。恩，就这样，灵活性和可扩展性爆棚，不是么？

## 缩进实例

依然先贴个图，以下是 `图三`：

![文本缩进](http://demo.doyoe.com/css/margin/images/indent.png)

貌似是个好常见的需求场景，当然，要实现这样的效果，对于大家来说都不过是信手拈来，再容易不过。

### HTML

    <div>
        <strong>简介：</strong>
        <p>该写点什么好呢？好头痛，一个能把value念成“哇柳”的中老年人，猛然觉得没文化好可怕。</p>
    </div>

你可能随手就会写下 `float + margin/padding`，`float + bfc`，`absolute + margin/padding`，`flex` 等方案中的随意一个，恩，都很Cool，我也常这么干。

只是有的时候在一个小场景下，希望能比较轻量的出来这样的缩进，可能不想有浮动，绝对定位，清除浮动之类的，怎么破？

## margin依然是你很好的选择

你想到了吗？是的，用margin。

### HTML

    <p><strong>简介：</strong>该写点什么好呢？好头痛，一个能把value念成“哇柳”的中老年人，猛然觉得没文化好可怕。</p>

### CSS

    p{
        padding-left:45px;
    }
    strong{
        margin-left:-45px;
    }


看起来很简单，没有浮动，没有绝对定位，没有其它重布局，很清凉有木有？

甚至 `HTML` 也可以更简单，因为无需对后面那长段做任何处理，所以不需要再加包裹。来看看具体例子吧。`DEMO5` [margin缩进实例](http://demo.doyoe.com/css/margin/indent.htm)。我想这样的轻量方式，在一定时候还是有使用价值的，不是么？

## 视觉欺骗伪等高

等高布局在一段时间内好似挺火，方案也涌现过不少，如 `图四`：

![等高布局](http://demo.doyoe.com/css/margin/images/layout.png)

该图要求，不论是主栏还是侧栏，总是以最高的那列为基准高度。核心代码：

### CSS

    #doc{
        overflow:hidden;
    }
    #main,#aside{
        margin-bottom:-999px;
        padding-bottom:999px;
    }

### HTML

    <div id="doc">
        <div id="main">主内容栏<br />占位内容</div>
        <div id="aside">侧边栏</div>
    </div>

先看看结果：`DEMO6` [margin伪等高布局](http://demo.doyoe.com/css/margin/layout.htm)

效果和我们的要求一致，达到了等高布局。需要提醒的是，这其实只是视觉欺骗，做到的了伪高等高。主栏和侧栏的实际高度其实并不相等，之所以可以达成这样的效果，其原因在于负 `margin` 值。我们前文中有提到过，`margin` 会影响其上下文布局，当我们将 `margin-bottom` 设置为负值时，其相邻的包含块元素，底部会自动上去其负值的高度，直到最高的那列底部边缘为止，然后裁剪。但该列本身的高度并不会发生变化，同时因为有 `padding-bottom` 向下扩展，颜色被填充满padding区域，于是达到视觉上的等高。

描述的貌似有点复杂，没文化好可怕。差不多就这样，不能接着往下写了，要不收不住。

作为 CSS 的重要属性 `margin` 有很多可被挖掘的潜力，需要更多的是想法。enjoy it.


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