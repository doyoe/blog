title: 移动前端第二弹：善用meta
date: 2015-10-20 16:00:11
author: 杜瑶
categories: mobile
tags: [HTML5, meta, meta大全, meta列表]
---

## 前言

在[移动前端第一弹：viewport详解](/2015/10/13/mobile/移动前端第一弹：viewport详解/)中，我们讲了`viewport`，那是一个关于`meta`的故事。这次我们会就将`meta`这个故事讲得更广阔、更有意思一些。

写过`HTML`的童鞋，应该都对这个不陌生，或用它来定义页面编码，或用它来定义搜索引擎抓取方式，或用它定义页面关键字，描述等等。

## meta列表

好的`meta`使用，能更好地提高页面的可用性及被检索的几率。

这里并不会列出所有的`meta`使用方式，只挑选一些常用及实际意义比较大的讲讲，当然也包括一些厂商私有定制的。

<!--more-->

### 常规

#### 声明文档使用的字符编码
```
<meta charset="utf-8" />
```
该声明用来指定文档的编码，除了`utf-8`，可选值还有：ISO-8859-1、BIG5、iso-8859-2, iso-2022-jp, iso-2022-kr, gb2312等

当然，你可能还见过使用另外一种方式来定义文档字符编码：
```
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
```
相对于这种方式，更推荐你使用第1种，言外之意，就是推荐使用`HTML5`。


#### 声明页面刷新或跳转
```
<meta http-equiv="refresh" content="10" />
<meta http-equiv="refresh" content="10; url=http://www.doyoe.com" />
```
该声明用来指定页面自刷新或者跳转到其它页面，其中的时间单位是`s`。


#### 声明页面过期时间
```
<meta http-equiv="expires" content="0" />
<meta http-equiv="expires" content="Wed, 26 Feb 1997 08:21:57 GMT" />
```
该声明用来指定页面的过期时间，一旦网页过期，从服务器上重新请求，其中时间必须使用`GMT`格式，或者直接是`0`（即不缓存）


#### 声明页面是否缓存
```
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
```
上述语句都可以用来指定文档不被缓存。一些仍然在使用HTTP/1.0的可以使用第1条，第2条由HTTP/1.1提供，常用值还有：public, no-cache, no-store等



#### 声明作者信息
```
<meta name="author" content="joy, dooyoe@gmail.com" />
```


#### 声明文档关键字
```
<meta name="keywords" content="CSS, HTML, JavaScript, 前端" />
```
多关键字之间以半角逗号分隔


#### 声明文档描述
```
<meta name="description" content="这是一份meta列表" />
```
文档描述内容最好是完整的一句话，以不超过50个字符为宜


#### 声明使用的浏览器及版本
`x-ua-compatible`设置是从`IE8`开始增加的（很明显，只适用于IE），对于过往的版本无法识别。
开发者可以通过设置`x-ua-compatible`来指定渲染引擎的类型和版本，并且因为需求不同可以有多种不同的设置：

##### Case1:
```
<meta http-equiv="x-ua-compatible" content="IE=7" />
<meta http-equiv="x-ua-compatible" content="IE=4" />
<meta http-equiv="x-ua-compatible" content="IE=xx" />
<meta http-equiv="x-ua-compatible" content="IE=50" />
```
当直接指定`content`为`IE的某个具体版本`，如上述代码第1条，客户端的IE将会使用IE7.0标准模式对页面进行渲染，并忽略Doctype定义。
**当指定的IE版本在客户端IE中不存在时，IE将会尝试将该值转换为最为接近的版本。**
例如指定一个错误的或者低于5.0的IE版本，如上述代码第2，3条，客户端的IE将会使用IE5.0对页面进行渲染，由于IE5.0并没有标准模式，所以将会直接使用`quirks mode`来渲染；
如果指定一个大于客户端IE的版本，如上述代码第4条，假定客户端IE的最高版本为9.0，那么IE会将该值转换为`IE=9`，即使用IE9.0标准模式对页面进行渲染。

##### Case2:
```
<meta http-equiv="x-ua-compatible" content="IE=EmulateIE7" />
```
当指定的`content`值加了`Emulate`前缀时，如上述代码，客户端IE将会根据Doctype定义来决定如何来对页面进行渲染。假设页面使用了标准的Doctype，那么此定义效果等同`Case1`；假设页面并没有使用标准的Doctype，那么将使用`quirks mode`来渲染。

##### Case3:
```
<meta http-equiv="x-ua-compatible" content="IE=Edge" />
```
当指定的`content`值为`IE=Edge`时，如上述代码，客户端的IE将会使用最高的标准模式对页面进行渲染。

##### Case4:
```
<meta http-equiv="x-ua-compatible" content="IE=7, 10, 11" />
```
当指定的`content`值有多个版本时，如上述代码，假定客户端IE版本为8.0或者9.0，则使用IE7.0标准模式对页面进行渲染；假定客户端IE版本为10.0或者11.0，则直接使用对应版本的标准模式对页面进行渲染。

