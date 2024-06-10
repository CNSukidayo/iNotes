* ## HTML模板:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 代码注释 -->
    <title>Document</title>
</head>
<body>
    
</body>
</html>
```
## 解释:
### `<!DOCTYPE html>`:向浏览器说明大当前使用的HTML版本是HTML5.那么浏览器就会按照HTML5的格式对HTML进行解析.
### `<html lang="en">`:规定元素内容的语言,这里指定的值是en
### `<meta charset="UTF-8">`:指定文档的字符集编码,这里指定的值是UTF-8
### `<!-- 注释代码 -->`:代码注释
- - - 
* ## `<head>`标签:
|    标签    |             描述             |
| :--------: | :--------------------------: |
|  `<head>`  |      定义关于文档的信息      |
| `<title>`  |         定义文档标题         |
|  `<meta>`  |   定义关于HTML文档的元数据   |
|  `<link>`  | 定义文档与外部资源之间的关系 |
| `<style>`  |      定义文档的样式信息      |
| `<script>` |        定义客户端脚本        |
</br>

* ## `<title></title>`:用来描述网页的标题

</br>

* ## `<meta>`标签:
|     属性     |                             值                              |                  描述                  |
| :----------: | :---------------------------------------------------------: | :------------------------------------: |
| `http-equiv` |         content-type、expires、refresh、set-cookie          |      把content属性关联到http头部       |
|    `name`    | author、description、可keywords、generator、revised、others |      把content属性关联到一个名称       |
|  `content`   |                        something...                         | 定义与http-equiv或那么属性相关的元信息 |

### `<meta charset="UTF-8">`:描述文档类型和字符编码信息.
### `<meta http-equiv="Content-Type" content="text/html;charset=utf-8">`:这是以前版本定义文档类型和字符编码信息的方式.
### `<meta name='keywords' content="软件学院,软件工程">`
### `<meta name='description' content="软件学院">`
### 这种实现的方式然为"名称/值"对的形式,keywords表示搜索关键字,description表示网络内容的具体描述,某些搜索引擎在遇到这些关键字时,会用这些关键字对文档进行分类.
### 所以`<meta>`标签的用法就是在`<head>`标签里指定多个meta标签,然后每个meta标签通过name(相当于key)描述当前meta表示的含义,而content(相当于value)是对当前的name赋予具体有意义的值.

* ## `<link>`标签:
### `<link>`标签用来定义文档与外部资源之间的关系,用于链接一个外部样式表.该标签位于`<head>`标签内部并可以出现任意次数.
### `<link rel="stylesheet" type="text/css" href="mystyle.css">`

* ## `<style>`标签:
### `<style>`用来定义样式文件,例如:
```html
<style type="text/css">
body {background-color:yellow}
</style>
```

* ## `<script>`标签:
### `<script>`标签用来定义客户端脚本,`<script>`标签既可以包含脚本语言,又可以通过src属性指向外部脚本文件.

* ## 块级标签:
### div等标签块级标签,它们的特点如下:
1. ### 前后断行显示,块级标签会占据一行.
2. ### 具有一定的宽度和高度可以通过会计标签的width和height属性来空值.
<div style="width: 50px;height: 50px;background-color: aqua;">
        <font color="red">第一个div元素</font>
</div>

<div style="width: 100px;height: 50px;background-color: green;">
        <font color="red">第二个div元素</font>
</div>

 * ## `<h1>`-`<h6>`标签:
### `<h1>`-`<h6>`是标题标签(同时也是块级标签)
<h1>一级标题:最好只有一个,所有标题标签的字体均加粗</h1>
<h2>二级标题</h2>
<h3>三级标题</h3>
<h4>四级标题</h4>
<h5>五级标题</h5>
<h6>六级标题</h6>

* ## `<p>`标签:
### `<p>`是段落标签(同时也是块级标签),`<p>`与`</p>`之间的文本被显示为一个段落.
<p>春眠不觉晓,处处闻啼鸟</p>
<p>夜来风雨声,设置盘中餐</p>

* ## `<hr/>`标签:
### `<hr/>`水平线标签(同时也是块级标签)
<hr/>

* ## `<ol>`标签:
### `<ol>`有序列表标签(同时也是块级标签),使用`<ol> </ol>`表示有序列表,使用`<li> </li>`表示各列表项.
<ol>
        <li>第一项</li>
        <li>第二项</li>
        <ol>
                <li>嵌套第一项</li>
        </ol>
        <li>第三项</li>
</ol>

* ## `<ul>`标签:
 ### `<ul>`无序列表标签(同时也是块级标签),使用`<ul> </ul>`表示无序列表,使用`<li> </li>`表示各列表项.
 <ul>
        <li>第一项</li>
        <li>第二项</li>
        <ul>
                <li>嵌套第一项</li>
        </ul>
        <li>第三项</li>
</ul>

* ## `<dl>`标签:
### `<dl>`定义列表标签(同时也是块级标签),该标签用于描述某个术语或产品的定义或解释.使用`<dl></dl>`定义列表,使用`<dt></dt>`表示术语,使用`<dd></dd>`表示术语的具体描述.
<dl>
        <dt>避孕套:</dt>
        <dd>避孕套可以防止意外怀孕!</dd>
        <dd>避孕套还可以防止传染病!</dd>
</dl>

* ## `<table>`标签:
### `<table>`标签用于描述一个表格(块状标签),使用`<table></table>`表示表格,使用`<tr></tr>`表示行,使用`<td></td>`表示标准单元格.
<table>
    <tr>
        <td>第一行第一列</td>
        <td>第一行第二列</td>
    </tr>
    <tr>
        <td>第二行第一列</td>
        <td>第二行第二列</td>
    </tr>
</table>

```html
源码:
<table>
    <tr>
        <td>第一行第一列</td>
        <td>第一行第二列</td>
    </tr>
    <tr>
        <td>第二行第一列</td>
        <td>第二行第二列</td>
    </tr>
