# 目录  



A.Java并发编程实战  







## A.Java并发编程实战
**目录:**  
1.各种demo  




### 1. 各种demo
`demo1:`  
```java
public class Demo1 {
    private int count;
    // object指向堆内存当中的一个对象
    Object object = new Object();	
    public void m(){
        synchronized (object){
            count++;
            System.out.println(count);
        }
    }
}
```

**解释:**  
当第一个线程访问m方法时,通过synchronized关键字会对<font color="#00FF00">堆内存中的Object对象</font>,加上一把锁(锁信息记录在堆内存的对象中,如果此时object指向别的对象,那么锁的对象就改变了(你想想如果原先的对象不再被引用就会被回收,新的对象再被加锁,所以锁所在的对象也就改变了)),然后进行方法的访问,此时正好运行到count++;语句结束时  
第二个线程需要调用该方法,synchronized需要再次对堆内存中的Object对象加锁,但是此时由于第一个线程还在对该方法的访问中(没有释放锁)所以第二个线程就会进行等待,直到第一个线程释放锁,第二个线程才有资格加锁访问方法,如果有第三个线程也是一样的.  
只要一个线程在访问加锁,别的线程不能访问的就称之为<font color="#00FF00">互斥锁</font>  

`demo2:`  
```java
public class Demo2 {
    private int count = 100;
    public void m(){
        synchronized (this){
            count++;
            System.out.println(count);
        }
    }
}
```
例子1方法的问题是,Object对象是被手动创建的,除了当锁别的什么也不干有些浪费.  
这种锁法在于,如果你需要调用m方法势必要创建这个对象才能调用,这里的this直接指向自身,会给当前本身的这个在堆内存当中的对象添加一把锁.所以synchronized根本不是锁什么代码块,synchronized就是锁一个对象.  
如果一个方法在开始的时候就synchronized(this)(一定是this)直到结束的时候才释放锁,那么有一种等价的写法;如下:  
```java
public class Demo2 {
    private int count = 100;
    public synchronized void m(){
            count++;
            System.out.println(count);

    }
}
```

`demo3:`  
```java
public class Demo4 {
    private static int count = 100;
    public static void m(){
        synchronized (Demo4.class){
            count++;
            System.out.println(count);
        }
    }
}
```
之前说的锁都是锁住<font color="#00FF00">堆内存当中的对象</font>,但是一个类的静态方法是不需要new就可以访问的,所以你就没有办法在堆内存中给这个对象加上锁了.  
不过你可以通过 **对象.class** 来锁住一个Class对象,也能起到同样的效果.(对象.class本质也是一个存放在堆内存中的对象,所以synchronized锁住的还是一个对象)  

`demo4:`模拟多线程访问同一个对象的run方法  
```java
public class Demo5 implements Runnable{
    private int count = 10;
    /**
     * run()方法的本质就是将count--;并打印内容
     */
    @Override
    public void run() {
        count--;
        System.out.print(count);
    }

    public static void main(String[] args) {
        Demo5 demo5 = new Demo5();			//这里只创建了一个对象
        for (int i = 0; i < 5; i++) {
            new Thread(demo5).start();		//通过这一个对象创建了5个线程,同时去访问count变量
        }
    }
}
```

**正常的结果:**  
76958 顺序原因是由于CPU的调度你不知道先进行那个线程

**错误(实际)的打印结果可能是:**  
86679  
*每次执行的结果都可能不一样*

**分析:**  
主要是因为运算方法和打印方法分开执行(或者说是两个方法被执行的时间不确定)  
分析86679产生的原因:  
一共五个线程,当第一个线程进入方法运行到count--时,此时值变成9,但是由于执行打印方法不够快(没有无间隙执行打印命令),导致第二个线程进来了并且执行count--,此时值变成8,此时第一个线程(也有可能是第二个线程)执行打印语句,但此时值已经变成8,输出就是8.  
一个线程的执行过程中(方法没有完全执行完毕就算执行过程)被另外一个线程打断了,就称之为线程重路.  

