title: margin系列之内秀篇（二）
date: 2013-12-14 11:15:00
categories: CSS
tags: [margin, w3c, margin应用]
---

## 可挖掘性

之前已经写过一篇关于 `margin` 应用场景的文章：[margin系列之内秀篇](hhttp://blog.doyoe.com/~posts/css/2013-12-06-margin%E7%B3%BB%E5%88%97%E4%B9%8B%E5%86%85%E7%A7%80%E7%AF%87.md)，当然，它的应用场景会远大于文中所述，无法一一列举。

所以本篇权当是对此的补遗好了，各位客官如有比较Cool的想法都可以留言给我，我会视情况补丁进来。

## 1像素圆角

<!--more-->

这有什么好聊的吗？`border-radius` 瞬间可将之秒杀。恩，有的时候你不得不承认CSS3真是一把大杀器。不过当年我们是怎么做的？（会暴露年龄么？）

先看看我们要做什么,`图一`：

![1px圆角](http://demo.doyoe.com/css/margin/images/radius.png)（图一）

如上图一，我们会这样写：

### HTML

    <div id="demo">
        <a href="?"><span>1px圆角</span></a>
        <a href="?"><span>确定</span></a>
        <a href="?"><span>取消</span></a>
    </div>

### CSS

    #demo a,#demo span{
        display:inline-block;
        vertical-align:top;
    }
    #demo span{
        margin:1px -1px; /* 关键规则 */
    }

一条CSS规则我们就可以实现1px圆角，你信吗？来看`DEMO1`：[margin实现1px圆角](http://demo.doyoe.com/css/margin/radius.htm)

看到`DEMO1`的结果后，你会发现我们确实做到了1px圆角，很简单，有木有？在没有 `border-radius` 的年代，我们也很欢乐。

看到Code后，我想应该不用太解释为什么可以实现？

BTW，多像素圆角也可以参考这种方式来实现，如果你实在不想用图片的话。

## 已知宽高元素水平垂直居中

必须说，这是一个非常典型的 `margin` 应用，虽然如今看起来貌似使用场景不是太大，但还是好多人喜欢在面试时对人问起，我偶尔也会，但不多。

假设一个宽300px，高300px的盒子要在整个页面中水平垂直居中，我们可以这样做：

### HTML

    <div id="demo">这是一个水平垂直居中的容器</div>

### CSS

    #demo{
        position:absolute;
        top:50%;
        left:50%;
        width:300px;
        height:300px;
        margin-top:-150px;
        margin-left:-150px;
    }

