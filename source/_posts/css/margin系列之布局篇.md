title: margin系列之布局篇
date: 2013-12-31 11:15:00
categories: CSS
tags: [margin, w3c, margin layout]
---

## 前端工程师对CSS的基本诉求

布局能力或许是Web前端工程师对CSS的最基本的诉求，当开始进入到这个岗位，就避免不了要和CSS打交道，而和CSS交往，布局当然是不可或缺的。

很遗憾的是，CSS2.1之前都没有出现真正意义上的布局属性，直至现如今的CSS3，才开始出现了一些，如：flex, grid 等，不过其兼容性及国内浏览器的使用情况，真令人捉急。

不过，有需求就会有变通，对于达成布局目的，已衍生出各式各样的方法，如：float, inline-block, table, absolute 等等。

<!--more-->

## margin的布局之道

其实，这个话题有点脱离 `margin` 的能力范围，因为单纯的 `margin` 并无法完成复杂布局，它更多做的是辅助，但却又难以替代。

## 经典左右结构

两栏结构应该是最常见和经典的网页呈现之一吧？如下 `图一`：

![classsic layout](http://demo.doyoe.com/css/margin/images/layout-1.png)（图一）

相信对于这样一个网页呈现，你不会陌生。那么你有多少种方案可以达成该布局？我想，4至5种应该是保守估计吧？

这次，我们只看 `margin` 是如何做的。

## absolute + margin 方式

### HTML

    <header id="hd">头部</header>
    <div id="bd">
        <aside id="aside">侧边栏固定宽度</aside>
        <div id="main">主内容栏自适应宽度</div>
    </div>
    <footer id="ft">底部</footer>

### CSS

    #aside{
        position:absolute;
        top:0;
        left:0;
        width:200px;
    }
    #main{
        margin-left:210px;
    }

如上关键代码，我们即可实现 `图一` 布局，该布局有一个特点就是，`#main` 可以自适应可用空间。

假定 `HTML` 是给定的，我们来解读一下 `CSS` 代码：

我们知道块级元素的特性之一是换新行，也就是说，如果想让 `#main` 和 `#aside` 在同行显示，我们要么改变其显示属性为 `inline-level`（即之前说的inline-block布局方式），要么改变其流方式（absolute, float, flex and etc...）。

如上述代码，我们使用了 `absolute`，即让 '#aside' 脱离常规流，通过绝对定位到想要的位置。

### 主内容栏自适应宽度

同时你会发现，我们并有改变 `#main` 的显示属性或者流方式，也就是说其仍然具备块级元素的特性，所以它会自动适应剩余宽度，即我们常说的自适应宽度。

我们并不希望 `#main` 区域会包含 `#aside` 在内，于是利用 `margin` 给 '#aside' 预留出足够其显示的空间，即可达成我们所要的布局。

可能你会问为什么是 `margin-left:210px` 而不是 `200px`，实际确实应该是 `200px`，多出来的 `10px` 只是为了创建一个列间隙，与布局实现无关。

来看看具体的实现 `DEMO1`: [margin+absolute布局：左栏固定主内容自适应](http://demo.doyoe.com/css/margin/layout/absolute-margin.html)

就这样，是不是很简单？其实它还有亮点，那就是：

### 任意调整列顺序

在不修改 `HTML` 的情况下，只需简单的修改 `CSS`，我们即可让左右两栏的顺序调换，来看代码：

### CSS

    #aside{
        position:absolute;
        top:0;
        right:0;
        width:200px;
    }
    #main{
        margin-right:210px;
    }