**加上synchronized:**  
```java
public class Demo5 implements Runnable{
    private int count = 10;

    /**
     * run()方法的本质就是将count--
     */
    @Override
    public synchronized void run() {
        count--;
        System.out.print(count);
    }

    public static void main(String[] args) {
            Demo5 demo5 = new Demo5();
            for (int i = 0; i < 5; i++) {
                new Thread(demo5).start();
            }
    }
}
```
**此时输出的结果一定是98765**  

`demo5:`  
**结论:**  
在同一个类,在一个synchronized的方法执行中,非synchronized方法也是可以执行的.因为非synchronized没被锁.  

`demo6:`脏读问题  
```java
public class Account {
    String name;
    double salary;

    public synchronized void set(String name, double salary) {
        this.name = name;
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        this.salary = salary;
    }
    public double getSalary(String name){
        return this.salary;
    }

    public static void main(String[] args) {
        Account account = new Account();
        new Thread(()->account.set("张三",100)).start();	//创建一个线程,并设置属性
        System.out.println(account.getSalary("张三"));

        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(account.getSalary("张三"));
    }
}
```
**代码结果分析:**  
目前这里只对写入数据添加了同步锁,但没有对读取数据添加同步锁,根据上述知识可知同步方法和非同步方法可以同时执行.  
| 提示  | 实际打印结果 | 理想的打印结果 |
| :---: | :----------: | :------------: |
|       |     0.0      |     100.0      |
|       |    100.0     |     100.0      |

**出现错误结果的原因:脏读**  
由于写和读是两个线程操控的,当我代码执行到this.name=name;的时候就有可能被另外一个线程打断,去执行读的方法,显然此时写数据还没写完就会读到0.这个0可以理解为读到了还没有提交的数据(过时的数据),也就是脏读.  
但这不绝对,这主要取决你你的业务逻辑,如果你的业务就是支持脏读的,你不需要对读方法加锁(同时也会增加性能).哪个方法加锁哪个不加锁完全也是根据你的业务逻辑来的,所以你要考虑清楚.  

`demo7:`锁的可重入  
```java
public class Demo7 {
    public synchronized void m1() {
        System.out.println("m1");
        m2();
    }

    public synchronized void m2() {
        System.out.println("m2");
    }

    public static void main(String[] args) {
        new Demo6().m1();
    }
}
```
**代码说明:**  
在同一个线程当中(一定是同一个线程),m1和m2方法都锁住同一个对象.并且m1方法在执行的过程中调用了m2方法.  

**结果:**  
```shell
m1
m2
```

**原因分析:**  
当运行m1方法时,会给当前对象加上一把锁,然后m1方法体又去执行了m2方法,但是m2又需要当前对象的锁.貌似不太合适  
但是由于在同一个线程当中如果后面的方法要加的锁是当前锁的对象,那么就没有问题.  
注意一定是同一个线程.这种情况称之为锁的<font color="#00FF00">可重入</font>.  

`demo8:`死锁  
**产生原因:**  
*可以从操作系统的层面说明死锁产生的四个必要条件*  
* 互斥条件:进程对所分配到的资源进行排他性使用,即在一段时间内,某资源只能被一个进程占用.如果此时还有其他进程请求该资源,则请求进程只能等待,死锁就不会发生.  
* 请求和保持条件:进程已经占有了至少一个资源,但又提出了新的资源请求,而该被请求的资源以被其它进程占有,此时请求进程被阻塞,同时其对自已的资源保持不放.  
* 不可抢占条件:进程已获得的资源在未使用完之前不能抢占,只能在进程使用完时由其自已释放.  
* 循环等待条件:该条件指发生死锁时,必然存在一个"进程-资源"循环链,即进程集合{P0、P1、P2...Pn}中的P0正在等待已被P1占用的资源,P1正在等待已被P2占用的资源,......,Pn正在等待以被P0占用的资源

*从JVM层面说明死锁产生的条件*  
发生在多个线程中,如果现在有两个(多个)线程,第一个线程先锁住A对象,再锁住B对象.第二个线程先锁住B对象,再锁住A对象.  
当第一个线程锁完A,第二个线程锁完B时.如果第一个线程要锁B就要等待第二个线程释放B锁,但第二个线程释放B锁的前提是代码执行结束,要代码执行结束就需要锁A锁,此时第一个和第二个线程都无法释放锁造成死锁.  

