title: 移动前端第一弹：viewport详解
date: 2015-10-13 13:00:11
author: 杜瑶
categories: mobile
tags: [HTML5, viewport, meta]
---

## 前言

这次想聊聊移动开发相关的事。是的，你没有看错，一句话就可以开始你的移动前端开发。

你心里一定在想，什么话这么酷，能够瞬间带入到移动前端开发的世界。

但其实它一点也不新奇，不复杂。

## viewport简介

没错，就是`viewport`特性，一个移动专属的`Meta`值，用于定义视口的各种行为。

该特性最先由`Apple`引入，用于解决移动端的页面展示问题，后续被越来越多的厂商跟进。

举个简单的例子来讲为什么会需要它：

我们知道用户大规模使用手机等移动设备来进行网页浏览器，其实得益于智能手持设备的兴起，也就是近几年的事。（还记得不久前的几年，满大街都还是诺基亚的天下么？）

这时有一个很现实的问题摆在了厂商面前，用户并不能很好地通过手机等设备访问网页，因为屏幕太小。

<!--more-->

### layout viewport

`Apple`也发现了这个问题，并且适时的出现，它提出了一个方案用来解决这个问题。在iOS Safari中定义了一个`viewport meta`标签，用来创建一个虚拟的`布局视口（layout viewport）`，而这个视口的分辨率接近于PC显示器，`Apple`将其定义为`980px`（其他厂商各有不同①）。

这就很好的解决了早期的页面在手机上显示的问题，由于两者之间的宽度趋近，CSS只需要像在PC上那样渲染页面就行，原有的页面结构不会被破坏。

> ①的描述大致如下，数值不一定持续准确，厂商可能更改，但这个绝对值其实并非特别重要：
> iOS, Android基本都是: 980px
> BlackBerry: 1024px

### visual viewport

有了`layout viewport`，我们还需要一个视口用来承载它，这个视口可以简单的认为是手持设备物理屏幕的可视区域，我们称之为`（视觉视口）visual viewport`。这是一个比较直观的概念，因为你能看得见你的手机屏幕。

对于`visual viewport`，开发者一般只需要知道它的存在和概念就行，因为无法对它进行任何设置或者修改。很明显，`visual viewport`的尺寸不会是一个固定的值，甚至每款设备都可能不同。大致列几种常见设备的`visual viewport`尺寸：

* iPhone4~iPhone5S: 320*480px
* iPhone6~iPhone6S: 375*627px
* iPhone6 Plus~iPhone6S Plus: 414*736px

以`iPhone4S`为例，会在其320px②的`visual viewport`上，创建一个宽`980px`的`layout viewport`，于是用户可以在`visual viewport`中拖动或者缩放网页，来获得良好的浏览效果；布局视口用来配合CSS渲染布局，当我们定义一个容器的宽度为`100%`时，这个容器的实际宽度是`980px`而不是`320px`，通过这种方式大部分网页就能以缩放的形式正常显示在手机屏幕上了。

> ②的描述大致如下：
> 早期移动前端开发工程师常能见到宽640px的设计稿，原因就是UI工程师以物理屏幕宽度为320px的`iPhone4-iPhone5S`作为参照设计；
> 当然，现在你还可能会见到750px和1242px尺寸的设计稿，原因当然是iPhone6的出现

当然，为了更好的适配移动端或者只为移动端设计的应用，单有布局视口和视觉视口还是不够的。

### ideal viewport

我们还需要一个视口，它类似于布局视口，但宽度和视觉视口相同，这就是完美视口（ideal viewport）。

有了完美视口，用户不用缩放和拖动网页就能够很好的进行网页浏览。而完美视口也是通过`viewport meta`的某种设置来达到。

说了这么一大堆的东西，貌似都和`viewport`有关联，那么`viewport`到底怎么搞，请继续往下。

> 关于3个视口，[PPK](http://www.quirksmode.org/)已经做了非常棒的阐释，你也可以在`StackOverflow`上找到一些对此描述的相互补充，例如：[[1]](http://stackoverflow.com/questions/6333927/difference-between-visual-viewport-and-layout-viewport), [[2]](http://stackoverflow.com/questions/7344886/visual-viewport-vs-layout-viewport-on-mobile-devices)，有兴趣的童鞋也可以看看

## viewport特性

通常情况下，`viewport`有以下6种设置。当然厂商可能会增加一些特定的设置，比如iOS Safari7.1增加了一种在网页加载时隐藏地址栏与导航栏的设置：`minimal-ui`，不过随后又将之移除了。

Name|Value|Description
---|---|
width|正整数或`device-width`|定义视口的宽度，单位为像素
height|正整数或`device-height`|定义视口的高度，单位为像素
initial-scale|[0.0-10.0]|定义初始缩放值
minimum-scale|[0.0-10.0]|定义缩小最小比例，它必须小于或等于maximum-scale设置
maximum-scale|[0.0-10.0]|定义放大最大比例，它必须大于或等于minimum-scale设置
user-scalable|yes/no|定义是否允许用户手动缩放页面，默认值yes

### width

`width`被用来定义`layout viewport`的宽度，如果不指定该属性（或者移除`viewport meta`标签），则`layout viewport`宽度为厂商默认值。如：iPhone为`980px`；

举个例子：

```
<meta name="viewport" content="width=device-width" />
```

此时的`layout viewport`将成为`ideal viewport`，因为`layout viewport`宽度与设备视觉视口宽度一致了。

除了`width`之外，还有一个属性定义也能实现`ideal viewport`，那就是`initial-scale`。

### height

与`width`类似，但实际上却不常用，因为没有太多的use case。

### initial-scale

如果想页面默认以某个比例放大或者缩小然后呈现给用户，那么可以通过定义`initial-scale`来完成。

`initial-scale`用于指定页面的初始缩放比例，假定你这样定义：

```
<meta name="viewport" content="initial-scale=2" />
```

那么用户将会看到2倍大小的页面内容。

在说`width`的时候，我们说到`initial-scale`也能实现`ideal viewport`，是的，你只需要这样做，也可以得到完美视口：

```
<meta name="viewport" content="initial-scale=1" />
```

### maximum-scale

在移动端，你可能会考虑用户浏览不便，然后给予用户放大页面的权利，但同时又希望是在一定范围内的放大，这时就可以使用`maximum-scale`来进行约束。

`maximum-scale`用于指定用户能够放大的比例。

举个例子来讲：

```
<meta name="viewport" content="initial-scale=1,maximum-scale=5" />
```

假设页面的默认缩放值`initial-scale`是`1`，那么用户最终能够将页面放大到这个初始页面大小的5倍。

### minimum-scale

类似`maximum-scale`的描述，不过`minimum-scale`是用来指定页面缩小比例的。

通常情况下，为了有更好地体验，不会定义该属性的值比`1`更小，因为那样页面将变得难以阅读。

### user-scalable

如果你不想页面被放大或者缩小，通过定义`user-scalable`来约束用户是否可以通过手势对页面进行缩放即可。

该属性的默认值为`yes`，即可被缩放（如果使用默认值，该属性可以不定义）；当然，如果你的应用不打算让用户拥有缩放权限，可以将该值设置为`no`。

使用方法如下：

```
<meta name="viewport" content="user-scalable=no" />
```

## 结语

正如开篇所说，这既不高深也不新奇，它而仅仅是一点观念转变。

当你掌握了`viewport`，那么意味着你已经大致了解了移动平台与PC平台的不同，你可以更专注而细致的去解决某些平台差异问题。