##### Case5:
```
<meta http-equiv="x-ua-compatible" content="IE=Edge, chrome=1" />
```
当指定的`content`值为`IE=Edge, chrome=1`时，如上述代码，假定客户端安装了`Google Chrome Frame`，则在IE中使用chrome的渲染引擎来渲染页面，否则，将会使用客户端IE最高的标准模式对页面进行渲染。


#### 声明搜索引擎抓取方式
```
<meta name="robots" content="index" />
```
通知搜索引擎文档是否需要被索引。可选值有：

* all（默认值，索引当前页并跟踪链接，相当于：index, follow）
* none（忽略当前页，相当于：noindex, nofollow）
* index（索引当前页）
* noindex（不索引当前页）
* follow（跟踪当前页链接，不论当前页是否被索引）
* nofollow（不跟踪当前页链接，不论当前页是否被索引）

如果声明冲突，某些引擎可能会做严格处理：
```
<meta name="robots" content="noindex" />
<meta name="robots" content="index" />
```
类似上述代码，在`Google`引擎中，会执行`noindex`这个更为严格的声明。

需要注意的是并不是所有搜索引擎都支持`robots meta`，比较保守的做法是配合`robots.txt`使用。


#### 声明搜索引擎抓取间隔
```
<meta name="revisit-after" content="10 days" />
```
有时候你可能并不希望站点一直被搜索引擎抓取，而是每间隔一段时间才来访问一次，这时，可以声明`revisit-after meta`。

### 移动

#### 声明viewport视口
```
<meta name="viewport" content="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no" />
```
该声明用于指定在移动设备上页面的布局视口如何设置。对于`viewport meta`的详细设置，请参考：[移动前端第一弹：viewport详解](/2015/10/13/mobile/移动前端第一弹：viewport详解/)


#### 声明添加到主屏幕的Web App标题
`iOS Safari`允许用户将一个网页添加到主屏幕然后像`App`一样来操作它。我们知道每个`App`下方都会有一个名字，`iOS Safari`提供了一个私有的`meta`来定义这个名字，代码如下：
```
<meta name="apple-mobile-web-app-title" content="Web App名称" />
```
`Android Chrome31.0`，`Android Browser5.0`也开始支持添加到主屏幕了，但并没有提供相应的定义标题的方式，所以如果你想统一`iOS`和`Android`平台定义`Web app`名称的方式，可以使用`title`标签来定义，代码如下：
```
<title>Web App名称</title>
```
但如果你想要网页标题和App名字不一样的话，那就只有iOS才行。


#### 声明添加到主屏幕时隐藏地址栏和状态栏（即全屏）
当我们将一个网页添加到主屏幕时，会更希望它能有像`App`一样的表现，没有地址栏和状态栏全屏显示，代码如下：
```
<meta name="apple-mobile-web-app-capable" content="yes" />
```
该方案在 `iOS` 和 `Android5.0+` 上都通用。


#### 声明添加到主屏幕时设置系统顶栏颜色
当我们将一个网页添加到主屏幕时，还可以对 `系统显示手机信号、时间、电池的顶部状态栏` 颜色进行设置，前提是开启了：
```
<meta name="apple-mobile-web-app-capable" content="yes" />
```
有了这个前提，你可以通过下面的方式来进行定义：
```
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
```
content只有3个固定值可选：default | black | black-translucent

* 如果设置为 `default`，状态栏将为正常的，即白色，网页从状态栏以下开始显示；
* 如果设置为 `black`，状态栏将为黑色，网页从状态栏以下开始显示；
* 如果设置为 `black-translucent`，状态栏将为灰色半透明，网页将充满整个屏幕，状态栏会盖在网页之上；

该设置只在 `iOS` 上有效。


#### 电话号码识别
在 `iOS Safari` （其他浏览器和Android均不会）上会对那些看起来像是电话号码的数字处理为电话链接，比如：

* 7位数字，形如：1234567
* 带括号及加号的数字，形如：(+86)123456789
* 双连接线的数字，形如：00-00-00111
* 11位数字，形如：13800138000

可能还有其他类型的数字也会被识别，但在具体的业务场景中，有些时候这是不必须的，所以你可以关闭电话自动识别，然后在需要拨号的地方，开启电话呼出和短信功能。

1. 关闭电话号码识别：
```
<meta name="format-detection" content="telephone=no" />
```

2. 开启拨打电话功能：
```
<a href="tel:123456">123456</a>
```

3. 开启发送短信功能：
```
<a href="sms:123456">123456</a>
```


#### 邮箱地址识别
在 `Android` （iOS不会）上，浏览器会自动识别看起来像邮箱地址的字符串，不论有你没有加上邮箱链接，当你在这个字符串上长按，会弹出发邮件的提示。

1. 关闭邮箱地址识别：
```
<meta name="format-detection" content="email=no" />
```

2. 开启邮件发送：
```
<a href="mailto:dooyoe@gmail.com">dooyoe@gmail.com</a>
```

3. 如果想同时关闭电话和邮箱识别，可以把它们写到一条 meta 内，代码如下：
```
<meta name="format-detection" content="telephone=no,email=no" />
```


## 附注

部分`meta`定义来自于[trip](https://github.com/doyoe/trip)