```java
public class Demo8 {
    Object o1 = new Object();
    Object o2 = new Object();

    public void m1() {
        synchronized (o1) {
            try {
                Thread.sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (o2) {
                System.out.println("m1");
            }
        }
    }

    public void m2() {
        synchronized (o2) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (o1) {
                System.out.println("m2");
            }
        }
    }

    public static void main(String[] args) {
        Demo7 demo7 = new Demo7();
        new Thread(() -> {		//对同一对象产生两个线程.
            demo7.m1();
        }).start();
        new Thread(() -> {
            demo7.m2();
        }).start();

    }
}
```

`demo9:`通过父类实现锁可重入  
```java
public class Demo9 {
    public synchronized void m(){
        System.out.println("father");
    }

    public static void main(String[] args) {
        new Deom8Children().m();
    }
}

class Deom8Children extends Demo9 {
    public synchronized void m(){
        System.out.println("Children");
        super.m();
    }
}
```

**打印结果:**  
```
children
father
```

**原因:**  
还是同一个线程中的原因.注意这里锁定的是同一个对象  

`demo10:`  
**知识点:**  
程序在执行过程中,如果出现异常,默认情况锁会被释放  
所以在并发处理的过程中,有异常要多加小心,不然可能会发生不一致的情况  

```java
public class Demo9 {
    public synchronized void t1() {
        int i = 0;
        while (true) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("tOne" + i);
            i++;
            if (i == 5) {		//当i增加到5的时候抛出异常
                i = 1 / 0;
            }
        }
    }

    public synchronized void t2() {
        System.out.println("t2start");
    }

    public static void main(String[] args) {
        Demo9 demo9 = new Demo9();
        new Thread(()->demo9.t1()).start();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        new Thread(()->demo9.t2()).start();		//一旦t1抛出异常,t2立即获得该锁
    }
}
```

**代码说明:**  
此时如果有一份资源,被多个线程访问,如果获得那把锁的线程(第一个线程)数据处理到一半时发生了异常,如果不处理异常(使用异常抛出),直接释放锁.那么紧接着获得这把锁的线程访问到的数据将是你处理到一半的错误数据.  

**打印结果:**  
```shell
tOne0
tOne1
tOne2
tOne3
tOne4
t2start
```

`demo11`:volatile关键字  
**作用:**  
volatile关键字使一个变量在多个线程间可见  

```java
public class Demo11 {
    private boolean running = true;
    public void m(){				
        System.out.println("mStart");
        while (running){			//死循环方法
        }
        System.out.println("mEnd");
    }

    public static void main(String[] args) {
        Demo11 demo11 = new Demo11();
        new Thread(()->demo11.m()).start();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        demo11.running=false;
    }
}
```

**解决办法:** 加上volatile关键字  
加上这个关键字并不代表,线程每次运行都会去读取主内存中的内容,而是当被加关键字的属性发生改变时,会通知所有的线程数据(缓冲区数据)已经过期,需要重新读取.  
```java
public class Demo11 {
    private volatile boolean running = true;		//加上关键字
    public void m(){
        System.out.println("mStart");
        while (running){
        }
        System.out.println("mEnd");
    }

    public static void main(String[] args) {
        Demo11 demo11 = new Demo11();
        new Thread(()->demo11.m()).start();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        demo11.running=false;
    }
}
```
*注意:*  
如果这里的死循环不是一个空循环,而是中间存在一些语句,那么就不会出现上面所说的那种情况(设置false无效).  
*原因:*  
如果你的循环里面有一些sleep语句打印语句之类的,可能执行的时候会使CPU空出时间,从而CPU回去读取主内存的数据.(很模糊,原因比较复杂)  
*另外:*  
如果这个方法加上了线程同步synchronized也不会出现这样的问题.但是使用volatile的效率要比synchronized高很多.但是volatile不能代替synchronized,因为volatile只有可见性,而synchronized既有可见性又有原子性.  

`demo12:`  
```java
public class Demo12 {
    volatile int count = 0;
    public void m (){
        for (int i = 0; i < 1000; i++) {
            count++;
        }
    }

    public static void main(String[] args) {
        Demo12 demo12 = new Demo12();
        List<Thread> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            list.add(new Thread(()->demo12.m()));//创建十个线程对象
        }
        list.forEach((t)->t.start());//遍历容器启动线程
        list.forEach((t)-> {
            try {
                t.join();//保证当前的每个线程执行完毕后才执行下一线程
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        try {
            Thread.sleep(3000);//保证线程代码运行结束
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(demo11.count);
    }
}
```
理想的打印情况:10000  
实际的打印情况:小于10000  

