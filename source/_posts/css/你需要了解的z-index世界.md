title: 你需要了解的z-index世界
date: 2014-01-21 11:15:00
categories: CSS
tags: [z-index, w3c, 层叠上下文]
---

## z-index的重要性

在我看来，`z-index` 给了我们日常工作中以极大的帮助，我们用它来定义元素的层叠级别（stack level）。受益于它，你能做Popup, DropDown, Tips, 图文替换等等。

在开始本篇之前，或许我们要先了解一下关于z-index的基本信息。

## W3C这样描述

每个元素都具有三维空间位置，除了水平和垂直位置外，还能在 "Z轴" 上层层相叠、排列。元素在 "Z轴" 方向上的呈现顺序，由层叠上下文和层叠级别决定。

在文档中，每个元素仅属于一个层叠上下文。元素的层叠级别为整型，它描述了在相同层叠上下文中元素在 "Z轴" 上的呈现顺序。

同一层叠上下文中，层叠级别大的显示在上，层叠级别小的显示在下，相同层叠级别时，遵循后来居上的原则，即其在HTML文档中的顺序。

不同层叠上下文中，元素呈现顺序以父级层叠上下文的层叠级别来决定呈现的先后顺序，与自身的层叠级别无关。

<!--more-->

## z-index语法和应用

    z-index: auto | <integer>

`z-index` 接受的属性值为：关键字auto和整数，整数可以是负值（Firefox2.0及之前不支持负值）。

需要注意的是 `z-index` 虽然很给力，却只能应用于定位元素（即设置了 `position` 属性为非 `static` 值），其它情况下，`z-index` 将被忽略。

对于定位元素而言，`z-index` 意味着：

* 确定该元素在当前层叠上下文中的层叠级别。
* 确定该元素是否创建了一个新的局部层叠上下文。

## 创建层叠上下文

