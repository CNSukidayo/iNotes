# 一级标题
```markdown
#一级标题
```
## 二级标题
```markdown
##二级标题
```
### 三级标题
```markdown
###三级标题
```
#### 四级标题
```markdown
####四级标题
```
##### 五级标题
```markdown
#####五级标题
```
###### 六级标题
```markdown
######六级标题
```


一级标题
===
```Markdown
一级标题
===
```

二级标题
---
```Markdown
二级标题
---
```

## 分割线:
- - - 
```markdown
- - - 
```

**粗体**
```markdown
**粗体**
```

*斜体*
```Markdown
*斜体*
```

***斜体+粗体***
```Markdown
***斜体+粗体***
```

~~删除线~~
```Markdown
~~删除线~~
```

- - - 
[超链接](http://www.baidu.com)  
[超链接+悬浮文字](http://www.baidu.com "悬浮文字")
```markdown
[超链接](http://www.baidu.com)  
[超链接+悬浮文字](http://www.baidu.com "悬浮文字")
```
[超链接引用][1]  
[超链接引用+悬浮文字][2]

[1]:http://baidu.com
[2]:http://baidu.com "跳转百度"
```markdown
[超链接引用][1]  
[超链接引用+悬浮文字][2]

[1]:http://baidu.com
[2]:http://baidu.com "悬浮文字"
```

![](https://portrait.gitee.com/uploads/avatars/user/1720/5162809_cnsukidayo_1585457415.png!avatar60 "悬浮文字")
```markdown
![](https://portrait.gitee.com/uploads/avatars/user/1720/5162809_cnsukidayo_1585457415.png!avatar60 "悬浮文字")
```

<a id="this">锚点</a>  
[跳转到锚标记](#this)
```markdown
<a id="this">锚点</a>  
[跳转到锚标记](#this)
```

- - -

## 有序列表:
1. 一层
   1. 二层
   2. 二层
2. 二层

```Markdown
1. 一层
   1. 二层
   2. 二层
2. 二层
```

## 无序列表:
+ 一层
  - 二层
  - 二层
    * 三层
      + 四层
+ 一层
 
```markdown
+ 一层
  - 二层
  - 二层
    * 三层
      + 四层
+ 一层
```

## TodoList
近期任务安排:
- [x] 整理Markdown手册
- [ ] 改善项目
   - [x] 优化首页显示方式
   - [x] 修复闪退问题
   - [ ] 修复视频卡顿
- [ ] A3项目修复
   - [x] 修复数值错误

```markdown
近期任务安排:
- [x] 整理Markdown手册
- [ ] 改善项目
   - [x] 优化首页显示方式
   - [x] 修复闪退问题
   - [ ] 修复视频卡顿
- [ ] A3项目修复
   - [x] 修复数值错误
```

- - -
## 文字引用
> 第一层
> > 第二层
> > > 第三层
> 
> 跳出来

```markdown
> 第一层
> > 第二层
> > > 第三层
> 
> 跳出来
```

- - - 
`行内代码块`
```markdown
`行内代码块`
```

## 代码块:
```java
public static void main(String args[]){
    System.out.print("Hello World!");
}
```

```
```java
public static void main(String args[]){
    System.out.print("Hello World!");
}
```(忽略括号)
```

- - -
## 表格:
| 商品 | 数量 |  单价  |
| ---- | ---: | :----: |
| 苹果 |   10 |  \$1   |
| 电脑 |    1 | \$1000 |

```markdown
| 商品 | 数量 |  单价  |
| ---- | ---: | :----: |
| 苹果 |   10 |  \$1   |
| 电脑 |    1 | \$1000 |
```

### 表格默认左对齐,第二行中的-可以是任意数量,默认是左对齐.
### :--- `左对齐` 
### :--: `居中对齐` 
### ---: `右对齐` 

- - - 
## 转义符:
\*  
\*\*  
\-  
\>  
\[\]  
\(\)  


```markdown
\*
\*\*
\-
\>
\[\]
\(\)
```

- - -
## HTML标签:
1. ### &nbsp;&nbsp;不断行的空白格
    ### &ensp;&ensp;半方大的空白
    ### &emsp;&emsp;全方大的空白
    ```markdown
    ### &nbsp;&nbsp;不断行的空白格
    ### &ensp;&ensp;半方大的空白
    ### &emsp;&emsp;全方大的空白
    ```
2. ### 上标标签<sup>上标</sup>
   ```markdown
   上标标签<sup>上标</sup>
   ```
3. ### 上标标签<sub>下标</sub>
   ```markdown
    上标标签<sub>下标</sub>
   ```
4. ### <u>下划线</u>
   ```markdown
   <u>下划线</u>
   ```
5. ### 换行标签<br>换行
   ```markdown
   换行标签<br>换行
   ```
6. ### <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Del</kbd> 键盘按键特效
   ```markdown[](Markdown.md)
    <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Del</kbd> 键盘按键特效
   ```
7. ### <font color="#dd0000">文字着色</font>
   ```markdown
   <font color="#dd0000">文字着色</font>
   ```
8. ### <p align="center">文字居中显示</p>

- - - 
## Mermaid  
```mermaid
graph LR
   A --> B;
```