**原因:**  
主要还是因为volatile虽然读可见,但是写不可见.  
当第一个线程从主内存中读取到数据为100,放到缓冲区进行自增为101,但还没有写给主内存的时候.第二个线程从主内存读取数据也为100,同样放到缓冲区进行自增为101,并提交数据给主内存,此时主内存count为101.第二个线程提交结束后第一个线程紧接着提交数据也为101.此时虽然是增加了两次数据但写出的时候是以覆盖的形式写出的.  

**volatile和synchronized的区别:**  
* volatile:效率较高,只保证可见性.
* synchronized:效率较低,保证可见性和原子性.  

如果只需要保证可见性的时候使用volatile.

**解决方法:**  
为m方法增加synchronized,删除volatile(没必要在存在了)  

`demo13:`
如果你只是进行一些++这种简单的运算,可以使用Atomic家族类(不同的类型类名不同)  
```java
public class Demo13 {
    AtomicInteger count = new AtomicInteger(0);		//AtomicInteger针对Integer类型,构造方法丢入默认值
    public void m() {
        for (int i = 0; i < 1000; i++) {
            count.incrementAndGet();		//相当于自增操作
        }	
    }

    public static void main(String[] args) {
        Demo13 demo13 = new Demo13();
        List<Thread> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            list.add(new Thread(() -> demo13.m()));
        }
        list.forEach((t) -> t.start());
        list.forEach((t) -> {
            try {
                t.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        System.out.println(demo13.count);
    }
}
```
**特性:**  
Atomic家族类的方法都是具有原子性的,但用的不是synchronized而是非常底层的东西,所以效率比较高.  

**问题:**  
但是Atomic类的多个方法之间并不构成原子性  
```java
public class Demo13 {
    AtomicInteger count = new AtomicInteger(0);
    public void m() {
        for (int i = 0; i < 1000; i++) {
            int temp = count.incrementAndGet();// 1
            count.set(temp);                   // 2
        }
    }

    public static void main(String[] args) {
        Demo13 demo13 = new Demo13();
        List<Thread> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            list.add(new Thread(() -> demo13.m()));
        }
        list.forEach((t) -> t.start());
        list.forEach((t) -> {
            try {
                t.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        System.out.println(demo13.count);
    }
}
```
**原因:**  
有点类似之前的情况,方法1和方法2之间不是顺序执行的.  
第一个线程执行到1步骤时,增加到了101,还没有执行步骤2时.线程2进来了将数据增加到102后,并运行步骤2设置值为102.此时线程一继续执行步骤2将值设置为101.  

`demo14:`关于synchronized优化问题  
**结论:**  
同步代码块中的语句越少越好

```java
public class Demo13 {
    int count = 0;

    public synchronized void m1() {
        count++;
        System.out.println(count);
    }

    public void m2() {
        synchronized (this) {
            count++;
        }
        System.out.println(count);
    }
}
```

比较m1和m2方法:  
m1的锁将整个方法全部锁定  
m2只在业务逻辑里面增加了同步锁,所以m2的效率比m1要高.  
细力度的锁  

`demo15:`永远不要锁一个字符串对象  
```java
public class Demo14 {
    String s1 = "String";
    String s2 = "String";

    public void m1() {
        synchronized (s1) {
        }
    }

    public void m2() {
        synchronized (s2) {
        }
    }
}
```
你以为m1和m2方法锁定的是两个不同的对象,但实际上s1和s2锁定的是同一个对象.  
原因:分析jvm内存  
栈内存中的s1和s2指向堆内存中的两个对象,因为是字符串常量,所以堆内存中的两个对象又指向堆中的字符串常量池(又因为内容相同,所以指向同一个字符串常量),所以这两个是同一个对象.

`demo16:`曾经淘宝面试题  
有一个容器,A线程负责给容器添加10个元素.B线程负责监视这个容器直到容器大小为5的时候打印一个通知.  