</table>
```
### `<table>`标签常用标签如下:
|    标签     |                       描述                        |
| :---------: | :-----------------------------------------------: |
|  `<table>`  |                     定义表格                      |
| `<caption>` |       定义表格标题,每个表格只能含有一个标题       |
|   `<th>`    |         定义表格内的表头单元格,居中,粗体          |
|   `<tr>`    |                   定义表格的行                    |
|   `<td>`    | 定义表格单元格,包含在`<tr>`标签中,左对齐,普通文本 |
|  `<thead>`  |                  定义表格的表头                   |
|  `<tbody>`  |                  定义表格的主体                   |
|  `<tfoot>`  |                  定义表格的页脚                   |
|   `<col>`   |               定义用于表格列的属性                |

<table border="1">
    <caption>学生信息表</caption>
    <thead>
        <th>班级</th>
        <th>姓名</th>
        <th>电话</th>
    </thead>
    <tbody>
        <tr>
            <td>SE131</td>
            <td>蔡徐坤</td>
            <td>13088888888</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="3">软件学院</td>
        </tr>
    </tfoot>
</table>

```html
源码:
<table border="1">
    <caption>学生信息表</caption>
    <thead>
        <th>班级</th>
        <th>姓名</th>
        <th>电话</th>
    </thead>
    <tbody>
        <tr>
            <td>SE131</td>
            <td>蔡徐坤</td>
            <td>13088888888</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="3">软件学院</td>
        </tr>
    </tfoot>
