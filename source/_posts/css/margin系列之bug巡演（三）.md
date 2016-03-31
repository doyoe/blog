title: margin系列之bug巡演（三）
date: 2013-12-20 11:15:00
categories: CSS
author: 杜瑶
tags: [margin, w3c, margin bug]
---

## IE8按钮margin auto居中失效Bug

你会猛然觉得，这是正解啊，因为 `button` 或者 `input type button类型` 的元素是 `inline-level` 的。

不对啊，`button` 应该是 `inline` 的吧？哦，可能是 `inline-block` ？

在这之前，我们似乎要先明确一些基础知识。

## 什么是 inline-level 元素？

<!--more-->

要知道 `inline-level` 元素并不等于 `inline` 元素，也就是说 `行内级元素` 与 `行内元素` 是两个不同的概念。

### `inline-level` 元素包含 `display` 值为：

* inline
* inline-block
* inline-table
* inline-flex
* other inline-*

以上情况时，元素可被称之为 `inline-level` 元素，但不都是 `inline` 元素。

## 什么是 block-level 元素？

`block-level` 指的是 `display` 值为 `block` 的元素吗？我知道不少人一直有这样的认知，不过这不完全准确。

### `block-level` 元素包含 `display` 值为：

* block
* list-item
* table
* table-*
* flex
* 如果position既不是static也不是relative、float不是none或者元素是根元素，当display:inline-table时，display的计算值为table；当display值为 inline | inline-block | run-in | table-* 时，display的计算值为block

有如上情况时的元素均被称之为 `block-level` 元素。同时 `block-level` 和 `block` 也不是同一个概念，所以如果你认为 `display` 值为 `list-item` 的 li 不是 块级元素，那就错了。

看到这里，你对 `块级元素`，`块元素`，`行内级元素`，`行内元素` 这个4个概念，应该已经有了比较清晰的了解？

## margin keyword auto只能应用在常规流中的 block-level 元素上

* 当一个块级元素定义了 `position` 值为非 `static` 和 `relative` 之外的值时，margin-right/left auto 的计算值为0；
* 当一个块级元素定义了 `float` 值为非 `none` 之外的值时，margin-right/left auto 的计算值为0；
* 非块级元素的margin-right/left auto 的计算值为0；

计算值为0，即说明其应用使用值的意图失败。所以在有如上情形的场景中，都无法使用 `auto` 来实现水平居中。同时也说明了，只有 `normal flow` 的 `block-level` 才能应用 margin keyword auto。

## margin可以应用于所有元素吗？

这显然不行。准确的说：margin可以应用在除某些table-*元素和某些行内元素之外的所有元素上。

### 和margin亲近的table-*系元素

* table
* inline-table
* table-caption

除了 `display` 值为以上3种之外的 `table系` 元素，都不能应用 `margin` ，比如：th, td。

### 和margin亲近的 inline-level 元素

我之前面试的时候常会问候选人，行内元素不能设置宽高对吗？大部分人会告诉我说是；然后我又会问，那为什么 `img` 元素可以设置宽高呢？有人会告诉我，因为 `img` 是个特殊的元素？接着我又会问题，`img` 是如何特殊的？然后，然后就没然后了，因为没声音了。

恩，`img` 确实是个特殊的元素。它特殊在哪里？它的特殊就在于它是一个行内置换元素。

所有的置换元素都可以设置 `margin` 属性，并且可以设置宽高，这就是为什么 `img` 是行内元素却可以设置 `width` 和 `height`。

### 什么是置换元素（Replaced elements）？

一个元素拥有内在的二维属性，其宽高属性受外部资源影响，默认拥有CSS格式，这样的元素被称为置换元素。

意思就是说置换元素的宽高不完全由CSS决定，还受其自身内容和外部资源所影响。

举个例子来说，仍然说 `img` 元素吧，你会发现，如果你 `src` 进来不同尺寸的资源，那么在 viewport 上显示的图片宽高也是不同的，也就是说 `img` 元素的宽高会受外部资源影响。

再说说 `input` 元素，随便在页面上扔一个input，你都能发现它拥有一个默认的宽高，这就是它所具有的内在二维宽高属性，并且该类元素会受UA影响，不同UA下所呈现外观会有不同。

### 常见的置换元素有哪些？

img, object, button, input, textarea, select等

### 行内非置换元素真的不能应用margin吗？

什么是非置换元素？除了置换元素之外的元素，我想将这样的元素称之为非置换元素是没有大碍的。

那么行内非置换元素真的无法设置 `margin` 吗？我想在工作中你一定碰到过很多这样的场景，给一个 `a` 或者 `span` 定义间隙。这时我们写：

### CSS

    span{margin:5px 10px;}

结果发现 `span` 的水平方向上的 `margin` 定义生效了，但垂直方向上的 `margin` 定义却没被应用。

是的，这就是行内非置换元素使用 `margin` 时的表征，所以对各种特性的理解，在让自己的代码更有效上是大有裨益的。

## 回归正题

我们本来是想说IE8按钮margin auto居中失效Bug的，扯了不少题外话。

我们知道 margin keyword auto 不能应用在处于常规流中的 block-level 之外的元素上，所以我有这样的一段代码：

### CSS

    button{display:block;margin:auto;}

### HTML
    <div id="demo">
        <button>按钮</button>
    </div>

恩，我们将 `button` 显式的转换为了 `block`，同时我们知道 `button` 作为置换元素，本身具备内在宽高，也就是说这时，我只需要加上 `margin:auto` ，该按钮就应该在其包含块里水平居中。

是的，所有浏览器都和预期是一样，实现了水平居中，但是却出现了奇葩的IE8，完全无效，甚至不如原始社会的IE6。来看看示例 `DEMO1`：[IE8按钮margin auto居中失效Bug](http://demo.doyoe.com/css/margin/bug/button-auto-margin-bug.html)

通过以上例子，你有没有突然感觉到，如果要让一个置换元素在包含块中水平居中，出乎预料的简单，只需要 `display:block;margin:auto;` 即可。

## 注意事项

令人意外的是，只有 `button` 和 input type 为 button 相关元素的时候，在IE8中才会水平居中失效；如: `input type text` 或 `img` 时，margin keyword auto 运作正常。

## 解决方案

* 给其显示的定义宽度
* 不改变其display值，包含块text-align:center
* 其它水平居中方案，如：absolute + 负margin


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