写法一:  
```java
public class Demo15 {
    volatile List list = new ArrayList<>();

    public void add(Object o) {
        list.add(o);
    }

    public int size() {
        return list.size();
    }

    public static void main(String[] args) {
        Demo15 demo15 = new Demo15();
        new Thread(() -> {
            while (true) {
                if (demo15.size() == 5) {
                    System.out.println("数量达到5");
                    break;
                }
            }
        }).start();
        new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                demo15.add(i);
            }
        }).start();
    }
}
```
**问题:**  
使用while(true)太浪费资源,并且线程二的监测不是那么的精准.

**思路:**  
使用wait和notify以及notifyAll  
wait和notify的用法:javaSE中有讲到过  
这两个方法只能是被锁定对象去调用.  
wait:当一个线程的方法获已经得到锁,但是条件没有满足无法执行语句的时候,调用被锁的对象的wait方法,可以暂停该线程,并释放锁.  
notify:调用一个被锁住对象的notify方法,会唤醒正在这个对象上等待的某一个线程.继续执行调用wait方法后面的代码,不是重新进方法.  
但是nofity方法不会释放锁,而且被唤醒的线程需要重新获得锁.  
notifyAll:和notify类似,只不过会唤醒这个对象的所有线程.  

写法二:  
```java
public class Demo15 {
    volatile List list = new ArrayList<>();
    boolean flag = true;
    public synchronized void add(Object o) {
        if(flag){
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("add");
        list.add(o);
        flag=true;
        this.notify();
    }

    public synchronized int size() {
        if(!flag){
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("size");
        flag=false;
        this.notify();
        return list.size();
    }

    public static void main(String[] args) {
        Demo15 demo15 = new Demo15();
        new Thread(() -> {
            while (true) {
                if (demo15.size() == 5) {
                    System.out.println("数量达到5");
                    break;
                }
            }
        }).start();
        new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                demo15.add(i);
            }
        }).start();
    }
}
```

**问题:**  
还是需要while(true),而且当线程一结束之后,线程二就会wait造成算法无法结束.

写法三:  
```java
public class Demo16 {
    volatile List list = new ArrayList<>();

    public void add(Object o) {
        list.add(o);
    }

    public int size() {
        return list.size();
    }

    public static void main(String[] args) {
        Demo16 demo15 = new Demo16();
        new Thread(() -> {
            synchronized (demo15){
                System.out.println("线程开头");
                if (demo15.size() != 5) {
                    try {
                        demo15.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                System.out.println("数量达到5");
            }

        }).start();
        new Thread(() -> {
            synchronized (demo15){
                for (int i = 0; i < 10; i++) {
                    demo15.add(i);
                    if(demo15.size()==5){
                        demo15.notify();
                    }
                    System.out.println(demo15.size());
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }
}
```
**输出结果:**  
| 线程开头 |   1   |   2   |   3   |   4   |   5   |   6   |   7   |   8   |   9   |  10   | 数量5 |
| :------: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |

**原因:**  
当数量达到5的时候,线程一虽然被唤醒了,但是需要重新获得这把锁.由于notify方法不会释放锁,所以需要等待线程二方法执行完毕线程一才可以获得锁.

写法四:  
```java
public class Demo16 {
    volatile List list = new ArrayList<>();
    boolean flag = true;

    public void add(Object o) {
        list.add(o);
    }

    public int size() {
        return list.size();
    }

    public static void main(String[] args) {
        Demo16 demo15 = new Demo16();
        new Thread(() -> {
            synchronized (demo15) {
                if (demo15.size() != 5) {
                    try {
                        demo15.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                System.out.println("数量达到5");
                demo15.notify();
            }

        }).start();
        new Thread(() -> {
            synchronized (demo15) {
                for (int i = 0; i < 10; i++) {
                    demo15.add(i);
                    System.out.println(demo15.size());
                    if (demo15.size() == 5) {
                        demo15.notify();
                        try {
                            demo15.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }).start();
    }
}
```

**输出结果:**  
| 线程开头 |   1   |   2   |   3   |   4   |   5   | 数量5 |   6   |   7   |   8   |   9   |  10   |
| :------: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |

**原因:**  
正是因为notify不会释放锁,所以调用完notify在调用wait方法释放锁,所以这里wait不是用于暂停线程的,而是用于释放锁的.  

