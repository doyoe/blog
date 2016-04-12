title: background系列之无处不在的妙趣
date: 2016-4-11 11:15:00
categories: CSS
author: 杜瑶
tags: [background, background-origin, gradient, w3c, CSS应用]
---

## 前言

上次和大家聊过 [background系列之你不知道的background-position](/2016/03/28/css/background系列之你不知道的background-position/)，向大家展示了里面的一些小细节和未被发掘出来的特征。应该说 `background` 是一个很有意思的东西，不仅实际使用的频度超高，而且处处充满着好玩的妙趣。

## 老需求

这里并不打算和大家聊所谓的最佳实践，更多的是希望可以通过一些示例激起大家更深层次的思考和探索欲。

<!--more-->

大家来看下面这个例子，应该算是`iOS`中的典型列表风格，如`图0`：

![图0：iOS风格列表](http://demo.doyoe.com/css3/background/skin/divider.png)

从`图0`我们能看到这个列表中每个子项都有一根底边线，假设子项高为`40px`，并且除了最后一根边线是全封闭的外，其余的边线都是非封闭型，距左侧有一定的空白间隙；需要注意的是，当某个子项被选中或激活时，其反馈区域是整行，未封闭区域的背景色也需要改变，如`图0`中的第4行效果所示。

我们来细化一下需求：

1. 每个子项都需要底边线；
2. 除了最后一根边线，其余边线都是非封闭的；
3. 子项被选中或激活时，响应区域为整行；

假设这就是我们现在的需求，你会如何实现呢？

## 老思路

我知道，通常来说，大家首先会想到的应该是`border`属性，然后配合`margin`来做这件事。

于是我们可能会这样来写HTML：

### HTML:
```html
<ul class="demo">
    <li>Lady gaga</li>
    <li>Mariah Carey</li>
    <li>Adele</li>
    <li>Avril Lavigne</li>
    <li>Sarah Brightman</li>
    <li>Celine Dion</li>
</ul>
```

为了实现需求第1点，CSS这样写：

### CSS:
```css
.demo li {
    border-bottom: 1px solid #ccc;
    line-height: 40px;
}
```

Cool，简直太简单了。然后我们又接着来实现第2点：

### CSS:
```css
.demo li {
    margin-left: 15px;
}
.demo li:last-child {
    margin-left: 0;
    padding-left: 15px;
}
```

第2点好像也没有想象中那么复杂，就是需要把代码写恶心点，重置最后一个子项的`margin-left`，并换用`padding-left`，但貌似也还可以接受，毕竟只有2行代码。

一鼓作气，我们需要继续把第3点也给做了，为了更好的理解，这里把`选中或激活`的状态用`经过`替代，其实是类似的，于是继续写：

### CSS:
```css
.demo li:hover {
    background-color: #f3f3f3;
}
```

迫不及待要看看这样写是否能符合预期了，如下`图1`：

![图1：方案1效果图](http://demo.doyoe.com/css3/background/skin/bad-divider.png)

开心的是，需求中的第1，2两点都做到了；难受的是，第3点没达成。从`图1`我们就能看到，响应区域除了最后一项外，其它的项都不是整行的。可以直接来观看这个例子， `Demo1` [使用border和margin做iOS风格列表](http://demo.doyoe.com/css3/background/border-divider.htm)

很明显，这个解决方案失败了。败在了`margin`区域无法承载`background`，因为`margin`永远是透明的，围绕在盒子之外。有兴趣的童鞋可以翻翻规范了解这些信息。

## 再出发

虽然说`方案1`有问题，但我们也知道了，如果是使用`margin`来做的间隙，那么将无法填充背景，而`padding`是可以的，那么这就可以作为下个方案的指导。

有了这样的指导，我们是不是可以考虑将内容的间隙和边线的间隙分开处理？内容仍然使用`padding`，边线额外处理，互不影响，避免出现`方案1`的情况。

不论怎样，我相信在大多数时候，你都不想为了达到某个效果，而增加层级。所以这里，不在之前`HTML`上做任何改变，那么要单独处理边线，我们就只能给它创造一个`伪元素`了。

于是我们又开始一一实现，首先，内容要有间隙：

### CSS:
```css
.demo li {
    padding-left: 15px;
    line-height: 40px;
}
```

接下来，每个子项都要有底边线。说好的`伪元素`，我们不能抛弃：

### CSS:
```css
.demo li::after {
    position: absolute;
    right: 0;
    bottom: 0;
    left: 0;
    border-bottom: 1px solid #ccc;
    content: "\0020";
}
```

我们还需要让出了最后一根边线外的其它边线距左侧有间隙：

### CSS:
```css
.demo li:not(:last-child)::after {
    left: 15px;
}
```

就剩最后一点了，来给它们加上响应反馈效果：

### CSS:
```css
.demo li:hover {
    background-color: #f3f3f3;
}
```

嗯，差不多了。貌似还差点，我们的边线的是绝对定位的，所以还需要给它的包含块加上定位：

### CSS:
```css
.demo li {
    position: relative;
}
```

这下看起来是处理得差不多了，让我们来瞧瞧实际的效果，如`图2`：

![图2：方案2效果图](http://demo.doyoe.com/css3/background/skin/pseudo-element-divider.png)

Good job! `方案2`完全实现我们的预期，可以看具体的示例：`Demo2` [使用伪元素做iOS风格列表](http://demo.doyoe.com/css3/background/pseudo-element-divider.htm)

## 精益求精

`方案2`虽然已经完全实现了需求，但我总是有点不太喜欢它。因为我发现，当内容的边距修改后，边线的边距也需要手动修改，问题就在于它们被分别处理了；而且代码居然超过10行了。

所以，如果我不想只要改变边距就得改2处地方，还是只能讲它们合起来处理，不再分开。这意味着`伪元素`不再是我们需要考虑的，包括`方案1`中的`margin`也要排除。

怎么办？貌似有点棘手了。

可能大家已经猜到我会把注意力放到`background`上了，毕竟好像这个系列讲的就是`background`，但不知道会不会猜到我准备怎么做。

## 旧酒新衣

用`background`做边线这样的方案，不少童鞋肯定遇上过，比如说：菜单之间的分隔竖线（当然，这个能用几十种方式来做），这个比较简单，或用背景图，或用伪元素承载背景色。

然后在当前这个需求背景下，这些方式都不适用了。显然，我不会在真实的背景图片方向去考虑这个问题，毕竟我懒嘛，并不想切图。

所以，我得打打渐变背景的主意了，大家知道我们其实是可以用渐变来画背景图像的。于是，我又开始写了，当然，`HTML`仍然不变：

### CSS:
```css
.demo li {
    padding-left: 15px;
    line-height: 40px;
    background: linear-gradient(#ccc, #ccc) no-repeat;
}
```

好了，内容的边距有了；渐变背景也有了（虽然是纯色的），但它不是线，不是线。得改改，我们是不是可以让渐变从透明渐变到边线的颜色呢？试试：

### CSS:
```css
.demo li {
    padding-left: 15px;
    line-height: 40px;
    background: linear-gradient(transparent 39px, #ccc 39px, #ccc) no-repeat;
}
```

我们让渐变背景从`transparent`渐变到`#ccc`，`transparent`区域占`39px`，剩下`1px`给`#ccc`。

事实上，这是可行的，运行结果如我所想，但我还要处理一下边线距左侧的边距问题和响应反馈：

### CSS:
```css
.demo li:not(:last-child) {
    background-position: 15px;
}
.demo li:hover {
    background-color: #f3f3f3;
}
```

搞定了，赶紧看下效果，如`图3`：

![图3：方案3效果图](http://demo.doyoe.com/css3/background/skin/gradient-background-divider.png)

结果确实正如我想，可以看具体的示例：`Demo3` [使用渐变背景做iOS风格列表](http://demo.doyoe.com/css3/background/gradient-background-divider.htm)

## 新的突破

通过`方案3`的实现可以发现使用渐变背景来做边线是完全可用性，只是它也并没有解决我想要的只改`1处`边距就同时处理了内容边距和边线边距。

所以就只能再改改了，再发掘发掘`background`的其他魅力。

我知道，`background`体系下有一个特性是用来控制背景图的渲染起始位置的，它可以根据设置，让背景图从`边框`，`内补白`或`内容`区域开始渲染。

是的，你想起了，它是`background-origin`。

因为最后一根边线是封闭的，无需再做任何处理了。但如果我们需要完成其它边线的边距随内容的边距变化而变化，那么就需要让边线从元素的`内补白`以内的区域开始渲染，即`内容`区域，于是我们这么改：

### CSS:
```css
.demo li:not(:last-child) {
    background-origin: content-box;
}
```

是的，就是这么一句简单的改动，我想要的都得到了。之后边线的边距将由内容的边距来决定，当我们将内容的边距改成`20px`时，边线的边距也将自动变成`20px`（当然，原因是因为背景图从元素的`content-box`区域开始渲染）。

看看我们新突破后的成果吧，如`图4`：

![图4：方案4效果图](http://demo.doyoe.com/css3/background/skin/gradient-background-divider.png)

这是属于我们共同的胜利，可以看具体的示例：`Demo4` [使用渐变背景和背景图起始位置做iOS风格列表](http://demo.doyoe.com/css3/background/gradient-background-divider2.htm)

这只是`background`趣味性的一个小点，后续应该会继续写一些。

## 写在最后

解决方案不是永远靠谱的，任何差异化的场景都不一定能复用以往的经验，但不停的探索是可以的，并且它是建立在扎实的基础上的。enjoy it.


## background系列文章：

* [background系列之无处不在的妙趣](/2016/04/11/css/background系列之无处不在的妙趣/)
* [background系列之你不知道的background-position](/2016/03/28/css/background系列之你不知道的background-position/)