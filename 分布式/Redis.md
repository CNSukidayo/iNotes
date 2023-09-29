# 目录:  
A.基础篇  
B.高级篇  
C.实战篇  

# 基础篇
**目录:**  
1.10大数据类型  
2.Redis持久化  
3.Redis事务  
4.Redis管道  
5.Redis发布订阅  
6.Redis复制机制  

**附录:**  
A.Redis基本环境搭建  
B.Redis命令大全  

## 1. 10大数据类型

**注意:** 一般类型说的都是value的类型,key一直都是string  
**哪里获取命令的操作手册:**  
[Redis官网命令手册](https://redis.io/commands/)  
[中文命令手册](http://redis.cn/commands.html)  
详情可见附录  

**目录:**  
1.1 String(字符串)  
1.2 List(列表)  
1.3 Hash(哈希表)  
1.4 Set(集合)  
1.5 ZSet(有序集合)  
1.6 GEO(地理空间)  
1.7 HyperLogLog(基数统计)  
1.8 bitmap(位图)  
1.9 bitfield(位域)  
1.10 Stream(流)

### 1.1 String(字符串)  

**介绍:**  
一个Key对应一个Value;String类型是二进制安全的,二进制安全就是String可以包含任意数据,比如jpg图片或者序列化对象;String类型最大为512M  

### 1.2 List(列表)  

**介绍:**  
Redis列表是简单的字符串列表,可以将元素添加到列表的头部或者尾部;素以它实质上就是一个双端链表,最多可以包含2^32-1个元素.  

**特点:**  
主要功能有push/pop,一般用在栈、队列、消息队列等场景.  
由于是双端链表,所以可以对头和尾节点操作,并且效率是很高的;如果对中间的小标做操作则性能较差.  
如果key不存在则会创建key  
如果所有的value都不存在了,则key也消失了  

### 1.3 Hash(哈希表)  

**疑问:** 你会问和String类型有什么区别  
*提醒:Redis的类型说的是value的类型,也就是说Redis-Hash类型表明value的类型是Hash类型;整体看就是 Key (Key Value)*  

*相当于:Map<String,Map<Object,Object>>* 

### 1.4 Set(集合)  

**介绍:**  
同样也是字符串集合,不允许元素重复的类型,最多可以包含2^32-1个元素.Set是通过哈希表实现的,所以添加、删除、查找的时间复杂度都是O(1)  

**区别:**  
Set和List的区别,两者都是集合;还是那句话一个表明value的类型是List,一个表明value的类型是Set;就是说Redis的List类型中的元素允许重复,Redis的Set类型中的元素不允许重复   

### 1.5 ZSet(有序集合)  

**介绍:**  
字符串集合,不允许元素重复的类型,最多可以包含2^32-1个元素.ZSet是通过哈希表实现的,所以添加、删除、查找的时间复杂度都是O(1)  

**特点:**  
每个元素都关联一个double类型的分数,Redis通过分数来为集合中的元素进行从小到大排序.  
Set集合是:key value0 value1...  
ZSet集合是:key score:value0 score:value1...  

### 1.6 GEO(地理空间)  

**介绍:**  
主要用于存储地理位置,并对存储的信息进行操作;包括:  
* 添加地理位置的坐标  
* 获取地理位置的坐标
* 计算两个位置之间的距离  
* 根据用户给定的金纬度坐标来获取指定范围内的地理位置的集合  

**特点:**  
如果用`type`命令查看GEO的类型,它的返回值实际上是ZSet;

### 1.7 HyperLogLog(基数统计)  

**介绍:**  
HyperLogLog是用来做基数统计的算法,HyperLogLog的优点是,在输入元素的数量或者体积非常非常大时,计算基数所需的空间总是固定且是
很小的.  
在Redis里面,每个HyperLogLog键只需要花费12KB内存,就可以计算接近2へ64个不同元素的基数,这和计算基数时,元素越多耗费内存
就越多的集合形成鲜明对比.  
但是,因为<font color="#00FF00">HyperLogLog只会根据输入元素来计算基数,而不会储存输入元素本身,所以HyperLogLog不能像集合那样,返回输入的各个元素</font>.  

**场景:**  
统计某个网站的UV(unique visitor)、统计某个文章的UV  
UV就是独立访客,例如统计某个文章的访问量,同一个IP多次访问肯定是只算一次的;但是又不需要把每次访问的IP都存到数据库中,直接在Redis中就完成这个操作,所以UV是需要考虑去重的.  

**特点:**  
HyperLogLog的作用只用户统计,不做保存;比如HyperLogLog可以统计出当前文章的访问量是多少,但是HyperLogLog无法返回给你哪些IP看过这个文章.<font color="#00FF00">HyperLogLog有0.81%的误差</font>  
如果用`type`命令查看HyperLogLog的类型,它的返回值实际上是String;但是你没办法通过get得到它的内容



### 1.8 bitmap(位图)

**介绍:**  
由01状态表现的二进制位的bit数组,所以这就是个bit类型;想想最终返回的类型也是0101100这种.  

**特点:**  
bitmap的底层还是Stirng;如果用`type`命令查看bitmap的类型,它的返回值实际上是String

### 1.9 bitfield(位域)  

**介绍:**  
通过bitfield命令可以一次性操作多个<font color="#FF0000">比特位域(指的是连续的多个比特位)</font>,它会执行一系列操作并返回一个响应数组,这个数组中的元素对应参数列表中的相应操作的执行结果.  
说白了就是通过bitfield命令我们可以一次性对多个比特位域进行操作.  

*提示:目前阶段了解即可,这个用的不是很多*

**解释:**  
假设对于字符串"Redis",它在Redis中是咋存储的?究极根本字符串在计算机中的存储是以ASCII码来存储的,而8位二进制构成一个ASCII码,所以最终该字符串就是一个二进制.  
假设现在我要把Redis改为redis;就是把第一个字母从大写改成小写;以前的思路是用set把它覆盖掉.  
那么利用bitfield直接把它的二进制改掉不就可以了,也就是先定位到Redis中字符R对应的ASCII码,然后把该ASCII码中对应的几个二进制改成r的ASCII码二进制即可.  

### 1.10 Stream(流)

**介绍:**  
Redis版本的消息中间件,Redis本身是有一个Redis发布/订阅(pub/sub)来实现消息队列的功能,但是它有个缺点就是消息无法持久化,如果出现网络断开、Redis宕机等,消息就会被丢弃.  

**由来:**  
Redis实际上也可以实现消息中间件的特性,一共有两种方案:  
* 利用List列表来实现,之前说过List列表是双端链表;左右两端可以同时进和同时出,那么就一端进一端出就可以实现消息队列了;但这种方式是点对点的形式.  
* 利用Redis的发布和订阅(pub/sub)可以实现消息的广播;但是Redis相较于传统的消息中间件,它不支持持久化;如果网络断开、Redis宕机消息就会丢失.而且也没有ACK机制来保证数据的可靠性.  

<font color="#00FF00">Redis的Stream就是消息中间件+阻塞队列</font>

**特点:**  
实现消息队列,它支持消息的持久化、支持自动生成全局唯一ID、支持ACK确认消息的模式、支持消费组模式等,让消息队列更加的文档和可靠.如果用`type`命令查看Stream的类型,它返回的就是stream  

**结构:**  
![Stream结构](resources/redis/3.png)

|        属性        |                                                                                                         解释                                                                                                         |
| :----------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|  Message Content   |                                                                                                       消息内容                                                                                                       |
|   Consumer Group   |                                                                            消费组,通过XGROUP CREATE 命令创建,同一个消费组可以有多个消费者                                                                            |
| Last_deliveryed_id |                                                     游标,每个消费组会有一个游标Last_deliveryed_id,任何一个组内成员读取了消息都会使游标Last_deliveryed_id往前移动;<font color="#00FF00">比如一个消费组要消费10条记录,一旦有消费者消费了第1条,那么游标就指向第2条消息</font>                                                     |
|      Consumer      |                                                                                               消费者,消费组中的消费者                                                                                                |
|    Pending_ids     | 这是一个数组,用于保存当前组内已经读取过该消息的但还没有ACK确认的消费者的id;如果客户端没有ACK则该数组内的消息id会越来越多,一旦某个记录被ack它就开始减少.它用来确保客户端至少消费了一次,而不会在网络传输的中途丢失处理 |

个人理解的结构:
```java
public class Stream{
  private MessageContent messageContent;
  private int[] consumerIdGroup;
  private Iterator<Integer> lastDeliveryedId;
  private Consumer[] consumer;
  private int[] pendingIds;
}
```

**解释:**  
实际上消息就是一个数据结构  
每个消息都有它们的id;每个消息也有它对应的消息内容;每个消息还封装了它的消费者组的id;  
通过消费者组id就能得到组内的消费者是哪些(从而实现广播的机制)

## 2.Redis持久化
**目录:**  
2.1 总体介绍  
2.2 RDB  
2.3 AOF  
2.4 RDB+AOF混合持久化  
2.5 纯缓存模式  


### 2.1 总体介绍  
**持久化类型分类:** RDB、AOF、混合模式
RDB:Redis DataBase  
AOF:Append Only File  
混合模式:RDB+AOF  

1.RDB持久化方式  
拍摄快照的方式,把内存中的数据快照到磁盘上  
恢复的时候把打包的内存数据RBD恢复到内存  

2.AOF持久化方式  
类似于写日志文件的方式,将每条执行的命令append到日志文件上  
恢复的时候一条一条地执行文件中的命令  

![持久化方式](resources/redis/4.png)  

### 2.2 RDB  
**目录:**  
2.2.1 介绍  
2.2.2 自动触发  
2.2.3 手动触发  
2.2.4 RDB的优势  
2.2.5 RDB的劣势  
2.2.6 RDB修复命令    

#### 2.2.1 介绍  
1.RDB持久化是以指定的时间间隔执行数据集的时间点快照  

2.实现类似照片记录效果的方式,就是把某一时刻的数据和状态以文件的形式写到磁盘上,也就是快照.这样一来就是故障宕机,快照文件也不会丢失,数据的可靠性也就得到了保证.  

3.在指定的时间间隔内将内存中的数据集快照写入磁盘,也就是行话讲的snapshot内存快照,它恢复时再将硬盘快照文件直接读回到内存里.  
Redis的数据都在内存里,保存备份时它执行的是<font color="#FF0000">全量快照</font>,也就是说,把内存中的所有数据都记录到磁盘中.

4.设置RDB的持久化规则  
<font color="#00FF00">附录=>A.Redis基本环境搭建=>redis.conf</font>  

#### 2.2.2 自动触发 
1.只要满足redis.conf配置文件中`save [second] [count]` 指定的值就会自动持久化  

2.类似`flushdb`命令也会导致Redis序列化到磁盘  

3.`shutdown`命令会导致Redis序列化到磁盘  

#### 2.2.3 手动触发
**介绍:**  
Redis提供了两个命令来生成RDB文件,分别是save和bgsave  
**<font color="#FFC800">生产中只允许用bgsave;不允许用save</font>**  

1.Redis是如何进行手动触发的  
参照官方文档,在调用save或bgsave命令的时候,Redis会新开一个子进程(child process)去序列化当前的内存文件.

2.为什么不能用save序列化?  
**解释:**  
在主程序中执行会阻塞当前的Redis服务器,直到Redis持久化工作完成.执行save命令期间,Redis不能处理其它命令,**线上禁止使用**.  

3.bgsave的特点  
Redis会在后台异步进行快照操作,<font color="#FFC800">不阻塞</font>快照同时还可以响应客户端请求,该触发方式会fork一个子进程由子进程复制持久化过程.  
<font color="#FFC800">Redis自动触发备份默认走的是bgsave模式</font>

4.`lastsave` 获取上一次备份的时间  

#### 2.2.4 RDB的优势
* RDB是Redis数据的一个非常紧凑的单文件时间点表示.RDB文件非常适合备份.例如,您可能希望在最近的24小时内每小时归档一次RDB文件,并在30天内每天保存一个RDB快照.这使您可以在发生灾难时轻松恢复不同版本的数据集.  
* RDB非常适合灾难恢复,它是一个可以传输到远程数据中心或AmazonS3(可能已加密)的压缩文件.  
* RDB最大限度地提高了Redis的性能,因为Redis父进程为了持久化而需要做的唯一工作就是派生一个将完成所有其余工作的子进程.父进程永远不会执行磁盘I/O或类似操作.  
* 与AOF相比,RDB允许大数据集更快地重启.  
* 在副本上,RDB支持重启和故障转移后的部分重新同步.

**小总结:** 适合大规模的数据恢复、对照业务定时备份、对数据完整性和一致性要求不好、RDB文件在内存中的加载速度比AOF快很多.

#### 2.2.5 RDB的劣势
* 如果您需要在Redis停止工作时(例如断电后)将数据丢失的可能性降到最低,那么RDB并不好.您可以配置生成RDB的不同保存点(如,在对数据集至少5分钟和100次写入之后,您可以有多个保存点).但是,您通常会每五分钟或更长时间创建一次RDB快照,因此,如果Redis由于任何原因在没有正确关闭的情况下停止工作,您应该准备好丢失最新几分钟的数据.
* RDB需要经常fork()以便使用子进程在磁盘上持久化.如果数据集很大,fork()可能会很耗时,并且如果数据集很大并且CPU性能不是很好,可能会导致Redis停止为客户端服务几毫秒甚至一秒钟.AOF也需要fork()但频率较低,您可以调整要重写日志的频率.而不需要对持久性进行任何权衡.

**小总结(劣势):**  
* RDB的备份方式是在一定时间内做备份,如果Redis意外宕机的话就会导致从当前至最新一次的快照数据丢失.  
* 内存数据的全量同步,如果数据量太大会导致I/O严重影响服务器性能.  
* RDB依赖于主进程的fork,而fork子进程时,子进程时会拷贝父进程的页表,即虚实映射关系;在很大的数据集中这可能会导致服务请求的瞬间延迟.fork时内存中的数据被克隆了一份,大致2倍膨胀;需要慎重.  

#### 2.2.6 RDB修复命令
查看:基础篇=>附录=>A.Redis基本环境搭建=>4.安装文件说明=>redis-check-rdb  
**作用:**  
`redis-check-rdb [file.rbd]` 修复破损的RDB文件(需要来到file.rbd文件所在路径下执行该命令)  

### 2.3 AOF
**目录:**  
2.3.1 基本介绍  
2.3.2 AOF文件的持久化流程  
2.3.3 多AOF持久化文件  
2.3.4 修复AOF文件  
2.3.5 AOF的优势  
2.3.6 AOF的劣势  
2.3.7 AOF的重写机制  

#### 2.3.1 基本介绍
1.基本介绍
以日志的形式来记录每个写操作,将Redis执行过的所有写指令记录下来(读操作不记录),只许追加文件但不可以改写文件,redis启动之初会读取该文件重新构建数据,换言之,redis重启的话就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作.  

2.开启AOF持久化  
默认情况下Redis是没有开启AOF持久化的  
`appendonly [yes|no(default)]` 设置appendonly为yes开启AOF  

3.持久化文件名称  
默认aof的持久化文件名称为:appendonly.aof  
`appendfilename [fileName(default="appendonly.aof")]`  设置AOF持久化文件的名称  

4.持久化文件路径  
`appenddirname [dir(default="appendonlydir")]` 设置AOF持久化文件的路径;  
注意该路径最终的效果是`dir`+`appenddirname`;也就是说会在配置文件`dir`的目录下的`appenddirname`目录下创建aof文件.  
查看:基础篇=>附录=>A.Redis基本环境搭建=>5.redis.conf


#### 2.3.2 AOF文件的持久化流程
*提示:AOF只记录Redis的增删改操作不记录查询操作*  

1.客户端提交命令到Redis服务器  

2.Redis服务器产生的AOF日志内存并不是实时写回到AOF文件中,而是先写入一个**AOF缓冲区**,它就类似MySQL中的日志,MySQL中的日志也不是实时写入磁盘中,也是写入一个内存的缓冲区中.所以AOF缓冲区也是Redis在内存中开辟的一块区域  

3.写入到AOF缓冲区的AOF日志文件会有三种不同的策略来刷盘  
策略的设置见:基础篇=>附录=>A.Redis基本环境搭建=>5.redis.conf  

* always:同步写回,每个写命令执行完立刻同步地将日志写回磁盘(很安全但是性能不高)  
* everysec(默认):每秒写回,每隔一秒将AOF缓冲区的内容写入刷盘
* no:由操作系统控制写回,每个写命令执行完只是先把AOF日志文件写入到内存缓冲区,由操作系统决定何时将缓冲区内容写入磁盘.  

性能小总结:  
![性能小总结](resources/redis/5.png)  

4.为了避免写入到磁盘上的AOF文件过度膨胀,会根据规则进行命令的合并(即AOF重写),从而起到压缩AOF的作用.  

5.Redis重启时根据AOF文件恢复数据  

#### 2.3.3 多AOF持久化文件
*高版本使用多AOF文件持久化策略*  
现在一个AOF文件由三个文件构成即:appendonly.aof.1.base.rdb、appendonly.aof.1.incr.aof、appendonly.aof.manifest;当然文件的名称还是通过`appendfilename`来指定  
* base:表示基础AOF,它一般由子进程通过重写产生,该文件最多只有一个  
* incr:表示增量AOF,它一般会在AOFRW开始执行时被创建,该文件可能存在多个(一般Redis的写操作会持久化到该文件里)  
* history:表示历史AOF,它由base和incr AOF变化而来,每次AOFRW成功完成时,本次AOFRW之前对应的base和incr AOF都将变为history,history类型的AOF会被Redis删除.  

为了管理这些AOF,引入了一个manifest(清单)文件来跟踪、管理这些AOF.同时,为了便于AOF备份和拷贝,我们将所有的AOF文件和manifest文件放入一个单独的文件目录中,目录名由`appenddirname`来决定.  

#### 2.3.4 修复AOF文件  
来带AOF持久化文件的路径下,ls查看当前路径下有哪些文件:  
```shell
ls
appendonly.aof.1.base.rdb  appendonly.aof.1.incr.aof  appendonly.aof.manifest
```
其中写Redis的语句会被保存到appendonly.aof.1.incr.aof文件内,再次提醒AOF文件不会记录Redis查询操作.实际上可以直接通过vim命令来编辑该文件,里面存放的就是一条条写入Redis的语句.  

1.现在模拟Redis错误写入  
在`appendonly.aof.1.incr.aof`文件的末尾随便加上一段乱码字符,然后关闭Redis;  
再次重启Redis会发现在AOF文件错误的情况下(假设现在不使用RDB文件)Redis服务器根本无法启动.  

2.修复AOF文件  
查看:基础篇=>附录=>A.Redis基本环境搭建=>4.安装文件说明=>redis-check-aof  
**作用:**  
`redis-check-aof --fix [filePath]` 修复破损的AOF文件  
* `filePath`:修复的文件路径

**举例:**  
`redis-check-aof --fix appendonly.aof.1.incr.aof` 一般修复就是修复`appendonly.aof.1.incr.aof`这个文件,注意一定要来到`appendonly.aof.1.incr.aof`文件所在的目录下执行该命令 

#### 2.3.5 AOF的优势  
* 使用AOF的Redis更加持久:  
  通过`appendfsync`配置来指定不同的fsync策略,如由操作系统决定刷盘、每秒刷盘、每次写入时刷盘.使用每秒fsync的默认策略,写入性能依旧很棒.fsync是使用后台线程执行的,当没有fsync正在进行时,主线程将努力执行写入,因此最多只会丢失一秒钟的写入.  
* AOF日志文件是追加写入(append),所以不会造成大量的随机磁盘I/O;即使出现某种原因使得写日志出现问题,也可以通过`redis-check-aof `工具来修复AOF文件.  
* 当AOF变得太大时,Redis能够在后台自动重写AOF,重写是完全安全的,因为当Redis继续附加到旧文件时,会使用创建当前数据集所需的最少操作集生成一个全新的文件,一旦第二个文件准备就绪,Redis就会切换两者并开始附加到新的哪一个(没读懂)  
* AOF以易于理解和解析的格式依次包含所有操作的日志,您甚至可以轻松导出AOF文件.例如,即使您不小心使用该FLUSHALL命令刷新了所有内容,只要在此期间没有执行日志重写,仍然可以通过停止服务器、删除最新命令并重新启动Redis来恢复数据.  

#### 2.3.6 AOF的劣势  
* AOF文件通常比相同数据集的等效RDB文件大  
* 根据确切的fsync策略,AOF可能比RDB慢.一般来说,将fsync设置为每秒写的性能依然非常高,并且在禁用fsync的情况下,即使在高负载下它也应该与RDB一样快.即使在巨大的写入负载的情况下,RDB仍然能够提供关于最大延迟的更多保证.(<font color="#00FF00">AOF运行效率慢于rdb,每秒fsync同步策略效率较高,不同步(交由操作系统刷盘)的效率和rbd相同</font>)  

#### 2.3.7 AOF的重写机制
*提示:重写是用于瘦身AOF文件过大而提出的,在2.3.5 AOF的优势的第三点提到过,这里做进一步说明*  
**介绍:**  
由于AOF持久化是Redis不断将写命令记录到AOF文件中,随着Redis不断的进行,AOF文件会越来越大这会导致服务器占用内存越大以及AOF恢复时间变长.  
为了解决这个问题,Redis新增了重写机制,当AOF文件的大小超过所设定的峰值时,Redis就会自动启动AOF文件的压缩机制,只保留可以恢复数据的最小数据集.  
或者手动使用`bgrewriteaof`命令来重写  

**重写的时机:**  
基础篇=>附录=>A.Redis基本环境搭建=>5.redis.conf=>`auto-aof-rewrite-percentage`和`auto-aof-rewrite-min-size`配置  
首先配置文件的小写必须满足`auto-aof-rewrite-min-size`的要求,其次本次文件校上次文件膨胀的比例达到`auto-aof-rewrite-percentage`之后才会触发重写.  

**什么叫保留最小数据集?**  
例如:  
```shell
set k1 v1
set k1 v2
set k1 v3
```
表面上是三条命令,实际上最终的效果只有`set k1 v3`这一条命令.  
所以只需要保存`set k1 v1`这一条命令即可  
当然也包括删除过期的Key等等;就是想办法瘦身  

**AOF重写流程:**  
*实验环境:将`aof-use-rdb-preamble`混合模式设置为no*  
最开始的时候`appenddirname`目录下有这三个文件`appendonly.aof.1.base.aof  appendonly.aof.1.incr.aof appendonly.aof.manifest`注意这里的文件和之前是不一样的(之前的base文件是rdb文件,这里是aof文件),`appendonly.aof.1.base.aof  appendonly.aof.1.incr.aof`这两个文件的大小都是0;现在开始往Redis中添加添加内容,随着添加的过程,appendonly.aof.1.incr.aof会慢慢膨胀;直到该文件大小膨胀到`auto-aof-rewrite-min-size`指定的大小时;再次查看目录下的文件有`appendonly.aof.2.base.aof  appendonly.aof.2.incr.aof appendonly.aof.manifest`表明此时AOF文件已经<font color="#00FF00">重写</font>过了  
`appendonly.aof.manifest`文件的大小是不变的,两个文件名本来为1的变为2了,并且appendonly.aof.2.incr.aof的<font color="#00FF00">大小变为0</font>;appendonly.aof.2.base.aof中的内容是刚才appendonly.aof.1.incr.aof文件瘦身后的内容.  
以此类推,如果`appendonly.aof.2.incr.aof`文件达到了设定的重写大小,并且大小比`appendonly.aof.2.base.aof`的大小膨胀到指定比例时又会发生重写,将文件名2改为3.  
<font color="#FF00FF">但是重写并不是将appendonly.aof.x.incr.aof文件中的内容进行重写;而是直接读取服务器现有的键值对,然后用一条命令去代替之前记录这个键值对的多条命令,生成一个新的appendonly.aof.x+1.base.aof文件去代替原来的AOF文件</font>

**手动重写:**  
通过`bgrewriteaof`命令手动重写AOF文件  

**AOF的整体小总结:**  
![aof小总结](resources/redis/6.png)  

### 2.4 RDB+AOF混合持久化
1.AOF和RDB同时共存  
AOF和RDB能够同时共存,默认AOF是不开启的;<font color="#00FF00">如果AOF开启,则在Redis启动阶段会优先加载AOF</font>  
所以AOF默认不开启,一旦开启就以AOF优先  

2.如果同时开启RDB和AOF文件,启动时只会加载AOF不会加载RDB  
![AOF和RDB的加载时机](resources/redis/7.png)  

3.选哪个?  
*提示:这里实际上是做一个小总结,具体的选择还是根据RDB和AOF的优缺点来考量*  
* RDB持久化方式能够在指定的时间间隔能对你的数据进行快照存储  
* AOF持久化方式记录每次对服务器写的操作,当服务器重启的时候会重新执行这些命令来恢复原始的数据,AOF命令以redis协议追加保存每次写的操作到文件末尾.

<font color="#FF00FF">推荐还是使用混合的方式使用</font>  

通过`aof-use-rdb-preamble yes`配置来开启混合模式  

**结论:**  
RDB镜像做全量持久化,AOF做增量持久化  
先使用RDB进行快照存储,然后使用AOF持久化记录所有的写操作,当重写策略满足或手动触发重写策略时,<font color="#00FF00">将最新的数据存储为RDB记录.</font>这样的话,重启服务器的时候会从RDB和AOF两部分恢复数据,即保证数据的完整性又提高了数据的恢复性能.简单来说:混合持久化方式产生的文件一部分是RDB格式,一部分是AOF格式-><font color="#00FF00">AOF包括了RDB头部+AOF混写</font>.  
![混合模式](resources/redis/8.png)  


### 2.5 纯缓存模式
**介绍:**  
通过关闭RDB和AOF的方式,进一步提高Redis的性能(至于如何持久化那不需要Redis考虑).这就是纯缓存模式  
关闭Redis持久化实际上分为两个步骤:关闭RDB、关闭AOF  
通过redis.conf文件中设置`save ""`关闭rdb  
通过redis.conf文件中设置`appendonly no`关闭aof  

## 3.Redis事务
**目录:**  
3.1 什么是Redis的事务  
3.2 用法总结  


### 3.1 什么是Redis的事务
*提示:个人感觉Redis事务的说法有点歧义,其实Redis的事务和传统数据库的事务差别还是很大的,因为Redis只支持单线程,所以多线程中的那些问题并不会发生在Redis上,称之为<font color="#00FF00">Redis命令队列更合适</font>*  

**介绍:**  
首先Redis是单线程的,每次只能保证一个提交到Redis;所以Redis中的单命令天生就是原子性的.Redis的事务很大程序上说的是Redis事务的原子性(也不是全部),即Redis可以一次性执行多个命令,<font color="#00FF00">本质是一组命令的集合</font>,<font color="#FF00FF">在执行这组命令的时候不允许别的命令插队</font>.  
虽然单命令是原子性的,但是多个不同的命令直接实际上并不能保障它们的执行顺序,通过Redis的事务可以解决这个问题;它的本质实质上就是,客户端每次向Redis提交命令的时候提交的是一个<font color="#00FF00">队列</font>,这个队列中可以有很多命令,<font color="#FF00FF">即Redis执行的最小单元是队列</font>,只提交一个命令给Redis服务器相当于提交了一个只有一个命令的队列供Redis执行,而队列之间的执行顺序Redis是无法保障的.  
大概的示意图:  
![Redis事务](resources/redis/9.png)  
<font color="#FFC800">一个队列中一次性、顺序性、排他性的执行一系列命令</font>  

Redis事务VS传统数据库的事务:  
* 单独的隔离操作:Redis实质上没有什么隔离性的说法  
* 原子性:Redis也没有什么原子性的说法,关于一个队列中如果有命令执行失败的情况,详情见=>3.2 用法总结  

**开启事务(队列)**  
`multi` 开启一个事务  
`exec` 提交事务
```shell
multi #开启事务

command0

command1

command2

exec #提交事务
```  

### 3.2 用法总结
1.正常执行  
```shell
multi #开启事务

command0

command1

command2

exec #提交事务
```  

2.放弃事务  
`discard` 命令放弃事务  
```shell
multi #开启事务

command0

command1

discard #放弃事务,command0和command1丢弃

```

3.全部失败  
*如果在一个事务还没有exec之前就执行了一条错误的Redis命令,那么当执行exec的时候整个事务(队列)中的命令都不会执行成功*  
```shell
multi #开启事务

set k1 v1 #正常命令语法

set k2 v2 #正常命令语法

set k3 #不正常的命令语法

exec #执行事务,报错:整个队列中的命令全部不执行

```

4.成功的成功,失败的失败  
*如果一个Redis事务中命令的语法检查都是正确的,但是执行时候出现错误了,那么在这个事务中不会造成所有命令全部执行失败,而是能够成功的就成功执行,不能成功的才报错.*  
```shell 
multi #开启事务

set k1 v1 #正常命令语法,能够执行成功

set k2 v2 #正常命令语法,能够执行成功

incr email #正常命令语法,不能执行成功(email不是数字)

set k3 v3 #正常命令语法,能够执行成功

exec #执行事务

```

结果:
```shell
ok
ok
error
ok
```

5.watch监控  
`watch [key0] [key1]...` 监控多个key  
Redis使用watch来提供乐观锁,如果在Redis事务执行exec之前watch的key发生了修改则当前事务中的所有命令都不会生效.  
`unwatch` 取消当前连接的监控的所有key  

**锁的释放时机:**  
* `unwatch`  
* 一旦执行了exec之前加的监控锁都会被取消
* 当客户端连接丢失的时候(比如退出连接),该连接监控的所有锁都会被取消监控

redis是单线程的,为什么会有乐观锁的说法?  
<font color="#00FF00">原因在于Redis的watch命令是执行在事务multi之前的</font>;看例子(括号的数字表示执行的顺序):  

客户端1:
```shell
set k1 v1 #初始数据的环境(1)

set balance 100 #初始数据的环境(2)

watch balance #开启key监控(3)

multi #开启事务(5)

set balance 200 #队列中的一条命令(5)

set k1 v1111111 ##队列中的一条命令(5)

exec #提交事务(5)

get balance

get k1

```

客户端2:
```shell
set balance 300 #修改balance的值(4)
```

执行结果:
```shell
300
v1
```

**解释:**  
是的,Redis是单线程的没错;但之前说过Redis不能保证每个队列之间的执行顺序,坏就坏在watch命令与multi命令不在一个队列中;于是乎导致客户端1的乐观锁失效,导致客户端1的整个事务执行失败.  

`unwatch`命令也是在`multi`之前执行的,例如:  

客户端1:
```shell
set k1 v1 #初始数据的环境(1)

set balance 100 #初始数据的环境(2)

get balance #结果为100(3)

watch balance #开启key监控(4)

unwatch #解除所有watch(7)

multi #开启事务(8)

set balance 300 #队列中的一条命令(8)

set k1 v1111111 ##队列中的一条命令(8)

exec #提交事务(8)

get balance

get k1
```

客户端2:
```shell
set balance 200 #修改balance(5)

get balance #结果为200(6)
```

执行结果:  
```shell
300
v1111111
```

## 4. Redis管道
**目录:**  
4.1 Redis管道基本介绍  
4.2 Redis管道的使用方法  

### 4.1 Redis管道基本介绍
**Redis管道的由来:**  
Redis是一种基于客户端-服务端模型以及请求/响应协议的TCP服务.一个请求会遵循以下步骤:  
* 客端向服务端发送命令分四步(发送命令->命令排队->命令执行->返回结果)并监听Socket返回,通常以阻塞模式等待服务端响应.  
* 服务端处理命令,并将结果返回给客户端

上述两步称为:Round Trip Time(简称:RTT,数据包往返于两端的时间)  
![交互模型](resources/redis/10.png)  
如果同时需要执行大量的命令,就需要等待上一条命令应答之后再去执行,这中间不仅多了RTT(Round Trip Time),还需要频繁调用系统的IO,发送网络请求,同时需要Redis调用多次read()和write()系统调用,系统方法会将数据从用户态转为内核态,这样就会对进程上下文有较大的影响,从而影响Redis性能.  

**解决思路:**  
管道(pipeline)可以一次性发送多条命令给服务端,服务端依次处理完毕之后,<font color="#00FF00">通过一条响应将一次性将结果返回,通过减少客户端与Redis的通信次数来降低往返延时时间.</font><font color="#FF00FF">pipeline的实现原理是队列,先进先出特性就保证数据的顺序性.</font>  
*提示:其实mset这种命令就有点这种思想*

![pipeline交互模型](resources/redis/11.png)

**与Redis事务的区别:**  
你会发现Redis事务和管道十分类似,都是批量执行命令;它们的区别在哪里?  
* Redis事务侧重队列中的命令是顺序执行,不会被其它的命令穿插执行,强调命令执行之间的顺序.<font color="#00FF00">并且Redis事务中的各个命令本质还是一条条地发送给Redis服务器</font>,只是这些命令被保存到一个队列中,只有客户端发送<font color="#FF00FF">exec</font>命令时,服务器才会批量执行该队列中的命令.
* Redis管道侧重多命令与服务器之间多次交互而导致性能下降的问题,通过一次性向服务器发送多条命令,服务器全部处理完毕后一次性将结果返回给客户端从而达到提升性能的效果.  
  执行事务时不允许其它的命令穿插执行;但是执行管道时是允许其它命令穿插执行的,<font color="#00FF00">虽然说管道命令是批量发送过去的,但在执行期间是允许别的命令插队的.</font>
  如果管道质量执行的过程中发生异常,是不会影响到后续指令的执行的.  
  **建议:**  
  使用pipeline组装命令的个数不宜太多,不然数据量过大会可能会导致客户端的长时间阻塞,同时服务端给客户端的答复内容也会很多,从而占用服务端过多的内存.  

### 4.2 Redis管道的使用方法
**介绍:**  
Redis管道说白了效果类似于执行sql脚本,需要先在Redis的外部将所有redis命令写入到一个文件中,然后通过linux的管道符`|`将这写命令作为参数批量传递给redis-cli;接着redis-cli就会利用管道批量发布命令.  

**案例:**  
创建一个pipeline.txt文件,内如如下:  
```shell
set k1 v11
set k2 v22
hset k3 name zhangsan
hset k3 age 18
```
直接运行<font color="#00FF00">linux</font>命令:`cat cmd.txt | redis-cli -a [password] --raw --pipe`  
* --pipe:就代表使用redis管道  


## 5. Redis发布订阅
**本章知识点了解即可**  
**目录:**  
5.1 基本介绍  
5.2 常用命令  
5.3 发布订阅的缺点  


### 5.1 基本介绍
1.Redis发布订阅是一种消息通信模式,发送者(publish)发送消息,订阅者(subscribe)接收消息,可以实现进程间的消息传递.  
说白了就是Redis版的消息中间件  

2.和Stream的区别
其实Redis发布订阅就是早起的消息中间件,这是因为它不够完善,所以才产生了后来的Stream,所以宁可使用Stream也不会使用这里的发布订阅.<font color="#00FF00">所以本章知识只做了解</font>

3.Redis客户端可以订阅任意数量的频道,类似于微信公众号  
![订阅](resources/redis/12.png)  
当有新的消息发送到某个频道的时候,所有的client就可以接受到该消息.  
![消息](resources/redis/13.png)  

![消息队列](resources/redis/14.png)  

### 5.2 常用命令
* `subscribe [channel0] [channel1]...` 订阅一个或多个频道信息  
  *提示:频道是不需要创建的,直接订阅就可以了*
* `publish [channel] [message]` 将[message]发送到指定的[channel] 
* `psubscribe [pattern]...` 按照模式(pattern的正则表达式)订阅一个或多个频道信息  
  比如有一个channel的名称为a1,那么这里订阅的时候[pattern]参数可以填写a1,也可以填写a*;说白了就是通过通配符来订阅频道
* `pubsub [subcommand]` 查看订阅与发布系统状态.[subcommand]处不同的命令有不同的效果 
* `unsubscribe [channel]` 退订[channel]频道
* `punsubscribe [pattern]` 退订[pattern]\(正则表达式匹配的频道\)

### 5.3 发布订阅的缺点
* 发布的消息无法在Redis中做持久化,必须先执行订阅再等待消息发布.如果先发布了消息,则由于消息没有订阅者这条消息就相当于丢失了.  
* 消息只管发送对于发布者而言消息是即发即失的,不管接收,也没有ACK机制,无法保证消息的消费成功.  
* 以上的缺点导致Redis的Pub/Sub模式就像个小玩具,在生产环境中几乎无用武之地,为此Redis5.0版本新增了Stream数据结构,不但支持多播,还支持数据持久化,相比pub/Sub更加的强大.






## 附录:  
A.Redis基本环境搭建  
B.Redis命令大全  

### A.Redis基本环境搭建  
**目录:**  
1.Redis资料查询  
2.Redis版本的选择  
3.Redis安装  
4.安装文件说明  
5.redis.conf  

#### 1. Redis资料查询  
[Redis官网](https://redis.io/)  
[Redis-GitHub仓库](https://github.com/redis/redis)  
[Redis版本大全](https://download.redis.io/releases/)  
[Redis命令大全](https://redis.com.cn/)  
[民间中文Redis](http://redis.cn/)  


#### 2. Redis版本的选择  
**注意:** Redis版本的选择一般是选择两位<font color="#00FF00">偶数</font>版;例如3.6、7.0、7.2,不要选择三位版本号的版本,并且不要选择末尾版本号是奇数的版本,因为奇数版本相当于是偶数版的开发版本.  
**本次实验使用的版本号是Linux-7.0**  

#### 3. Redis安装  
这里采用Docker的方式进行安装,具体安装方法见[Docker](./Docker.md)  

#### 4. 安装文件说明  
`docker exec -it [containerId] /bin/bash` 首先执行命令进入docker容器  
`cd /usr/local/bin` 进入Redis安装路径  
`ls -al` 查看路径内容  
* redis-benchmark:测试redis性能工具  
* redis-check-aof:修复有问题的AOF
* redis-check-rdb:修复有问题的dump.rdb(查看2.2.6 RDB修复命令)
* redis-cli:客户端
* redis-sentinel:redis集群;sentinel翻译为<font color="#00FF00">哨兵</font>  
* redis-server:redis服务
* /etc/redis/redis.conf 是redis的配置文件  

#### 5. [redis.conf](resources/redis/redis.conf)  
*编辑容器挂载到宿主机的redis.conf文件*    

常见redis.conf配置文件的设置内容  

* `requirepass [password]` 设置密码(1036行)  
* `loglevel [debug|verbose|notice(default)|warning]` 设置redis的日志级别  
* `timeout 0` 当客户端闲置多长时间后关闭连接,如果指定为0,表示关闭该功能  
* `databases [number(default=16)]` 设置redis数据库的数量(默认16)
* `save [second] [count]` 指定redis距离上一次过了更新过了second秒后,如果产生了count次更新就将数据持久化;  
  默认为save 3600 1 300 100 60 10000  
  表示:分别表示距离上一次更新后的3600s(1小时)内有一个更改,距离上一次更新后的300秒(5分钟)内有100个更改以及距离上一次更新后的60秒内有10000个更改.
* `save ""` 这种设置方式会禁用RDB持久化方式
* `rdbcompression [yse(default)|no]` 是否开启压缩持久化,默认为true;开启这项功能相对而言会占用CPU资源,关闭后会导致持久化文件变大  
* `dbfilename [fileName(default=dump.rdb)]` 指定RBD持久化文件的名称
* `dir [filePath(default=./)]` 指定持久化文件的存放路径(默认为当前路径)  
* `stop-writes-on-bgsave-error [yes(default)|no]` 如果配置成no表示Redis不在乎数据不一致或者有其他的手段发现和控制这种不一致,那么在快照写入失败时,也能确保Redis继续接受新的请求.  
  其实这段话翻译过来就是:停止写入当bgsave失败的时候;推荐使用yes  
* `rdbchecksum [yes(default)|no]` 如果配置成yes,则Redis在存储rdb文件时会进行CRC64校验,大约会损失10%的性能;如果对性能要求很高可以关闭;推荐不关闭 
* `rdb-del-sync-files [yes|no(default)]` 就用默认的no就可以了;在没有持久化的情况下删除复制中使用的RDB文件启用;该配置是主从复制中会使用到
* `` *前提:当前Redis服务为从* 该配置设置当前从Redis去哪个IP和端口同步主Redis
* ` ` *前提:当前Redis服务为从* 当主Redis设置密码时,从Redis同步主Redis时要提供的主Redis密码;也就是说如果主Redis设置了`requirepass`这里要提供主Redis设置的密码
* `maxclients [connectCount(default=10000)]` 设置Redis可以同时打开的客户端连接数
* `maxmemory [bytes]` 设置Redis最大内存限制;如果达到该限制则Redis会尝试清除已经过期的或即将过期的Key;如果清除过后还是不够则Redis将不允许写入,但允许读取;不过现在的Redis会将Key放入内存,将value放入swap(交换区)  
* `appendonly [yes|no(default)]` 设置Redis是否每次更新数据都写入日志文件;如果设置成yes会造成性能损耗;如果设置成false则由于Redis默认持久化策略是按照上面的`save`策略来保证的;就可能导致Redis宕机时部分数据丢失.  
* `appendfilename "[fileName(default=appendonly.aof)]"` 指定更新日志文件名  
* `appenddirname "[filePath(default=appendonlydir)]"` 指定AOF文件的存放路径;注意存放路径是`dir`+`appenddirname`拼接的路径.而`dir`路径下直接存放的是rbd持久化文件
* `appendfsync [no|always|everysec(default)]` 指定更新日志文件条件;这里和MySQL中持久化是一样的,持久化文件不是直接刷盘,而是写入到内存中的缓冲区;只有当系统调用fsync()时才会真正刷盘(见基础篇=>2. Redis持久化=>2.3 AOF=>2.3.2 AOF文件的持久化流程)
  * no:表示等操作系统进行数据缓存同步到磁盘(块)
  * always:表示每次更新操作后手动调用fsync()将数据写到磁盘(慢,安全)
  * everysec:表示每秒同步一次(折中,默认值)
* `auto-aof-rewrite-percentage [percent(default=100)]` 当前文件距离上次重写后碰撞[percent倍]才执行重新  
* `auto-aof-rewrite-min-size [fileSize(default=64mb)]` 重写时满足的文件大小  
  **注意:** 这里auto-aof-rewrite-percentage和auto-aof-rewrite-min-size是<font color="#00FF00">与</font>的关系,只有这两个同时满足才会触发重写.  
* `aof-use-rdb-preamble [yes(default)|no]` 是否采用aof-rdb持久化日志的混合模式
* `no-appendfsync-on-rewrite [yes|no(default)]` aof重写期间是否允许编写aof
* `activerehashing [yes(default)|no]` 指定是否激活重置哈希  
* `include [filePath]` 指定包含其它的配置文件,可以在同一主机上多个redis实例之间使用同一份配置文件,而同时各个实例又拥有自已的特定配置文件

*改完配置,重启docker容器*  

### B. Redis命令大全

*help:命令可以帮助我们获取帮助*  
*help @[type]* 获取一个类型的帮助命令,其中type是Redis十大类型  
*help [command]* 获取一个命令的帮助信息

**目录:**  
1.key相关  
2.String类型相关  
3.List类型相关  
4.Hash类型相关  
5.Set类型相关  
6.ZSet类型相关  
7.bitmap类型相关  
8.HyperLogLog类型相关  
9.GEO类型相关  
10.Stream类型相关  
11.BitField类型相关  
12.事务相关  
A.其它  

#### 1. key相关
* `keys *` 查看当前库所有key  
* `exists [key]` 判断某个key是否存在  
* `type [key]` 查看某个key的类型
* `del [key]` 删除指定的key  
* `unlink [key]` 非阻塞删除,仅仅将key从keyspace元数据中删除,真正的删除会在后续异步中操作
* `ttl [key]` 查看还有多次时间过期  
  return -1 代表永不过期  
  return -2 代表已经过期  
* `expire [key] [second]` 设置指定key的过期时间  
* `move [key] [db_index]` 将key移动到db_index库中  
  默认16个库,范围是[0-15] 可以通过redis.conf配置的`databases`修改库的数量    
* `select [db_index]` 切换到[db_index]数据库  
* `dbsize` 查看当前数据库key的数量  
* `flushdb` 清空当前数据库  
* `flushall` 清空所有数据库  

#### 2.String类型相关  
*提示:分割线以下的内容选填*  

* `set [key] [value] [NX|XX] [GET] [EX [second]|PX [milliseconds]|EXAT [unix-time-seconds] |PXAT [unix-time-milliseconds]|KEEPTTL]`  
  * `key`(必填):key
  * `value`(必填):value
  - - -
  *  `EX [second]`:设置以秒为单位的过期时间  
  *  `PX [milliseconds]` 设置以毫秒为单位的过期时间  
  *  `EXAT [unix-time-seconds]` 设置以unix时间戳-秒为单位的过期时间(就是到了这个时间戳就过期)  
  *  `PXAT [unix-time-milliseconds]` 设置以unix时间戳-毫秒为单位的过期时间
  *  `KEEPTTL` 保持之前的key的过期时间(因为set是覆盖方法,有可能之前已经有过这个key了)  
  - - -
  * `NX`:键不存在时设置该值;nx(not exist)=>不存在
  * `XX`:键存在时设置该值
  - - - 
  * `GET`:返回指定键原本的值,若键不存在则返回null
* `mset [key0] [value0] [key1...] [value1...]` 批量设置  
  注意这种批量操作的命令,可以增加性能;因为单值set命令需要和服务器不停地往来交换数据,性能是比较低的.  
  用这种一次性交付命令可以提高性能,除了这种方式提高性能之外还可以通过=>`4.Redis管道`来提高性能  
* `mget [key...]` 批量获取多个  
* `msetnx [key...]` 键不存在时批量设置,并且只要有一个存在;则整条命令执行失败(类似于MySQL中的原子性)  
* `getrange [key] [startIndex] [endIndex]` 获取一个value并截取片段返回  
  * `key`(必填):key
  * `value`(必填):value
  * `startIndex`(必填):截取的开始下标  
  * `endIndex`(必填):截取的结束下标
  - - -
   例如:一个key它的value是abcd  
   执行:`getrange k1 0 -1` 返回abcd  
   执行:`getrange k1 0 1` 返回ab  
   总结:它的作用相当于Java中的subString
* `setrange [key] [startIndex] [value]` 其实该命令相当于Java的replace  
  * `key`(必填):key
  * `value`(必填):value
  * `startIndex`(必填):开始覆盖的下标  
  * `value`(必填):覆盖的值  
  - - - 
  例如:一个key它的value为abcd1234  
  执行:`setrange k1 1 xxyy` 结果是axxyy234 相当于从索引1开始,将xxyy覆盖原字符串内容  
* `incr [key]` 将key对应的value值加1  
  *提示:value必须是数字此命令才有意义*
* `incrby [key] [increment]` 将key对应的value加[increment]
  * `increment`(必填):实际上代表步长
* `decr [key]` 将key对应的value值减1
* `decr [key] [increment]` 将key对应的value减[increment]
* `strlen [key]` 获取value的长度  
* `append [key] [value]` append拼接
* `setnx [key] [second] [value]` 键不存在时设置改值<font color="#00FF00">分布式锁会用到</font>  
  * `key`(必填):key
  * `second`(必填):过期时间,单位秒
  * `value`(必填):value
  - - -
  **解释:**  
  这个命令为什么能用到分布式锁中?  
  实际上这个命令是一个原子操作,以前设置一个键值对需要先调用`set`命令,然后在调用`expire`命令设置key的过期时间;这个命令相当于把set和expire命令合二为一变成一个原子操作.从而来实现分布式锁.
* `setex [key] [second] [value]` 键存在时设置改值;ex(exist)=>存在
* `getset [key] [value]` 先get再set;先获取到[key]对应的value,然后再将[value]设置进去  
  该命令等同于`set [key] [value] get`

#### 3.List类型相关  
* `lpush [key] [value...]` 向List集合中设置数据,l代表left的意思,意思是从左边插入
  - - - 
  例如:  
  执行:`lpush k1 1 2 3 4 5`  
  此时List数据的顺序为:5 => 4 => 3 => 2 => 1;因为它是从左边插入的  
* `rpush [key] [value...]` 向List集合中设置数据,r代表right的意思,意思是从右边插入
  - - -
  例如:  
  执行:`rpush k1 1 2 3 4 5`
  此时List数据的顺序位:1 => 2 => 3 => 4 => 5;因为它是从右边插入的;<font color="#00FF00">并且我们看的顺序都是从左往右看的</font>;因为只有lrange,没有rrange命令  
* `lrange [key] [startIndex] [endIndex]` 获取一个List中的元素  
  `key`(必填):key对应的value必须是List类型  
  `startIndex`(必填):开始的索引  
  `endIndex`(必填):结束的索引  
  - - -   
  例如:  
  上面`lpush k1 1 2 3 4 5 `的数据  
  执行:`lrange k1 0 -2` 结果是5 => 4 => 3 => 2 => 1
* `lpop [key]` 左边出队
* `rpop [key]` 右边出队
* `lindex [key] [index]` 获取从左到右顺序下index下标对应的元素  
* `llen [key]` 获取列标中元素的个数  
* `lrem [key] [count] [element]` 从左向右删除count个值为element的元素  
* `ltrim [key] [startIndex] [endIndex]` 截取[key]对应的List的[startIndex]到[endIndex]下标之间的值后再赋值给key;从左向右截取  
* `rpoplpush [originKey] [targetKey]`意思是从[originKey]的右边出一个元素然后将将该元素插入[targetKey]对应的列表中去(在左边插入)  
  * `originKey`(必填):源列表
  * `targetKey`(必填):目的列表  
* `lset [key] [index] [value]` 设置某个[key]对应的List中下标为[index]的值为[value];索引是从左往右的  
* `linsert [key] [before|after] [alreadyValue] [newValue]` 在已有的[alreadyValue]值之前或之后插入一个[newValue]

#### 4. Hash类型相关  
* `hset [key] [field0] [value0] [field...] [value...]`
  * `key`(必填):key  
  * `field`(必填):value的key
  * `value`(必填):value的value
* `hget [key] [field]` 获取一个Hash值(获取value的value)  
* `hmset [key] [field] [value] [field...] [value...]` 该命令和`hset`效果一致  
* `hget [key] [field...]` 批量获取value中的value(即批量获取field对应的value)  
* `hgetall [key]` 遍历一个key对应的value的所有K-V键值对  
* `hdel [key] [field...]` 批量删除Key对应的Hash中的某个Key  
* `hexists [key] [field]` 判断某个Key对应的Hash中是否存在某个Key  
* `hkeys [key]` 展示某个Hash所有的key  
* `hvals [key]` 展示某个Hash所有的value
* `hincrby [key] [field] [increment]` 将Key对应的Hash中的某个Key对应的value值加[increment];该命令效果类似`incrby`  
  * `increment`(必填):实际上代表步长  
* `hincrbyfloat [key] [field] [increment]` 将Key对应的Hash中的某个Key对应的value值加[increment];该命令效果类似`hincrby`;  
  * `increment`(必填):实际上代表步长;<font color="#00FF00">这里步长的值是一个浮点数</font>
* `hsetnx [key] [field] [value]` 不存在则设置  

#### 5. Set类型相关  
* `sadd [key] [value0] [value...]` 添加元素
* `smembers [key]` 遍历Set集合  
* `sismembers [key] [value]` 判断元素是否在Set集合中  
* `srem [key] [member0] [member...]` 删除Set集合中的元素  
* `scard [key]` 获取集合中元素的个数  
* `srandmember [key] [number]` 从集合中随机展示[number]个元素,被展示的元素不会删除  
* `spop [key] [number]` 从集合中随机弹出[number]个元素,弹出的元素会被删除  
* `smove [key0] [key1] [key0-value]` 将[key0]中的元素[key0-value]移动到[key1]  
* `sdiff [key0] [key1] [key...]` 集合元素A-B;即展示出属于集合[key0],但不属于集合[key1]和[key...]的元素  
* `sunion [key0] [key...]` 求并集[key0]和[key...]  
* `sinter [key0] [key...]` 求交集[key0]和[key...]  
* `sintercard [number] [key0] [key1] [key...] [limit [limitNumber]]`求交集[key0]和[key...],返回的是结果集中元素的数量  
  * `number`(必填):表明后面有几个key  
  * `key..`(必填):什么key求交集;key能填写的数量和number指定的数量是一致的
  - - -
  * `[limit [limitNumber]]`:限制结果的数量,也就是说如果命令求得的结果是100,但我这里限制limitNumber的值10,最终结果就是10.*这东西也不知道有什么用感觉脱裤子放屁*  

#### 6. ZSet类型相关  
* `zadd [key] [score] [value0] [score]... [value]...`  
  * `score`(必填):该value对应的分数  
* `zrange [key] [startIndex] [endIndex] [withscores]` 按照set集合中的分数进行排序(从小到大排序),然后返回[startIndex]到[endIndex]下标之间的元素  
  * `key`(必填):key  
  - - - 
  * `startIndex`:要返回的排序集合的开始下标
  * `endIndex`:要返回的排序结合的结束下标
  * `withscores`:返回的时候带上分数(如果不带该参数,默认是返回ZSet集合中所有的元素和Set效果一样)
  - - -
  例如:  
  执行:`zrange key 0 -1 withscores` 结果是展示所有的元素并且带上分数
* `zrevrange [key] [startIndex] [endIndex] [withscores]`效果等同于`zrange`;不过该命令对分数会按照从大到小排序
* `zrangebyscore [key] [min] [max] [withscores] [limit [offset] [count]]` 筛选出分数在[min]到[max]之间的元素
  * `min`(必填):最小分数;默认包含min(即闭区间)
  * `max`(必填):最大分数;默认包含max(即闭区间)  
  **特性:** 如果向要开区间,则写的时候这么写  
  `zrangebyscore [key] (60 90) withscores` 表示筛选出分数在(60,90)这个区间的元素
  - - -
  * `withscores`:返回结果中显示分数  
  * `limit`:限制返回的结果数量
    * `offset`:偏移量;即从那个下标开始返回
    * `count`:返回的结果数量
* `zsocre [key] [value]` 获取ZSet集合中元素value对应的分数  
* `zcard [key]` 获取集合中元素的数量
* `zrem [key] [value]` 删除集合中的[value]元素
* `zincrby [key] [increment] [value]` 给ZSet集合中[value]元素的分数增加[increment]  
* `zcount [key] [min] [max]` 统计指定返回内元素的个数
* `zmpop [keyCount] [key0] [key...] [min|max] [count [countNumber]]` 弹出[key]对应的ZSet集合中最[min|max]的[countNumber]个元素  
  * `keyCount`(必填):表明选择要弹出的ZSet的集合的个数
  * `key...`(必填):要弹出的ZSet集合的key;注意这里指定的key的数量要和`keyCount`保持一致  
  * `[min|max]`(必选):选择弹出时的排序,是弹出最小的还是弹出最大的
  * `count`(必填)
    * `countNumber`(必填):指定弹出的数量
* `zrank [key] [value]` 获取某个[value]在ZSet中的下标值(也可以理解为顺序);排序按照从小到大排序  
* `zrevrank [key] [value]` 作用类似zrank,只不过排序按照从大到小进行排序 

#### 7. bitmap类型相关  
* `setbit [key] [offset] [value]` 
  * `key`(必填):key
  * `offset`(必填):偏移量,相当于索引下标  
  * `value`(必填):值,只能取0或1
  - - -
  例如:  
  执行:`setbit key 2 1` 相当于给key对应的bit数组下标为2的值设置为1
* `getbit [key] [offset]`  获取索引下标为[offset]的比特值  
* `strlen [key]` 获取一个bitmap的<font color="#00FF00">字节</font>长度  
  注意和之前的`strlen`区分下来;该命令不显示字符串长度,而是显示占用多少个字节;因为bitmap是以8位为一组,不满8位的算一组.  
  例如:  
  001 => 长度为1  
  1000 0000 1 => 长度为2
* `bitcount [key] [start] [end] [byte|bit]` 统计一个区间有bit=1的个数
  - - -  
  * `start`:开始的区间  
  * `end`:结束的区间
  * `byte|bit`:开始和结束区间的单位,如果是byte表明开始和结束时按byte(8位一组)进行区分的,否则bit(默认)就是按位进行区分的
* `bitop [AND|OR|NOT|XOR] [newKey] [key0] [key1]` 对[key0]和[key1]做位运算(AND|OR|NOT|XOR)=>将结果保存到一个[newKey]
  * `AND|OR|NOT|XOR`(必填):具体的操作类型  
  * `newKey`(必填):合并到的目标key  
  * `key0`(必填):key0
  * `key1`(必填):key1
  - - - 
  **注意:** 重点关注场景  

#### 8. HyperLogLog类型相关  
* `pfadd [key] [value0] [value1]...`  添加数据到HyperLogLog中(自带去重)  
* `pfcount [key]` 统计HyperLogLog中有多少个元素  
* `pfmerge [distKey] [key0] [key1]...` 将[key0]和[key1]...合并到[distKey]中去  

#### 9. GEO类型相关  
*如何获取某个位置的经纬度坐标?访问:[百度地图](https://api.map.baidu.com/)*
* `geoadd [key] [longitude0] [latitude0] [member0] [longitude]... [latitude]... [member]...` 多个经度(longitude)、纬度(latitude)、位置名称(member)添加到指定key中
  * `key`(必填):key
  * `longitude0`(必填):经度
  * `latitude0`(必填):纬度
  * `member0`:成员名称(可以认为该值设置的是地点名称) 
* `geopos [key] [member]...` 返回key对应的ZSet集合中,[member]...成员的经度纬度坐标  
  - - -
  例如:  
  执行:`geopos city 北京 故宫` 将返回北京与故宫的坐标
* `geohash [key] [member]...` 返回key对应的ZSet集合中,[member]...成员的经度纬度的<font color="#00FF00">哈希</font>坐标;可以使用这种方式来讲经纬度进行一个映射
* `geodist [key] [member0] [member1] [M|KM|FT|MI]` 返回[member0]和[member1]两个位置之间的距离
  * `M|KM|FT|MI` 返回的距离单位
* `georadius [key] [longitude] [latitude] [radius] [M|KM|FI|MI] [WITHCOORD] [WITHDIST] [WITHHASH] [count [countNumber] [ASC|DESC]]` 以当前给定的[longitude]和[latitude]坐标为中心,从[key]对应的ZSet集合中查找出距离为[radius]长度的,距离单位为[M|KM|FI|MI]的所有元素.
  * `key`(必填):要从那个geo(ZSet)集合中查找元素  
  * `longitude`(必填):经度  
  * `latitude`(必填):纬度
  * `radius`(必填):距离  
  * `M|KM|FI|MI`(必填):距离单位  
  - - -
  * `WITHDIST`:返回结果的同时返回目标元素距离当前位置的距离
  * `WITHCOORD`:返回结果的同时返回目标元素的经纬度坐标
  * `WITHHASH`:返回结果的同时返回目标元素的经纬度坐标的哈希(以52位基于哈希编码的方式返回)
  * `count`:
    * `countNumber`:限制结果的个数
    * `ASC|DESC`:升序还是降序显示(是对查询的结果最终进行升序或降序返回)
* `georadiusbymember [key] [member] [radius] [M|KM|FI|MI] [WITHCOORD] [WITHDIST] [WITHHASH] [count [countNumber] [ASC|DESC]]` 与georadius类似;只不过经纬度改成了以ZSet集合中某个具体元素[member]的坐标为基准

#### 10. Stream类型相关
* `xdd [key] [id|*] [field0] [value0] [field1]... [value1]...`  
  该命令用户向Steam队列中添加消息,如果指定的Stream队列不存在,则该命令执行时会新建一个Stream队列.  
  * `key`(必填):key  
  * `id|*`(必填):id的生成规则
    * `*`:代表系统生成;生成的规则是Redis节点服务器的毫秒时间戳-该毫秒内产的第一个消息.例如`1695543120504-0`;自增id的长度是64位的不存在超过的问题  
    * `id`:手动填写id,Redis对于id的格式有强制要求,格式必须是<font color="#00FF00">时间戳-自增id</font>这样的方式,并且后序的id不能小于前一个id.  
  * `fiedl`(必填):消息的key
  * `value`(必填):消息的value  
  也就是说<font color="#00FF00">每个消息本身又是一个K-V键值对</font>
* `xrange [key] [start] [end] [count [countNumber]]` 显示[key]对应的stream下所有的消息(每个消息表现出来的形式是K-V)
  * `start`(必填):表示开始值,-代表最小值
  * `end`(必填):表示结束值,+代表最大值
  - - -
  * `count`:
    * `countNumber`:限制返回的消息数量  
* `xrevrange [key] [end] [start] [count [countNumber]]` `xrange`的反转;`xrange`输出的顺序是按照消息产生的顺序输出的;`xrevrange`则是反转(最新的消息最先输出)  
* `xdel [key] [id]` 根据消息的[id]删除消息  
* `xlen [key]` 返回消息列表的长度 
* `xtrim [key] [maxlen] [count]` 截取Stream  
  * `key`(必填):key
  * `maxlen`(必填)
  * `count`(必填):截取(保留)当前Stream最新的几条消息
* `xtrim [key] [minid] [id]` 截取Stream
  * `key`(必填):key
  * `minid`(必填)
  * `id`(必填):去掉Stream中比[id]值还小的消息 
* `xread [count [countNumber]] [block [milllisecond]] streams [key0] [key1]... [id0] [id1]...` 读取stream流  
  * `count`(必填):
    * `countNumber`(必填):读取的消息数量
  * `key`(必填):key
  * `id`(必填):消息的id;Redis会从Stream中获取比当前id大的消息  
    &:特殊值,消息的id可以填&;表示当前Stream已经存储的最大的id作为最后一个id;该结果将返回null(但是可以搭配`block`参数使用)  
    0-0:表示从最小的id开始获取Stream中的消息,当不指定count的时候,将会返回Stream中的所有消息 
  - - - 
  * `block`:是否采用阻塞队列
    * `milllisecond`(必填):阻塞的毫秒数;如果填0表示一直阻塞  
    例如:  
    执行:`xread count 1 block 0 streams key &` 此时该命令会一直阻塞等待一个比当前ID还大的消息;此时新开一个客户端,在里面新创建一个消息时,这边的客户端就会立即读取到.(相当于Java里面的生产者消费者模式)  
- - - 
*接下来是Stream中消费组的相关命令*  
**提示:** 消费者要想消费消息,那么必须将消费者添加到某个消费组中去  
* `xgroup create [key] [groupName] [id]` 创建消费组  
  * `key`(必填):key
  * `groupName`(必填):消费组的名称  
  * `id`(必填):消费的消息id    
    `$`:特殊值代表从最新的消息开始消费  
    `0`:特殊值代表从最老的消息开始消费  
    ----------------->时间  
    新消息-------->老消息
* `xreadgroup group [groupName] [consumerName] [count [countNumber]] streams [key] [id]` 让一个组去读消息  
  **注意:** 这种消费方式是没有进行确认的(即没有ACK);通过`xack`命令来确认消息  
  * `groupName`(必填):消费组名称  
  * `consumerName`(必填):消费者名称  
  * `key`(必填):消费哪个组
  * `id`:读取的消息的id  
    `>`:特殊id以游标的方式读取  
  **注意:** Stream中的消息一旦被消费组里的一个消费者读取了,就不能再被该消费组内的其它消费者读取了,即同一个消费组里的消费者不能消费同一条消息  
  但是一个Stream里的消息是可以被消费组之间重复消费的,意思就是假设Stream现在有三条消息,被消费组A里的消费者A1消费之后,A2就不能再消费了;但是现在有一个消费组B,它里面的消费者B1是可以重复消费Stream里面的消息的.
  - - -
  * `count`:读取的消息数
    * `countNumber`:从Stream流中读取几条消息(不写的话默认是读取所有消息)  
    通过这个countNumber就可以限制让组内的多个消费者分担消费消息(类似于负载均衡的概念)  
* `xpending [key] [groupName]` 查询每个消费组内每个消费者<font color="#00FF00">已读取但未确认的消息</font>
  * `groupName`(必填):指定查询的目标消费组    
* `xpending [key] [groupName] [start] [end] [count] [consumer]` 查询[groupName]消费组里[consumer]消费的消息情况,范围从[start]到[end],数量为[count]  
  - - -
  * `start`:开始的id位置
  * `end`:结束的id位置  
  * `count`:限制结果数量
    **注意:**  
    同样start的值是一个id;end的值也是一个id  
    例子:  
    执行:`xpending key groupName - + 10 consumerA` 意思是查看key这个Stream中groupName分组下consumerA消费所有消息的情况,并限制返回的数量为10;注意这里-、+的意思和`xrange`中的id是一样的
* `xack [key] [groupName] [id]` 确认签收一条消息  
  * `groupName`(必填):组名称  
  * `id`(必填):消息的id
* `xinfo stream [key]` 用于获取Stream、消费组、消费者的一些情况

#### 11 BitField类型相关  
* `bitfield [key] [overflow [sat|warp(default)|fail]] [get|set] [i|u][count] [offset] [value]` 取值  
  *提示:offset开始为0*  
  * `get|set`  
  `get`:获取二进制值  
  `set`:设置二进制值  
  * `i|u`(必填):有符号还是无符号;i代表有符号的二进制;u代表无符号的二进制  
  * `count`(必填):取几位  
  * `offset`(必填):偏移量
  例子:  
  `set k1 hello` 先设置值  
  `bitfield k1 get i8 0` 意思是获取k1的二进制值,长度为8位有符号数;从0开始获取;最终的结果是104(正好对应字符'h'的十进制ASCII码)
  - - -  
  * `value`:设置的十进制值  
  * `overflow`:溢出控制  
    * `sat`:使用饱和计算方法处理溢出;下溢出计算为最小整数值,上溢出为最大整数值.也就是说如果溢出了会限死溢出的值;例如127+1还等于127  
    * `warp`:使用回绕方法处理溢出情况(下面有举例子)  
    * `fail`:命令拒绝溢出情况  
  例子:  
  `bitfield k1 set i8 8 120` 在上面那个例子的基础上修改;从偏移量第8位开始修改,修改长度为8位;修改的目标值为120的二进制  
  `get k1` 输出结果"hxllo"  
  `bitfield k1 set i8 8 158` 溢出问题,因为8为二进制的范围是(-128~127);现在这个值早已超出158了,此时再get显示的结果为-98;这就是循环溢出了(default=wrap)
* `bitfield [key] incrby [i|u][offset] [increment]` 增加二进制  
  * `key`(自增):key
  * `i|u`(自增):无符号数还是有符号数
  * `offset`(自增):从哪里开始增加
  * `increment`(必填):自增的步长  

#### 12.事务相关  
* `mulit` 开启事务
* `exec` 执行事务
* `discard` 取消事务,放弃执行事务块内的所有命令  
* `watch [key0] [key1]...` 监视一个或多个Key,如果在事务执行之前这些Key被其他命令所改动,那么事务将被打断.  

#### A. 其它
* `config get [propertiesKey]` 获取系统配置  
  * `propertiesKey`(必填):配置文件的key  
* `lastsave` 获取最后一次备份的时间戳  
* `bgrewriteaof` 手动重写AOF  
* `bgsave` 创建一个子进程持久化写入rdb文件
* `save` 阻塞持久化rdb文件(不推荐使用该命令)

# 高级篇







# 实战篇
**目录:**  
1.丰富系统功能  


## 1. 丰富系统功能  
**目录:**  
1.1 利用incr命令增加用户点赞信息  
1.2 利用lpush命令实现文章推送功能  
1.3 利用Hash类型完成购物车功能  
1.4 利用Set类型完成抽奖小程序、社交场景  
1.5 利用ZSet类型完成热点数据的存放  
1.6 利用bitmap类型完成布尔逻辑的存放  
1.7 利用HyperLogLog类型完成UV统计  


### 1.1 利用incr命令增加用户点赞信息  
**介绍:** 因为Redis命令是原子性的,所以用这种很合适.  


### 1.2 利用lpush命令实现文章推送功能
假设,现在CSDN和尚硅谷发布了两篇文章,id分别为10 22  
执行`lpush uuid 10 22`  
那么查询的时候带上个人的uuid,去查询当前我们的文章时,执行`lrange uuid 0 9` 分页查询一次查询10条数据  
显示的结果为:10=>20

### 1.3 利用Hash类型完成购物车功能
![购物车](resources/redis/1.png)  

### 1.4 利用Set类型完成抽奖小程序、社交场景 
1.利用Set完成抽奖程序  
假设现在有抽奖程序,用户点击参加后就将用户的uuid放到一个Set集合中去,最后开奖的时候调用`srandmember`来随机开奖  

2.微信朋友圈点赞查看同赞的朋友  
![点赞](resources/redis/2.png)  

3.QQ内推可能认识的人  
用`sinter`命令来求两个人共同的好友关系  

#### 1.5 利用ZSet类型完成热点数据的存放
1.完成热销商品的数据存储  

#### 1.6 利用bitmap类型完成布尔逻辑的存放
1.用户是否已经登陆过(布尔值场景);比如默默背单词的每日签到  
2.电影、广告是否被播放过  
3.钉钉打卡上班签到机制

**怎么用:**  
例如统计用户一个月的签到情况,那么就可以用一个长度为31的bit数组来存放这个数据,签到为1未签到为0.这样的好处就是不用每天反复读写数据库了.  

<font color="#FF00FF">bitmap本身并不复杂,但它的运用场景才是着重需要关注的. </font>

4.利用bitop完成用户连续多少天签到的场景  

假设设置了一个bitmap为:
`setbit 2023-9-16 0 1`这就代表在2023年9月16号这天,用户id为0的用户登录了  
`setbit 2023-9-16 5 1` 2023年9月16号这天,用户id为5的用户登录了  
`setbit 2023-9-17 5 1` 2023年9月17号这天,用户id为5的用户登录了  
`bitop and union 2023-9-16 2023-9-17` 将2023年9月16号和17号这两天用户的bitmap进行and运算;这样不就能统计出哪些用户连续两天登陆了吗?(通过查询union)

采用这种方法又快又省内存又高效!

### 1.7 利用HyperLogLog类型完成UV统计
1.统计网站每天的UA、统计某个文章的UA  
2.用户搜索网站关键词数量  
3.统计用户每天搜索不同词条个数  