其实现原理没变，同样看看  `DEMO2`: [margin+absolute布局：右栏固定主内容自适应](http://demo.doyoe.com/css/margin/layout/absolute-margin-2.html)

### 主内容优先显示

可以更Cool一点，你觉得呢？很多时候，你也许会考虑到，不论在何种情况下，总想保证主要的内容优先于次要的内容呈现给用户，那么，怎么做？

很简单，只需要将主要内容的HTML排在次要内容的HTML之前即可，因为它是顺序加载渲染的。我们可以这样：

### HTML

    <header id="hd">头部</header>
    <div id="bd">
        <div id="main">主内容栏自适应宽度</div>
        <aside id="aside">侧边栏固定宽度</aside>
    </div>
    <footer id="ft">底部</footer>

是的，我们只需要将 `#main` 的HTML挪到 `#aside` 的HTML前面，令人兴奋的是，改变HTML之后，CSS不需要做任何改变。我们来看 `DEMO3`: [margin+absolute布局：左栏固定主内容自适应，主内容有限显示](http://demo.doyoe.com/css/margin/layout/absolute-margin-3.html)

当然，调正列顺序的 `DEMO4`: [margin+absolute布局：右栏固定主内容自适应，主内容有限显示](http://demo.doyoe.com/css/margin/layout/absolute-margin-4.html) 也同样简单，我们只需要写HTML时注意一下即可。

### 致命缺陷

列举了 `absolute+margin` 布局的很多优点，但只说一个问题，就足以让你在是否选用这种方式时深思熟虑，是什么呢？

我们知道 `absolute` 是定位流，脱离正常排版，也就是说绝对定位元素不影响其上下文的排版方式，你意识到我想说什么了么？

OK，用代码来演示：

### HTML

    <header id="hd">头部</header>
    <div id="bd">
        <div id="main">主内容栏自适应宽度</div>
        <aside id="aside">侧边栏固定宽度，我的内容可能比主内容多，高度比主内容栏高</aside>
    </div>
    <footer id="ft">底部</footer>

看完代码，估计你猜到了。是的，`#aside` 无法撑开父元素的高度，它将会溢出父元素区域，结果如下图：

![classsic layout](http://demo.doyoe.com/css/margin/images/layout-2.png)（图二）

来看看这缺陷所导致的情况 `DEMO5`: [margin+absolute布局的致命缺陷](http://demo.doyoe.com/css/margin/layout/absolute-margin-5.html)

此时假设你设置父元素 `overflow:hidden` 那么溢出部分将会被裁减，同样不符合布局意图，无法可破。所以在内容量不可控的场景，不推荐使用这种方式。

## float + margin 方式

和 `absolute + margin` 方式一样，`float + margin` 方式一样是经典的利用来布局的方案，并且被更广泛使用。我们仍然以 `图一` 为例，来看代码：

### HTML

    <header id="hd">头部</header>
    <div id="bd">
        <aside id="aside">侧边栏固定宽度</aside>
        <div id="main">主内容栏自适应宽度</div>
    </div>
    <footer id="ft">底部</footer>

### CSS

    #aside{
        float:left;
        width:200px;
    }
    #main{
        margin-left:210px;
    }

如上述代码，我们使用了 `float`，即从图文环绕形态演变而来。当 `#aside` 定义了 `float`，那么紧随其后的元素将会环绕在其周围。不过环绕并不是我们想要的结果，我们想要的是 '#main' 也自成封闭矩形，所以利用 `margin` 留出足够 `#aside` 显示的空间，中断环绕即可。

当然，此时 `#main` 也是自适应宽度的，来看具体实例 `DEMO6`: [margin+float布局：左栏固定主内容自适应](http://demo.doyoe.com/css/margin/layout/float-margin.html)

它是否也具备可任意调整列顺序的特点？何不一试？

### CSS

    #aside{
        float:right;
        width:200px;
    }
    #main{
        margin-right:210px;
    }


看过 `DEMO7`: [margin+float布局：右栏固定主内容自适应](http://demo.doyoe.com/css/margin/layout/float-margin-2.html)，你会发现，是的，这种方式也支持任意调整列顺序，很棒。

从这种趋势看来，貌似 `float + margin` 的方式会成为黑马，不过遗憾的告诉你，这种方式无法支持主内容优先显示。但我们有更Cool的解决方案。

## float + 负margin 方式

接下来我要说的大家可能都猜到了，对，经典的圣杯布局。至于圣杯的名字由来，大家可以自行Google，这里不做赘述。

恩，HTML当然是使用主内容优先显示的那种：

### HTML

    <header id="hd">头部</header>
    <div id="bd">
        <div id="main">主内容栏自适应宽度</div>
        <aside id="aside">侧边栏固定宽度</aside>
    </div>
    <footer id="ft">底部</footer>

### CSS

    #bd{
        padding-left:210px;
    }
    #aside{
        float:left;
        position:relative;
        left:-210px;
        width:200px;
        margin-left:-100%;
    }
    #main{
        float:left;
        width:100%;
    }