恩，是的，借助绝对定位。我们先来看看 `DEMO2`：[margin实现已知宽高元素水平垂直居中](http://demo.doyoe.com/css/margin/alignment.htm)

先通过 `top/left` 将 `#demo` 的绝对定位流起始位置设置为当前屏的中心点，此时 `#demo` 的左上角这个点其实已经是相对于页面水平垂直居中了，由于它的宽度和高度都是300px，所以从起始位置向右下各延伸300px后才是整个 `#demo` 的真正位置。此时整个 `#demo` 其实并不是水平垂直居中的，除非我们将 `#demo` 的中心点放在当前屏的中心点上。怎么做？

这时我们就需要使用 `margin` 了，在 [margin系列之与相对偏移的异同](http://blog.doyoe.com/~posts/css/2013-12-02-margin%E7%B3%BB%E5%88%97%E4%B9%8B%E4%B8%8E%E7%9B%B8%E5%AF%B9%E5%81%8F%E7%A7%BB%E7%9A%84%E5%BC%82%E5%90%8C.md) 这篇文章里，我们就说过 `margin` 是以自身作为参照物进行位置偏移的。所以我们只需要将 `#demo` 相对自身向上偏移150px，向左偏移150px，就能够实现将自身的中心点放在当前屏的中心点上，也就实现了自身在当前屏的水平垂直居中。

为什么代码里是 `-150px` ？好吧，如果用 `margin-top` 来实现向上偏移，必须是负值，不是么？如果是正值的话，就是向下偏移了，其实也相当于是 `margin-bottom` 的正值， `margin-left` 亦然，我们在 [margin系列之与相对偏移的异同](http://blog.doyoe.com/~posts/css/2013-12-02-margin%E7%B3%BB%E5%88%97%E4%B9%8B%E4%B8%8E%E7%9B%B8%E5%AF%B9%E5%81%8F%E7%A7%BB%E7%9A%84%E5%BC%82%E5%90%8C.md) 文章最后同样说过这个。基础知识很重要，有木有？

## tabstrip底边线重合

先上个需求，如 `图二`：

![tabstrip底边线重合](http://demo.doyoe.com/css/margin/images/tab.png)（图二）

看到 `图二` ，我想大家可能知道可能知道要做什么了。

对，我们要做的就是 tab 项与底边线重合，这应该是我们常见的场景了，`margin` 仍然是最佳选择。先来看代码：

### HTML

    <div id="demo">
        <a href="?">分类一</a>
        <a href="?" class="on">分类二</a>
        <a href="?">分类三</a>
        <a href="?">分类四</a>
    </div>

### CSS

    #demo{
        border-bottom:1px solid #aaa;
    }
    #demo a{
        display:inline-block;
        margin-bottom:-1px;
        border:1px solid #aaa;
    }
    #demo .on{
        border-bottom-color:#fff;
    }

要实现 `tab` 中各项与包含块的底边线重合，重点在于将包含块的底边线向上偏移1px，这样就与 `tab` 各项的底部重合在一起。

怎样可以做到让包含块底边线向上偏移1px？恩，`margin` 是那么的顺其自然。我们只需要将 `tab` 各项的 `margin-bottom` 设置为 -1px 即可，其本身高度不变，但包含块底部会向上1px。

来看看具体实现的例子 `DEMO3`：[tabstrip底边线重合](http://demo.doyoe.com/css/margin/tab.htm)

## 双重边线

实际场景可能比这会稍复杂一些，我们看个大概即可，主要是拓宽一下思路，来看 `图三`：

![多重边线](http://demo.doyoe.com/css/margin/images/double-lines.png)（图三）

从图三中，我们可以看到每行都会有一个双色的边线，这就是我们要做的，HTML代码大约是这样：

### HTML

    <div id="demo">
        <ul>
            <li>这是一个双重边线的示例</li>
            <li>这是一个双重边线的示例</li>
            <li>这是一个双重边线的示例</li>
            <li>这是一个双重边线的示例</li>
        </ul>
    </div>

怎么做？恩，我们可以用常规的方式来解决，比如完全使用 `border` ：

### CSS Case1

    #demo li{
        border-top:1px solid #fff;
        border-bottom:1px solid #ccc;
    }

结果出来后，我们会发现最顶部多出了一条线，同时最底部又少了一条线。当然，这都可以被解决，我们可以让 `ul` 来辅助完成，例如让其 负margin-top + border-bottom，不过如果 `ul` 或者其父元素有垂直方向 `padding` 的话，处理起来可能会稍显蛋疼。

还有其他解？当然，会有的，来看：

### CSS Case2

    #demo ul{
        overflow:hidden;
        background:#fff;
    }
    #demo li{
        margin-bottom:1px;
        border-bottom:1px solid #ccc;
        background:#eee;
    }

是的，选择 `margin` 作为实现手段。以 `ul` 的底色配合 `margin` 模拟出线条的外观，这其实也挺讨人喜欢的，不是么？看具体实现 `DEMO4`：[双重边线](http://demo.doyoe.com/css/margin/double-lines.htm)

`margin` 模拟边线还可以做什么？比如做个表格神马的，看看 `DEMO5`：[margin模拟表格边线](http://demo.doyoe.com/css/margin/table.htm)


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