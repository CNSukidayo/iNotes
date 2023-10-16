## 介绍:
### Python内置的编辑器叫IDLE,是默认安装的.
## 基本语法
### `import [library]` 导入一个函数库,在Python中要使用一个函数库中的函数时必须在函数前加上库名,例如我导入了math库,如果我要使用math库中的pow方法则必须这样调用<font color="#00FF00">math.pow()</font>
### `from [library] import *` 导入一个函数库,使用这种方式导入类似Java中的静态导入.使用这种方法会导入目标函数库的所有方法,此时再使用函数库中的方法时就不需要在函数名前加上函数库名了,此时直接调用<font color="#00FF00">pow()</font>即可.
### `import [library] as m` 导入一个函数库,并给函数库一个别名,加入我指定了`import math as m` 此时调用math库中的方法,只需要<font color="#00FF00">m.abs()</font>即可.
### Python中注释的方法:
```Python
#单行注释
'''
多行注释
'''
```
### Python中的比较运算符支持链式比较,例如:`if(10 < i <=20):...` 表示的意思就是i大于10小于等于20,这种语法是合法的.
### Python中的程序控制结构:
### Python中的选择结构有三种,分别是单分支、双分支、多分支.
```Python
#单分支
if(表达式): #注意在Python中条件表达式的两边可以加或不加括号.
    <语句块>    #注意语句块前面必须要有制表符,Python是通过制表符(缩进)来代替Java中的括号的.
```
```Python
#双分支
if(表达式):
    <语句块>
else:
    <语句块>
```
```Python
#多分支
if(表达式):
    <语句块>
elif:
    <语句块>
elif:
    <语句块>
else:
    <语句块>
```
### Python中的for循环:
```Python
for i in [array]: #代表的意思是,for循环会每次从array数组中依次获取一个元素赋值给变量i,然后执行下面的语句块.当然变量i的名称可以任定.
    <语句块>
for i in range(): #这是一种更常见的写法,详情见range函数.
    <语句块>

for i in range():
    <语句块>
else:
    <语句块> #这个语法的作用是,当执行完整个for循环正常执行解释后再执行一次else:后面的语句块.乍一看这个语法很没有道理,但实际上在else语句块中是可以使用变量i的,也可以使用该方法的内部定义的局部变量.如果只是单纯的跳出for循环后执行语句,是无法访问到变量i的.注意如果for循环在执行的过程中执行的break语句,那么算法for没有被正常执行结束,后面的else语句就不会被执行.
```
### Python中的while循环:
```Python
while(表达式):
    <语句块>
else:
    <语句块>
```
### 循环中的continue和break:
```Python
for i in [array]
    if(...)
        #doSomething...
        break #退出循环
```
```Python
for i in [array]
    if(...)
        #doSomething...
        continue #跳过本次循环
```
### 如果指定`while(Ture)`则为死循环,在Python中while的条件表达式和C语言一样,可以是数值类似,任何非0的数值的效果相当于True,即`while(1)`或`while(2-1)`都是死循环.0值的效果相当于False,例如:`while(0)`或`while(1-1)`都不会执行语句.同理这个表达式的逻辑也适用于if语句的表达式.
</br>