写法五:使用门栓  
```java
public class Demo17 {
    volatile List list = new ArrayList<>();

    public void add(Object o) {
        list.add(o);
    }

    public int size() {
        return list.size();
    }

    public static void main(String[] args) {
        Demo17 demo15 = new Demo17();
        CountDownLatch latch = new CountDownLatch(1);
        new Thread(() -> {
            System.out.println("线程一启动");
            if(demo15.size()!=5){
                try {
                    latch.await();//直到调用latch.countDown();方法否则方法暂停在这
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("数量达到5");
            }
        }).start();
        new Thread(() -> {
            for (int i = 0; i <10 ; i++) {
                demo15.add(i);
                System.out.println(demo15.size());
                if(demo15.size()==5){
                    latch.countDown();			//门栓打开
                }
            }

        }).start();
    }
}
```
**问题:**  
有时结果输出正确,有时不正确.只能保证线程一会执行,但不能保证顺序.

**优点:**  
效率高(没有同步快)  

`demo17:`ReentrantLock  
**介绍:**  
ReentrantLock用于替代`synchronized`  
ReentrantLock实现了<font color="#FF00FF">Lock</font>接口
```java
public class Demo18 {
    Lock lock = new ReentrantLock();

    public void m1() {
        lock.lock();					//锁住
        try {
            for (int i = 0; i < 10; i++) {
                System.out.println(i);
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();				//在finally中手动释放锁
        }
    }

    public void m2() {
        lock.lock();
        System.out.println("m2");
        lock.unlock();
    }

    public static void main(String[] args) {
        Demo18 demo18 = new Demo18();
        new Thread(() -> demo18.m1()).start();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        new Thread(() -> demo18.m2()).start();
    }

}
```
**注意:**  
必须要手动释放锁,使用synchronized锁定如果遇到异常,jvm会自动释放,但是lock必须手动释放锁,因此经常在finally中进行锁的释放  

`demo18:`  
可以通过ReentrantLock的tryLock方法进行尝试性的加锁,这个方法会返回一个布尔值.你可以根据这个返回值来进行你想要的操作.比如返回值为false不可锁定我可能会执行别的方法而不是像synchronized那样只能干等着.  
```java
public class Demo19 {
    Lock lock = new ReentrantLock();

    public void m1() {
        lock.lock();
        try {
            for (int i = 0; i < 10; i++) {
                System.out.println(i);
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }

    public void m2() {
        boolean locked = false;
        try {
            /*
            另外一种用法
            参数一:锁定的时间	
            参数二:锁定时间的单位	
            这是个阻塞方法,就是如果这么长时间还不能获得到这把锁就返回false,一旦可以锁定就返回true
            */
            locked = lock.tryLock(5, TimeUnit.SECONDS);			
            System.out.println("m2方法是否可以锁定");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }finally {
            if(locked){			//如果已经锁定
                lock.lock();		//释放锁
            }
        }

    }

    public static void main(String[] args) {
        Demo19 demo18 = new Demo19();
        new Thread(() -> demo18.m1()).start();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        new Thread(() -> demo18.m2()).start();
    }

}
```
 
`demo19:`  
使用ReentrantLock还可以调用lockInterruptibly方法,可以对线程interrupt做出响应.
```java
public class Demo19 {
    public static void main(String[] args) {
        Lock lock = new ReentrantLock();
        new Thread(() -> {
            lock.lock();
            System.out.println("线程1");
            try {
                Thread.sleep(Integer.MAX_VALUE);		//谁很长时间
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                lock.unlock();
            }
        }).start();

        Thread thread = new Thread(() -> {
            boolean locked = false;
            try {
                lock.lockInterruptibly();//这种锁可以对interrupt方法做出响应
                System.out.println("线程2");
                locked = true;		//只有进入到该方法才能证明执行成功,因为如果出现异常会直接跳到catch里面
            } catch (InterruptedException e) {
                System.out.println("线程2被打断");
            } finally {
                if (locked) {
                    lock.unlock();
                }
            }
        });
        thread.start();
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        thread.interrupt();     //打断线程二的等待,如果被打断会直接抛出异常
    }
}
```
**结果:**  
线程1  
线程2被打断  