在规范中说明：当某个元素的 `z-index` 未显式定义或者被指定为 `auto` 时，该元素不会产生新的局部层叠上下文。也就是说它可以和兄弟，祖先，后辈元素处在同一个堆叠上下文中，它们被放在一起比较层叠级别，儿子可以盖住祖先，父亲也可以盖住儿子，儿子甚至可以越过祖先，盖住祖先的兄弟，在层叠上下文中，它们是并级的关系。来看这样一个例子 `DEMO1`: [z-index与创建层叠上下文](http://demo.doyoe.com/css/z-index/stacking-context.htm)

值得高兴的是，大部分浏览器都实现了这个特性；不过在IE6/7下，不论 `z-index` 值是否被显式定义，都将产生新的局部层叠上下文，也就是说子元素不可以越过是定位元素的父亲，子元素都处在新创建的局部层叠上下文中，只能在内部进行层叠级别的比较。

## 深入浅出

某区域内有个浮层提示或者下拉菜单，于是可能需要遮住该区域之下的区域。

### HTML

    <div class="a">
        ...
        <div class="tips">我是一个简陋的浮层提示</div>
    </div>
    <div class="b">
        ...
    </div>

### CSS

    .a{position:relative;}
    .tips{position:absolute;z-index:99;}

如上HTML/CSS代码，很显然，浮层 `tips` 将可以覆盖在其父级元素 `a` 的兄弟元素 `b` 之上。

于是你的意图得到实现，效果如下 `图一`：

![create stacking context](http://demo.doyoe.com/css/z-index/images/create-stacking-context.png)（图一）

这是具体的实现例子  `DEMO2`: [z-index实现元素层叠](http://demo.doyoe.com/css/z-index/create-stacking-context-normal.htm)。

不过很显然，从 `DEMO2` 来看，你依然无法准确的判断出在各浏览器下，`tips` 能盖住 `b` 是因为其父级的定位还是本身的定位。

但是我们可以做这样一个测试，我们让 `b` 也拥有定位，Code如下：

### CSS

    .a{position:relative;}
    .tips{position:absolute;z-index:99;}
    .b{position:relative;}

这段代码run完之后，就比较纠结了，你能得到的效果将会如下 `图二`：

![IE6/7 create stacking context bug](http://demo.doyoe.com/css/z-index/images/create-stacking-context-ie6-7-bug.png)（图二）

当然要给出具体实现 `DEMO3`: [验证创建局部层叠上下文](http://demo.doyoe.com/css/z-index/create-stacking-context-ie6-7-bug.htm)。

首先，我们来解读一下这个例子：因为 `a` 和 `b` 都是 `relative` 且没有定义 `z-index` （等同于z-index:auto），根据后来居上的原则，此时 `b` 的层叠级别是要高于 `a` 的，意思就是说 `a` 是无法遮住 `b` 的。不过从 `DEMO3` 中，我们看到 `a` 的子元素 `tips` 遮住了 `b`，这就表示 `tips` 能越过它，所以可以判断出 `a` 没有创建新的局部层叠上下文。很明显，这是完全吻合标准对此的定义。

不过这是在非IE6/7之下结果。在IE6/7下，我们看到 `tips` 并没能遮住 `b`，也就是说 `tips` 无法越过父级，因为 `a` 创建了新的局部层叠上下文，而 `a` 的层叠级别又比 `b` 低，所以 `tips` 无法遮住 `b`，这也就是在IE6/7下常出现覆盖Bug的根源。

结合 `DEMO2` 和 `DEMO3`，你能很肯定的得出以下结论：

* 当定位元素没有显式定义z-index值时，不会创建新的局部层叠上下文
* 子元素有可能和祖先的兄弟或者祖先兄弟的子元素处在同一个层叠上下文中

在实际工作中，有些情况可能是你没注意或者已然存在的。比如你事先可能并不知道 `b` 也是定位元素，或者由于某些原因，你需要将其设置为定位元素，于是可能出现各种兼容问题。如果你不了解 `z-index` 是如何创建局部层叠上下文，且又没注意到IE6/7的实现错误，那么处理起这样的问题将会让你深陷泥潭。

所以在实际的场景中，如果是为了相互覆盖而设置为定位，那么显式的定义 `z-index` 值，将可避免出现创建新局部层叠上下文差异。

如果需要越过祖先和其它区块内部元素进行相互层叠，那么考虑IE6/7的情况，也应该尽量避免给父级元素进定位。

## opacity与层叠上下文

我们知道 `opacity` 属性是用来设置元素不透明度的。但可能知道 `opacity` 和层叠上下文有关的不多，不过没关系，这里我们简单聊聊这个话题，有两点必须注意：

* 当opacity值小于1时，该元素会创建新的局部层叠上下文，也就是说它可以和定位元素进行层叠层别比较
* 当opacity值小于1时，该元素拥有层叠级别且相当于z-index:0或auto，但不能定义 z-index ，除非本身是定位元素

简单来说，当一个普通的元素定义了 `opacity` 的值小于1时（比如 opacity:.5），那么该元素的层叠级别将会高于普通元素，其效果类同于定位元素没有显式定义 `z-index` 的情况，唯一的区别是没有显式定义 `z-index` 的定位元素不会产生局部层叠上下文，而定义了 `opacity` 值小于1的元素会产生新的局部层叠上下文。

### opacity猜想

假定我们有 `a`, `b`, `c` 三个元素，它们相互层层覆盖在一起，如果这时将 `a` 元素定义为 `opacity:.8`，你知道结果会怎样吗？

### HTML

    <div class="a">a</div>
    <div class="b">b</div>
    <div class="c">c</div>

### CSS

    .a,.b,.c{width:100px;height:100px;}
    .a{opacity:.8;background:#999;}
    .b{margin:-70px 0 0 30px;background:#090;}
    .c{margin:-70px 0 0 60px;background:#f00;}

如果你看明白了我对于 `opacity` 与层叠上下文的描述，相信你可以猜到结果，是的，`a` 元素将会覆盖 `b` 和 `c` 元素，虽然它在HTML文档中出现在 `b` 和 `c` 之前，且不是定位元素。

必须看看具体的示例不是么？`DEMO4`: [opacity与局部层叠上下文猜想](http://demo.doyoe.com/css/z-index/create-stacking-context-by-opacity.htm)。

如果我们将 `b` 和 `c` 设置为定位元素，又将会如何呢？

### CSS

    .a,.b,.c{width:100px;height:100px;}
    .a{opacity:.8;background:#999;}
    .b{position:relative;margin:-70px 0 0 30px;background:#090;}
    .c{position:relative;margin:-70px 0 0 60px;background:#f00;}

不急，我们可以接着看示例 `DEMO5`: [opacity与局部层叠上下文猜想2](http://demo.doyoe.com/css/z-index/create-stacking-context-by-opacity-2.htm)。

从 `DEMO4` 和 `DEMO5` 两例，我们可以验证：当一个普通元素定义了 `opacity` 为小于1的值时，该元素将像定位元素一样拥有层叠级别，可以覆盖普通元素，并且其层叠级别与未显式定义 `z-index` 的定位元素一样。

### opacity创建局部层叠上下文

与未显式定义 `z-index` 的定位元素唯一不同的是 `opacity` 值小于1的元素会创建局部层叠上下文。

创建局部层叠上下文意味着什么，前文我们已经详述过。所以不再赘述，这里只给一个示例用以验证该特性。先奉上代码：

### HTML

    <div class="a">a
        <div class="d">d</div>
    </div>
    <div class="b">b</div>
    <div class="c">c</div>

### CSS

    .a,.b,.c,.d{width:100px;height:100px;}
    .a{opacity:.8;background:#999;}
    .b{position:relative;margin:-70px 0 0 30px;background:#090;}
    .c{position:relative;margin:-70px 0 0 60px;background:#f00;}
    .d{position:absolute;z-index:99;height:50px;background:#090;}

你可以先看看具体结果 `DEMO6`: [opacity创建新局部层叠上下文](http://demo.doyoe.com/css/z-index/create-stacking-context-by-opacity-3.htm)。

你会发现虽然 `a` 的子元素 `d` 将 `z-index` 定义为99，但 `d` 仍然无法遮住 `b` 和 `c` 元素，这是因为 `a` 创建了新的局部层叠上下文，`d` 元素无法超越父级。

需要注意的是，此时就算 `a` 元素变成了定位元素，也不能改变其会创建新局部层叠上下文的命运，因为他设置了 `opacity:.8`。

按照我们前文所说，如果 `a` 没有定义 `opacity:.8` ，但却像 `b` 和 `c` 元素一样设置了 `relative`，那么其子元素 `d` 将可以覆盖 `b` 和 `c`，至于这个例子就不再奉上了，大家随便写个测试一下即可。

## 图文替换

上述都是理论性的东西，相对枯燥，来个实际点的应用场景。

我们聊聊图文替换的事，相对于使用较广的方案如：缩进正/负值（正/负text-indent）、超小字体、margin溢出、padding溢出、line-height溢出、透明字体、display:none、visibility:hidden等方案而言，使用 `z-index` 负值的方案，有一些明显的优势：

* 无需考虑是否会有性能问题类同使用上述列举中的前几种方案（比如使用负缩进值-9999px，虽然此时文本被移到屏幕之外或者被裁减，但仍然会绘制一个宽9999px的盒子）；
* 没有像类似超小字体和透明字体一样的方案会需要一些额外的hack；
* 不像display:none方案那样有SEO欺骗嫌疑；
* 当图片加载失败时，可以显示文字；
* and etc...

先来看看一个图文替换的例子 `DEMO7`: [图文替换实例](http://demo.doyoe.com/css/z-index/back-top.htm)。

在不同的网络环境下，它的表现如下 `图三`：

![back top](http://demo.doyoe.com/css/z-index/images/back-top.png)（图三）

具体的Code很简单：

### HTML

    <a href="#top" title="回到顶部"><span>TOP▲</span></a>

### CSS

    a,a span{display:inline-block;width:38px;height:38px;}
    a{background:url(images/ico.png) no-repeat;}
    a:hover{background-position:0 -39px;color:#fff;}
    a span{position:relative;z-index:-1;background-color:#eee;}
    a:hover span{background-color:#999;}

你会发现我们将 span 设置为了 `z-index:-1`，此时它的层叠级别将比正常的元素还要低，所以它可以被其父元素超链接a盖住，从而在图片正常载入时显示父元素的背景图，在网络环境不好图片载入有问题时，显示自身。

很多时候，要实现一个需求可能有无数种解决方案，能够适应情况越多的方案毫无疑问会脱颖而出，这就要求我们可以去更多的思考，而不是更多的拷贝。