### 使用`python -m pip install --upgrade pip`方法升级pip
### 使用`pip install [library]`通过pip安装(下载)一个Python库,pip程序在/script文件夹下.
### 使用`pip list` 查看当前安装的Python库
### Python中函数的定义方式:
```Python
def function(args0,args1...):
    <函数体>
    return <返回值> #注意Python中函数的返回值类型不需要在方法头处声明.并且可以没有return关键字,也就是方法没有返回值,此时Python会自动返回一个空参数.如果函数不写return语句,那么函数体将不能为空,否则会报错.另外如果想指定返回一个空,则写上return语句但不写返回值.
```
```Python
def function(args0,args1...,agrs3=1,args4="String"): #在非可选参数的后面,即这里的args0,args1位非可选参数即方法调用时必须指明具体值的参数.再其后面可以有非可选参数,例如args3和args4,除了声明形式参数之外,这两个参数还直接用赋值符号给了一个默认值,这种参数就称作可选参数.在调用函数时,如果没有指定可选参数,则函数会自动使用参数的默认值.
    <函数体>
    return <返回值>
```
```Python
def function(*args0): #可变参数args0,这个可变参数实际上就是一个数组.
    <函数体>
    return <返回值>
```
```Python
def function():
    function2() #在这里也可以调用
    def function2(): #嵌套函数
        function() #可以在function2函数体内调用function,当然这两个函数自已递归调用自已都是可以的.
    function2() #可以在function函数体内调用function2()
    return <返回值>
```
### Python中局部变量和全局变量:
### 函数内部的变量就是局部变量,它的作用域就是函数内部.当函数结束时,函数内部的局部变量也会一同被销毁,在函数外部定义的变量叫全局变量,全局变量可以在函数内部使用也可以在函数外部使用.如果要想在函数的外部使用函数内部的局部变量,必须在函数内部声明局部变量的时候使用`global`关键字,此时函数结束后被声明了该关键字的变量就不会被销毁了.例如`global x`并且我可以不赋值,那么声明了仅仅是声明了,并没有说给这个变量赋一个初始值什么了,这样的用处就是当我重复调用某个函数时,该函数内部声明的全局变量的值不会被覆盖,还是上一次函数结束后的值.
### Python中局部变量的名称不要和函数名称相同!!!
### <font color="#00FF00">组合数据类型,</font>如果局部变量未真实创建,则是全局变量.
### 捕获异常:
```Python
try: #捕获语句块中所产生的所有异常
    <语句块>
except:
    <语句块>/pass #语句块这里可以放产生异常后要执行的语句,如果填的是pass则代表不做任何操作.
```
### Python变量的命名规则,区分大小写,变量名字中可以包含英文、下划线、数字,但是不能以数字开头.
## 基本函数
### `print(String...) return void` 控制台输出,不同类型的内容不能通过+进行拼接,+只能实现字符串与字符串的拼接,该方法内部是一个可变参数,会依次把变量输出到标准输出流,从而解决多个类型不同的变量的打印.并且该方法会给每个输出的参数之间添加一个空格.
### `print(String,end="something")` 重载方法,可以通过end="..."来指定print语句的结尾符号,如果不指定默认就是\n换行.
### `input(String) return String` 从标准输入流中读取用户的输入,并且在阻塞读取输入之前先打印args0,提示用户当前输入所代表的含义,并且方法的返回值是一个**字符串**
### `eval(String) return int` 将一个字符串转为int类型
### `round(float,int) return float` 将一个浮点值四舍五入,args0为待四舍五入的浮点值,args1为小数点位的个数,函数方法返回一个浮点值.
### `format(float,String) return String` 格式化一个数值,args0可以是int也可以是float,args1为格式化的格式.方法的返回值为String类型.
### 例子:`format(number, ".2%")` 代表将float浮点值number保留两位小数,并且添加一个%作为结尾结尾,如果想要3位小数就将保留3位小数,如果改成.0就不会产生小数点了.
### `len(T[]) return int` 返回args0数组的长度,agrs0也可以传入列表、元组.
### `range(int) return int[]` 产生一个等差数列,数组的下标从0开始,长度为args0.可以用该函数指定for循环中的下标.
### `range(int,int,int) return int[]` 重载方法,args0为等差数列索引的起始值,等差数列最后一个元素的值为args1-1,args3为等差数列的公差.例如:`range(100,0,-1)`注意没有规定说args0必须小于args1,这里产生的序列为100,99,98...1
### `chr(int) return char` 将一个整型转为字符型.
### `ord(char) return int` 该函数是chr的反函数,即获取到args0对应的ASCII码值.
### `type(Object) return Type` 判断args0参数的数据类型.
### `set(Object[]) return set` 创建一个集合,Python中允许通过set方法将一个可迭代的数据类型转为set集合,例如:<font color="#00FF00">字符串、列表、元组、range()</font>等
### `list(Object[]) return list` 创建一个列表,注意必须传入一个可迭代的集合,也就是必须是一个数组,下面的几个方法都是如此.
### `tuple(Object[]) return tuple` 创建一个元组
### `dict(key = value,key = value) return dict` 创建一个字典
### `max(Object) return Object` args0为一个列表,返回列表中的最大值,注意列表中的各个元素之间必须是可比较的.
### `max(Object) return Object` args0为一个列表,返回列表中的最小值,注意列表中的各个元素之间必须是可比较的.
</br>