</table>
```

### `<table>`标签常用属性如下:
|     属性      |               值               |                            描述                             |
| :-----------: | :----------------------------: | :---------------------------------------------------------: |
|    `align`    |      left、center、right       | 设置表格相对周围元素的对齐方式(不建议使用,建议使用样式替代) |
|   `bgcolor`   | rgb(x,x,x)、#xxxxxx、colorname |       设置表格的背景颜色(不建议使用,建议使用样式代替)       |
| `background`  |              src               |                      设置表格背景图片                       |
|   `border`    |             pixels             |                     设置表格边框的宽度                      |
| `cellpadding` |           pixels、%            |              设置单元格边框与其内容之间的空白               |
| `cellspacing` |           pixels、%            |                    设置单元格之间的空白                     |
|    `width`    |           %、pixels            |                       设置表格的宽度                        |
|   `height`    |           %、pixels            |                       设置表格的高度                        |
|   `colspan`   |                                |             单元格水平合并,值为合并的单元格数目             |
|   `rowspan`   |                                |             单元格垂直合并,值为合并的单元格数目             |



* ## `<form>`标签:
### `<form>`标签用于描述需要用户输入的页面内容(块级标签).它使用`<form></form>`表示表单,使用`<input/>`表示输入内容项.一般和表格一起使用.

* ## `<div>`标签:
### `<div>`分区标签(同时也是块级标签),容器标签,可以容纳很多额外的标签.

* ## 行级标签:
### 行级标签类似文本的显示,按"行"逐一显示.也就是不想块级标签那样一个标签占据一行,行级标签会多个标签在一行内显示.

* ## `<img/>`标签:
### `<img/>`图像标签(同时也是行级标签)用于显示图片.
### `<img src="https://www.baidu.com/img/flexible/logo/pc/result.png" alt="替代文本" title="悬浮文字" width="300" height="100" style="background-color: white;"/>`
### 其中alt指定替代文本,表示当图像无法显示时(例如图片路径错误、网速太慢等),显示的替代文本,这样当图像无法显示时用户也能看到网页的信息内容.
<img src="https://www.baidu.com/img/flexible/logo/pc/result.png" alt="替代文本" title="悬浮文字" width="300" height="100" style="background-color: white;"/>

|   属性   |   值   |          描述          |
| :------: | :----: | :--------------------: |
|  `alt`   |  text  |   规定图像的替代文本   |
|  `src`   |  URL   |   规定显示图像的URL    |
| `height` | pixel% |     定义图像的高度     |
| `width`  | pixel% |     设置图像的宽度     |
| `title`  |  text  | 鼠标悬浮图片的提示信息 |

* ## `<figure>`和`<figcaption>`标签:
### 这两个标签的作用解释起来比较麻烦,总的来说就是用来替代`<li>`标签的,用作图片列表的标签.(同样也是行级标签)
### 例如:
<ol>
        <li>
        <p>百度logo</p>
        <img src="https://www.baidu.com/img/flexible/logo/pc/result.png" style="background-color: white;"/>
        </li>
        <li>
        <p>360logo</p>
        <img src="https://p3.ssl.qhimg.com/t011e94f0b9ed8e66b0.png" style="background-color: white;"/>
        </li>
</ol>

```html
<ol>
        <li>
        <p>百度logo</p>
        <img src="https://www.baidu.com/img/flexible/logo/pc/result.png" style="background-color: white;"/>
        </li>
        <li>
        <p>360logo</p>
        <img src="https://p3.ssl.qhimg.com/t011e94f0b9ed8e66b0.png" style="background-color: white;"/>
        </li>
</ol>
```

### 可以等价写成:
<figure>
        <figcaption>百度logo</figcaption>
        <img src="https://www.baidu.com/img/flexible/logo/pc/result.png" style="background-color: white;"/>
        <figcaption>360logo</figcaption>
        <img src="https://p3.ssl.qhimg.com/t011e94f0b9ed8e66b0.png"style="background-color:white;"/>
</figure>

```html
<figure>
        <figcaption>百度logo</figcaption>
        <img src="https://www.baidu.com/img/flexible/logo/pc/result.png" style="background-color: white;"/>
        <figcaption>360logo</figcaption>
        <img src="https://p3.ssl.qhimg.com/t011e94f0b9ed8e66b0.png"style="background-color:white;"/>
