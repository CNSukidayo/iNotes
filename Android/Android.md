### 生命周期:
### 通信:
### 实际上activity之间的通信是可以传JavaBean对象的,是通过`Bundle.putParcelable()`来实现的.
### UI线程:
### 删除activity的顶部标题:,在一个activity的onCreate()方法中添加如下代码:`requestWindowFeature(Window.FEATURE_NO_TITLE);`
### 隐藏状态栏:`getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);`
### 显示状态栏:`getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);`
### 设置状态栏颜色:`getWindow().setStatusBarColor(getResources().getColor(R.color.white));`
### ANR:
## View介绍:
### 每一个View就相当于是xml中的一个组件,但是获取View之前需要先将xml解析为View,当然了布局也算作一个View,所以我们可以通过代表布局的View通过id来获取该布局内的组件,因为View包含了该布局的所有内容.
## Fragment介绍:
### Fragment类似于一个小的Activity.类似于一个新闻列表,我点击其中的一个新闻会跳转到这个新闻的详细页面.通过Fragment就能让新闻列表Fragment和新闻的详情页面Fragment都运行在一个activity中.Fragment相当于在一个大的Activity中嵌套多个小Activity.
### 1. Fragment具备生命周期
### 2. Fragment必须委托在activity中运行(可以在一个Activity中组合多个Fragment)
### Fragment的生命周期和activity是不一样的,activity是在`onCreate`方法里的`setContentView`方法加载xml文件的,而fragment是在`onCreateView`方法加载xml文件的,并且要将解析出来的View作为方法的返回值.
```java
/**
 *
 * @param inflater 解析器,通过解析器来解析xml文件
 * @param container
 * @param savedInstanceState
 * @return 返回加载后的View内容
 */
@Override
public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_blank, container, false);
}
```

总结来说attrs就是用于定义控件中有哪些属性的,通过`?定义的属性名`这种方式设置某个控件值时,实际上是需要从application定义的Theme中去获取这个值的,这个值必须在当前应用的Theme中有定义,否则就会报错.