### Python中有6中主要的内置数据类型,分别是:数值、字符串、列表、元组、集合、字典.
</br>

### Python中有4中数值类型,分别是:整数类型(int)、浮点类型(float)、复数类型、布尔类型.
### int:整数类型
### Boolean:布尔类型 Python中的布尔类型有两个取值,分别是<font color="#00FF00">True</font>和<font color="#00FF00">False</font>并且首字母必须大写.
</br>

### String:字符串类型,可以用单引号\`、双引号\`\`、三引号\`\`\`括起来的任意文本.对于用三引号引用的字符串是不需要写格式符的,也就是说不需要换行,相当于一个文本块.
</br>

### 列表:列表是一种序列类型,创建后可以被随意修改,使用方括号`[]`或`list()`创建,元素间用逗号,分隔.列表中各元素类型可以不同,无长度限制.列表的访问和字符串的访问是一样的,都是按索引访问,并且支持正向递增和反向递减.
### 创建列表的方式,一种是 array = [1,2,"3",4.0]
### 另外一种方式为:list = list((1,2,"3",4.0))
</br>

### 元组:元素与列表类似,也是用于存放一组相关的数据.元组使用圆括号`()`创建,并且元组只能读取其中的元素而不能修改.
### 需要特别注意的是,当定义的元组只有一个元素时,一定要在该元素后面写一个逗号<font color="#00FF00">","</font>否则系统会将其视为单个数据.例如:
```Python
listOne = (1,)
listTwo = (1)
print(type(listOne)) #输出<class 'tuple'>
print(type(listTwo)) #输出<class 'int'>
```
</br>

### 字典:字典数据类型的声明方式,例如:`map = {"1":1,"2":3}`,字典类型实际上就是Java中的Map类型,声明方式类似Key:Value的形式,但是字典类型不会限制Key和Value的类型,并且字典类型也会对Key进行去重.字典的Key是不允许修改的,但是字典的value是可以修改的.Key必须可hash、且必须为不可变数据类型、必须唯一.
</br>