</figure>
```

* ## `<span>`标签:
### 范围标签`<span>`(同时也是行级标签),文本的容器用于表示行内的某个范围.与css一同使用可以为部分文本设置样式属性.也就是后续css样式可对`<span>`标签划定的范围指定特定的样式.
<p>大丰是<span style="font-size:35px">麋鹿</span>的家乡!<p>

* ## `<br/>`标签:
### 换行标签`<br/>`表示强制换行显示.
### 111111</br>111111
```html
上述效果的代码:
111111</br>111111
```

* ## `<a>`标签:
### `<a>`标签是超链接标签(同时也是行级标签),标签格式如下:
### `<a href="url" target="self" title="悬浮提示">文本内容</a>`
<a href="https://www.baidu.com" target="self" title="悬浮提示">文本内容</a>

### href:用于定义超链接的跳转地址,其取值URL可以是本地地址或者远程地址.URL可以是一个网址、一个文件甚至可以是email地址.URL可以值绝对路径也可以是相对路径.
### 邮件链接:`<a href="mailto:邮件地址">`当用户点击该这种链接后,会启动本地的邮件工具来编辑邮件.
### 锚链接:锚链接由锚点和链接锚点两部分组成.锚点是将要被跳转到的位置,语法格式为`<a name="锚点名称">`.链接锚点是点击的文字,点击后会跳转到锚点,语法格式为`<a href="#锚点名称">内容</a>`.链接到其它网页的锚点的语法为`<a href="URL#锚点名称">内容</a>`
<a name="a">锚点</a></br>
<a href="#a">点击跳转到锚点</a>

### target:用于指定目标文件的打开位置,取值如下表:
|    值     |              target属性               |
| :-------: | :-----------------------------------: |
|  `_self`  | 在当前窗口中打开目标文件,该项是默认值 |
| `_blank`  |        在新窗口中打开目标文件         |
|  `_top`   |         在顶层框架中打开文件          |
| `_parent` |     在当前框架中的上一层打开网页      |
### title:鼠标悬停时的提示信息

* ## `<video>`标签:
### `<video>`标签用于定义视频,`<video>`标签的常用属性如下:
|    属性    |    值    |                       描述                        |
| :--------: | :------: | :-----------------------------------------------: |
| `autoplay` | autoplay |       如果出现该属性,则视频在就绪后马上播放       |
| `controls` | controls |   如果出现该属性,则向用户显示控件,比如播放按钮    |
|  `height`  |  pixels  |               设置视频播放器的高度                |
|  `width`   |  pixels  |               设置视频播放器的宽度                |
|  `poster`  |   URL    |     用于指定一张图片,在当前视频数据无效时显示     |
|   `loop`   |   loop   | 如果出现该属性,则当视频文件完成播放后再次开始播放 |
|   `src`    |   URL    |                 要播放的视频的URL                 |

### `<video>`标签允许多个source元素,source元素可以链接不同的视频文件.浏览器将使用第一个可识别的格式.
```html
    <video width="320" height="320" controls="controls">
        <source src="video.mp4" type="video/mp4">
        <source src="video.ogg" type="video/ogg">
    </video>
```
### 无论是通过video标签的属性src指定播放视频的路径,还是通过`<source>`标签指定,本质上是没有什么区别的.

* ## `<audio>`标签:
### `<audio>`标签用于定义声音,比如音乐或其它音频流,常用属性如下:
|    属性    |    值    |                     描述                     |
| :--------: | :------: | :------------------------------------------: |
| `autoplay` | autoplay |    如果出现该属性,则音频在就绪后马上播放     |
| `controls` | controls | 如果出现该属性,则向用户显示控件,比如播放按钮 |
|   `src`    |   URL    |               要播放的音频URL                |
### `<audio>`标签允许多个`<source>`元素.`<source>`元素可以链接不同的音频文件.浏览器将使用第一个可识别的格式.
```html
    <audio controls="controls">
        <source src="song.mp3" type="audio/mp3">
        <source src="song.ogg" type="audio/ogg">
    </audio>
```