如上代码，既是圣杯布局的核心Code，如果你看懂了，你会发现，这其实很简单，不是么？

简单解释一下上面的CSS Code，首先我们是在做一个左侧固定宽度，右侧自适应宽度的布局。我们说过要让块级元素在同行显示的条件：改变显示方式，改变流方式，这里我们选择了使用 `float` 来将 `#main` 和 `#aside` 变成浮动流。

OK，这时我们具备 `#main` 和 `#aside` 能在同行显示的前置条件。我们知道，浮动元素其宽度如果没有显式定义，则由其内容决定。正好，`#aside` 是定宽的，所以显示给它定义 `width:200px`，但此时 `#main` 该怎么办？不设置 `width` 不对，因为宽度将被内容左右，设置 `width:100%` 也不对，因为这样的话，就没有 `#aside` 的立足之地了，正确的应该是 `width: calc(100% - 200px)`，不是么？可惜，这是新特性，只好作罢。

变通？是的，有的时候稍微换个思路，你会觉得豁然开朗。

`#main` 不是要自适应吗？那就给它个 `100%`，怎么做？我们在包含块 `#bd` 中就将 `#aside` 的宽度刨除，宽度全部都给 `#main`。恩，我们只需要这样 `#bd{padding-left:210px;}` （10px仍然是用来做间隙的），这时 `#main` 就可以设置 `width:100%` 了，由于 `#bd` 设置了 `padding`，所以已在左边预留出了一块宽 `210px` 的区域。此时的问题在于如果将 `#aside` 挪到这个地方，你想对了，我们是在聊 `负margin` 布局，自然需要利用上。

`#aside{margin-left:-100%;}` 这样可以了吗？很明显，这样还不行，此时 `#aside` 和 `#main` 的起始位置将会重合，因为 `#aside` 的 `margin-left` 计算值是相对包含块来计算的，而此时包含块的宽度等于 `#main` 的宽度。

如何让 `#aside` 再向左偏移 `210px`？显然 `margin` 是不行了，因为我们已经用掉它了。如果你看过之前的文章的话，你可能还记得，有一篇文章讲 [margin系列之与相对偏移的异同](http://blog.doyoe.com/~posts/css/2013-12-02-margin%E7%B3%BB%E5%88%97%E4%B9%8B%E4%B8%8E%E7%9B%B8%E5%AF%B9%E5%81%8F%E7%A7%BB%E7%9A%84%E5%BC%82%E5%90%8C.md)。恩，是的，这时我们可以借助相对偏移。

向左偏移 `210px` 是件很简单的事：`#aside{position:relative;left:-210px;}`。

至此，你的布局OK了，这就是圣杯的实现方式。来看已实现好的示例 `DEMO8`: [圣杯：左栏固定主内容自适应](http://demo.doyoe.com/css/margin/layout/holy-grail.html)

当然，圣杯布局必须可以任意调整列顺序，要不，怎么能说是更Cool些的方案呢？

### CSS

    #bd{
        padding-right:210px;
    }
    #aside{
        float:left;
        position:relative;
        right:-210px;
        width:200px;
        margin-left:-200px;
    }
    #main{
        float:left;
        width:100%;
    }

这个就直接看示例好了，不再一一解释代码 `DEMO9`: [圣杯：右栏固定主内容自适应](http://demo.doyoe.com/css/margin/layout/holy-grail-2.html)

所以圣杯布局具备前两种方式共同的优点，同时没有他们的不足，但圣杯本身也有一些问题，在IE6/7下报废，不过不用慌，因为它可被修复。

你想到方法了吗？


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