### 集合:集合数据类型的声明方式,例如:`set = {value0,value1,value2}`集合中的每个元素的数据类型任意,集合是一个无序不重复的元素的集合,并且要保证集合中的每个元素是不可变的.例如:
```Python
set = {6,3,7,3}
set = {(1,2),(2,3)} #元组作为元素,由于元组是不可变的,所以满足集合元素不可变的规定.
set = {[1,2],[2,3]} #列表作为元素,由于列表是可变的,所以不满足规定,这里会创建失败,产生TypeError异常.
```
### 另外如果要创建一个空的set集合,只能使用`set()`方法.如果通过花括号的方式声明`set = {}`则Python解释器会将其解释为一个空的字典而不是集合.
### 算数运算符:
|运算符|说明|
|:-:|:-|
|+|-|
|-|-|
|*|-|
|/|-|
|%|-|
|//|整除:使两个操作数相除,获取商的整数部分</br>例如12//10=1|
|\*\*|使两个操作数进行幂运算,获取a的b次幂,例如2\*\*3=8|
### 比较运算符:
|运算符|说明|
|:-:|:-:|
|==|等于|
|!=|不等于|
|>|大于|
|<|小于|
|>=|大于等于|
|<=|小于等于|
### 赋值运算符:
|运算符|说明|
|:-:|:-:|
|=|赋值|
|+=|-|
|-=|-|
|/=|-|
|%=|-|
|**=|幂等于|
|//=|双除等于|
### 赋值运算符:
|运算符|说明|
|:-:|:-:|
|=|赋值|
|+=|-|
|-=|-|
|/=|-|
|%=|-|
|**=|幂等于|
|//=|双除等于|
### 位运算符:
|运算符|说明|
|:-:|:-:|
|&|与运算|
|||或运算|
|^|异或|
|~|取反|
|<<|左移|
|>>|右移|
### 逻辑运算符:
|运算符|说明|
|:-:|:-:|
|and|逻辑与|
|or|逻辑或|
|not|逻辑非|
### 成员运算符:
|运算符|说明|
|:-:|:-:|
|in|a在b中返回true|
|not in|a不在b中返回true|
|is|a和b是否一样,则返回true|
|not in|a和b不是一样,则返回true|

## 字符串String
### Python中的字符串是不可变序列.在Python中字符串是一个字符数组,即它是一个数组.
### 字符串的索引,在Python中字符串包含两种序号体系,即正向递增序号和反向递减序号,例如:
||||||||
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|<-反向递减序号|-6|-5|-4|-3|-2|-1|
||A|B|C|D|E|F|
|正向递增序号->|0|1|2|3|4|5|
||||||||
### 通过这两种序号方式都可以访问到字符串中的某个字符.例如:
```Python
string = "ABCD"
print(string[-1])   #打印结果为D
```
### Python中比较两个字符串的内容是否相等时可以直接使用==来比较,例如:
```Python
first = "aaa"
second = "aaa"
print(first == second) #输出结果为True
```
### 字符串切片,Python中字符串也提供区间访问方式,采用`[head:tail]`的方式,这种访问方式称为切片,可以用一个变量来接受访问的切片访问的结果,也就是通过字符串的索引值来提取字符串,注意Python中的这种访问方式是含头不含尾的,也就是访问区间为<font color="#00FF00">[head,tail)</font>.例如:
```Python
string = "ABCD"
print(string[0:3])  #输出结果为ABC
```
### String常用方法:
### `format(String...) return String` 格式化当前字符串,例如:
```Python
print("String:{0},{1}".format(123, 456)) #输出结果为String:123,456
print("String:{:.1f}".format(123.123)) #输出结果为String:123.2,这里会四舍五入,并且括号里面必须用:.1f来代表一个浮点数的占位符,冒号一定不能少.1代表只保留一位小数.
```
### `lower() return String` 将当前字符串转为小写字符串.
### `upper() return String` 将当前字符串转为大写字符串.
### `isdecimal() return boolean` 如果当前字符串仅由0-9这些数字构成则返回True否则返回False.
### `isdigit() return boolean` 如果当前字符串仅由0-9这些数字构成则返回True否则返回False.
### `isnumeric() return boolean` 如果当前字符串仅由0-9这些数字构成则返回True否则返回False.
### `isalpha() return boolean` 如果字符串中至少有一个字符,并且所有字符都是<font color="#00FF00">字母</font>则返回True,否则返回False.
### `islnum() return boolean` 如果字符串中至少有一个字符,并且所有字符都是<font color="#00FF00">字母或数字</font>则返回True,否则返回False.
### `split(String,int) return String[]` 按照args0分隔字符串,args1代表分隔几次,方法的返回值是一个字符串数组.如果没有args0则默认采用任意形式的空白字符:空格、Tab、换行、回车等.
### `join(String[]) return String` 将args0字符串数组拼接到当前字符串后面.
### `find(String,int,int) return int` 查找当前的字符串中是否能匹配到args0字符串,如果能匹配到则返回匹配到的第一处的索引,如果匹配不到则返回-1,args1表示查找的起点位置索引,args2表示查找的末尾位置索引,并且查找的区间也是左闭右开,即区间为<font color="#00FF00">[args1,args2)</font>
### `find(String) return int` 重载方法,范围为:<font color="#00FF00">[0,len(str))</font>
### `index(String,int,int) return int` 和find方法一样,只不过如果不能在当前字符串中找到目标串则会抛出一个异常.
### `strip() return String` 删除字符串前后的空格或特殊字符.
### `lstrip() return String` 删除字符串前面的空格或特殊字符.
### `rstrip() return String` 删除字符串后面的空格或特殊字符.
### `replace(String,String,int) return String` 将当前字符串中的args0替换为args1,替换的次数为args2次,返回值为String
### `replace(String,String) return String` 重载方法,将当前字符串中的args0替换为args1
### `count(String,int,int) return int`  统计args0字符串在当前字符串中出现的次数,args1代表检索的起始位置,args2代表检索的终止位置,同样还是左闭右开的区间.<font color="#00FF00">[args1,args2)</font>
### `count(String) return int`  重载方法,统计字符串中args0出现的次数
## Turtle库
### 首先导入函数库`import turtle`
### 介绍
### Turtle库实际上就是小时候用的小海龟,turtle库是由一个窗口构成的,窗口内就是一个画布,画布上有一个小海龟,小海龟最有它的起始坐标和朝向.
### Turtle常用方法:
### `setup(int,int,int,int)` 该方法用于设置turtle画布的大小和位置,args0表示画布的宽度,args1表示画布的高度,args2表示窗口在屏幕x轴上的坐标,args3表示窗口在屏幕上y轴的坐标.args2和args3是可省略的,如果省略则默认会在屏幕的中心.
### `forwar(float)` 向当前画笔方向移动args0像素长度
### `backward(float)` 向当前画笔反方向移动args0像素长度
### `right(float)` 当前画笔朝向顺时针转动args0度
### `left(float)` 当前画笔朝向逆时针转动args0度
### `penup()` 提起画笔,若调用该命令之后,画笔的所有移动都不会绘画,直到下次调用pendown()方法为止.
### `pendown()` 放下画笔,和penup()方法的作用正好相反.
### `speed(int)` 调整画笔的速度,args0的范围为[0,10],注意0和10的速度是一样的.
### `circle(int)` 画圆,半径为正(负)表示圆心在画笔的左边(右边),也就是在画笔朝向的左侧(右侧)画圆.
### `circle(int,int)` args1为画圆弧为多少度的圆,默认值是360°,如果传90就会画四分之一个半圆.
### `pensize(int)` 设置画笔的粗细
### `pencolor(String)` 设置画笔的颜色,传入一个String值代表画笔的颜色,可以传入green、red这种字符串,也可以传入一个代表16进制值的字符串,例如#ffffff.
### `pencolor(float,float,float)` 重载方法,传入一个代表RGB三元组的浮点值,用这三个浮点值参数来指定对应的RBG值.
### `fillcolor(String)` 绘制图形的填充颜色
### `write(String)` 在画笔处写入文字
### `write(String,font=(String,int,String))` 重载方法,通过args1参数来设置字体,args1.0参数代表选择哪种字体,args1.1代表字体的大小,args1.2代表字体的特殊格式,例如normal、bold等.例如:`write("Hello World",font=("Arial",20,"normal"))` <font color="#009933">#表示在箭头处书写一个Hello World,并且指定字体为Arial,字体Size为20,字体的格式为普通.</font>
### `begin_fill()` 准备填充图形,也就是说如果画笔接下来画的线条能构成一个封闭区域,那么就用指定的颜色填充该区域.
### `end_fill()` 填充完成
### `hideturtle()` 隐藏箭头显示
### `showturtle()` 显示箭头
## Time库
### 首先导入函数库`import time`
### 介绍
### time库提供各种操作时间的函,一般有两种表示时间的方式.
### 第一种是时间戳的方式(相对于1970.1.1 00:00:00以秒计算的偏移量),时间戳是唯一的.
### 第二章是以数组的形式表示.
### Time库常用方法:
### `localtime(float) return struct_time` 这个函数的作用是将时间戳args0所代表的时间(从1970.1.1 00:00:00开始),转换为当前时区的时间结构,返回的是一个元组.如果没有提供args0参数,系统默认会以当前时间的时间戳作为参数.
### `time() return float` 该方法会把从纪元以来的秒数作为一个float值返回. 
### `ctime(float) return String` 将一个时间戳转换为一个时间的字符串.<font color="#00FF00">Thu Dec  8 20:11:46 2022</font>
### `sleep(int)` 让程序休眠args0秒
### `strftime(String,float)` 将args1时间戳所代表的时间,按照args0指定的格式进行输出.例如:
```Python
struct_time = time.strftime("%Y-%m-%d %H:%M:%S,%A,%B",time.localtime())
print(struct_time) #输出的结果为2022-12-01 21:04:39,Thursday,December
```
### `gmtime(float) return struct_time` 函数将一个时间戳转换为UTC时区.<font color="#00FF00">time.struct_time(tm_year=2022, tm_mon=12, tm_mday=8, tm_hour=12, tm_min=13, tm_sec=19, tm_wday=3, tm_yday=342, tm_isdst=0)</font>
## Random库
### 首先导入函数库`import random`
### 介绍:
### 用于生成伪随机数
### random常用方法:
### `random() return float` 生成一个<font color="#00FF00">[0,1)</font>之间的随机浮点数
### `uniform(float,float) return float` 生成一个<font color="#00FF00">[args0,args1)</font>之间的随机浮点数
### `randint(int,int) return float` 生成一个<font color="#00FF00">[args0,args1)</font>之间的随机整型
### `randrange(int,int,int) return int` 生成一个<font color="#00FF00">[args0,args1)</font>之间的随机整型,并且随机数的步长为args2.意思是从args0开始下一个可能的随机数是args0+args2.再下一个是args0+args2*2一直下去.例如:`random.randrange(1,100,2)`最终能生成的随机数只有可能是<font color="#00FF00">1,3,5,7...100</font>.
### `choice(T[]) return T` 从args0数组中随机选取一个元素并返回.
### `choice(T[],k=int) return T[]` 从args0数组中随机选取k个元素并返回,注意这里是Python的语法,args1必须是以k=int的形式指定个数,例如k=3这种形式.另外该方法随机选取是允许有重复的.
### `shuffle(T[]) return void` 将数组中的元素打乱,会修改原有序列,注意该方法没有返回值,是直接修改原数组对象顺序.例子:
```Python
import random
array = [1,2,3,4,5]
random.shuffle(array)
print(array) #输出打乱之后的array数组顺序
```
### `sample(T[],k=int) return T[]` 该方法类似choice,但是该方法返回的是args0的子序列,即该方法从args0中随机选取args1个元素构成子序列并返回,所以该方法的元素是不允许有重复的.条件:<font color="#00FF00">args1<len(args0)</font>
## GPIO库
### 首先导入函数库`import RPI.GPIO`
### 介绍
### Python实际上也是可以控制硬件的,比如树莓派这种.要控制树莓派必须先导入GPIO库,然后做相应的操作.
## numpy库
### 首先安装`pip install numpy`
### 导入函数库`import numpy`
### 介绍
### numpy库是用于做科学计算所使用的包
## matplotlib库
### 首先安装`pip install matplotlib`
### 导入函数库`import matplotlib.pyplot`
### 介绍
### matplotlib库是Python中用于绘图的包.
### numpy库和matplotlib库常用方法:
### `numpy.linspace(int,int,int) return T` 生成X轴的数据,args0为X轴坐标的起点,args1为X轴坐标的终点,args2为X轴上有多少个点.
### `numpy.pi`
### `numpy.sqrt()` 计算各个元素的平方根
### `numpy.square()` 计算各个元素的平方
### `numpy.exp()` 计算各个元素的指数e的x次方e^x
### `numpy.pow()` 对数组中的每个元素进行给定次数的指数值x^a
### `numpy.sin()` 正弦函数
### `numpy.cos()` 余弦函数
### `numpy.tan()` 正切函数
### `matplotlib.pyplot.plot(T,T,String)` 绘制(args0,args1)曲线,args2为曲线颜色,例如:r--代表红色,b-- 代表蓝色
### `matplotlib.pyplot.title(String)` 给函数一个标题,支持数学表达式
### `matplotlib.pyplot.show()` 展示
## 列表
### 可以通过`del [listVar]` 来手动删除一个列表,但是这种方法不常用,因为Python自待垃圾回收机制.即del [列表变量]
### 列表的常用方法:
### 这里用<font color="#00FF00">list</font>指代列表变量
### `list[index] = [value]` 将[value]复制给list列表中索引为index的元素(修改list中index索引处的元素内容)
### `index(Object) return int` 查找列表中元素为args0的索引,如果有多个元素的值为args0,则返回第一个.如果找不到args0,则会产生ValueError异常.
### `count(Object) return int` 返回args0在列表中出现的次数.
### `del list` 删除列表list
### `del list[index]` 删除列表中索引为index的元素
### `pop(index)` 删除列表中索引为index的元素
### `remove(Object)` remove方法是根据元素的值进行删除,而不是索引,该方法会删除列表中第一个等于args0的元素.使用remove删除的时候一定要保证args0是在列表中的,如果不存在于列表中则会产生ValueError异常.
### `clear()` 清空列中中的所有元素,该方法并不会删除列表.
### `sort()` 排序列表,因为列表中的元素的类型是任意的,所以使用该方法必须保证列表中元素是可比较大小的,如果<font color="#00FF00">list = [1,"a"]</font>这种调用sort方法是会报错的.
### `sort(reverse=True)` 重载方法,逆序排序列表
### `reverse()` 逆序排序列表,效果和上面的这个sort方法一样.
### `append(Object)` 添加一个元素到列表中
### `insert(int,Object)` 在args0索引出插入一个args1元素.
### 元组
### 元组的常用方法:
### 因为元组是不可修改的列表,所以列表中不涉及修改的方法都适用于元组.
## 字典
### 字典的常用方法:
### `map[Key]` 通过Key来访问字典中的值.
### `map[Key] = value` 通过Key来修改字典中的value
### `get(Object) return Object` 根据args0来获取到字典中的value
### `get(Object,Objecy) return Object` 根据args0来获取到字典中的value,如果获取不到就返回args1.
### `keys() return Object[]` 获取到当前字典的所有Key,返回的类型是列表
### `values() return Object[]` 获取到当前字典的所有value,范湖的类型是列表.
## 集合
### 集合常用方法:
### 集合运算符:
|Python符号|作用|
|:-:|:-:|
|&|交集|
|\||并集|
|-|差集|
|^|对称差集|
|==|等于|
|!=|不等于|
|in|a in set 元素a是不是集合set的成员|
|not in|a not in set 元素a不是集合set的成员|
```Python
set0 = {1}
set1 = {2}
print(set0 | set1) #输出{1,2}
```
## IO流
### 介绍
### Python按文件中数据的组织形式把文件分为文本文件和二进制文件两类.
### 文本文件存储的是常见的字符串,常规字符串是指记事本或其它编辑器能正常显示、编辑并且人类能够直接阅读和理解的字符串.
### 二进制文件把对象内容以字节串(byte)进行存储,需要使用专门的软件打开,常见的例如图像文件、音频文件等等.
### IO流常用方法:
### `open(String,String,String) return File` 打开一个文件,args0为文件的路径,args1为打开文件的格式,args2指定文件的编码.其中args1的取值为:
|打开模式|含义|
|:-:|:-:|
|r|只读默认,如果文件不存在返回FileNotFoundError异常,默认值|
|w|覆盖写模式,文件不存在则创建,存在则完全覆盖源文件|
|x|创建写模式,文件不存在则创建,存在则返回异常FileExistsError|
|a|追加写模式,文件不存在则创建,存在则在源文件最后追加内容|
|b|二进制文本模式|
|t|文本文件模式,默认值|
|+|与r/w/x/a一同使用,在原功能基础上同时增加读写功能|
### `close()` 关闭文件的IO流
### 使用with as代码块中关闭文件,在with as代码块结束后自动释放资源,这种语法格式就类似Java的新增语法try(InputStream...)catch例如:
```Python
with open("path...") as file #读取path路径的文件,并且命名变量未file,使用with as代码块是不需要我们设置文件的打开操作,也不需要我们手动关闭文件的,会自动关闭.
    data = file.read()
```
### `read(int) return String` 从文件中读取整个文件内容,如果给出参数,读取前size长度的字符串或字节流,如果不给参数则读取整个文件.
### `readline(int) return String` 从文件中读入一行内容,如果给出参数,读取该行前size长度的字符串或字节流,该方法可以多次调用以此来读取多行.
### `readlines(int) return String[]` 从文件中读入所有行,以每行为元素形成一个列表,也就是该将读取的每行的内容放入一个列表中,可以通过返回值的索引来访问每行的内容,如果指定了args0则会读取指定的字节数.
### `write(String)` 向文件写入一个字符串或字节流(字节流只能是二进制文件)
### `writelines(String[])` 将一个字符串列表写入文件
## jieba库
### 首先安装`pip install jieba`
### 导入函数库`import jieba`
### 介绍
### jieba是优秀的中文分词第三方库,jieba支持三种分词模式:①分词模式②全模式③搜索引擎模式.
### 精确模式:试图将句子最精确地切开,适合文本分析.
### 全模式:把句子中所有的可以分词的词语扫描出来,速度非常快,但不能解决歧义.
### 搜索引擎模式:在精确模式的基础上,对长词再次切分,提高召回率,适合用于搜索引擎分词.
### jieba支持繁体分词、支持自定义词典.
### jieba常用函数:
### `lcut(String,cut_all=True) return String[]` args0为需要分词的字符串,cut_all代表我们所采取的分词模式.该方法的返回值是一个列表
## worldcloud库
### 首先安装`pip install jieba`
### 导入函数库`import jieba`
## openpyxl库
### 导入函数库`from openpyxl import load_workbook`
### 例子:
```Python
workbook = load_workbook("path") #加载Excel文件
sheet = workbook.active #获取到活跃的表,因为一个Excel文件可以有多少工作表的缘故,获取到当前正打开的某个工作区.
print(sheet["A2"].value) # 打印表格中A2的数据
```
## Tkinter
### 导入函数库`import tkinter`
### 介绍
### Tkinter是Python自带的GUI图形编程的模块
### Tkinter常用方法:
```Python
import tkinter
root = tkinter.Tk()
root.title("Title") #设置窗口标题
root.geometry("600x400") #设置窗口大小为600x400
root.config(bg="red") #设置背景颜色为红色

#1、button
def listener():
    print("按钮被点击")

button = tkinter.Button(root, text="background",
                        width=15, height=2, command=listener) #创建一个button,args0为窗口对象,args1为按钮的文字,args2位按钮的宽度,args3位按钮的高度,args4为按钮点击之后的监听函数
button.place(x=200, y=100) #设置按钮的位置

root.mainloop() #进入消息循环,这样窗口就会等待用户的关闭事件
```
