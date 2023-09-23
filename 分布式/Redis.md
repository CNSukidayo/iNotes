# 目录:  
A.1  
B.1  
C.1  

# 基础篇
**目录:**  
1.10大数据类型  

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

### 1.6 GEO(地理空间)  

**介绍:**  
主要用于存储地理位置,并对存储的信息进行操作;包括:  
* 添加地理位置的坐标  
* 获取地理位置的坐标
* 计算两个位置之间的距离  
* 根据用户给定的金纬度坐标来获取指定范围内的地理位置的集合  


### 1.7 HyperLogLog(基数统计)  

**介绍:**  
HyperLogLog是用来做基数统计的算法,HyperLogLog的优点是,在输入元素的数量或者体积非常非常大时,计算基数所需的空间总是固定且是
很小的.  
在Redis里面,每个HyperLogLog键只需要花费12KB内存,就可以计算接近2へ64个不同元素的基数,这和计算基数时,元素越多耗费内存
就越多的集合形成鲜明对比.  
但是,因为HyperLogLog只会根据输入元素来计算基数,而不会储存输入元素本身,所以HyperLogLog不能像集合那样,返回输入的各个元素.  

### 1.8 bitmap(位图)

**介绍:**  
由01状态表现的二进制位的bit数组,所以这就是个bit类型;想想最终返回的类型也是0101100这种.  

### 1.9 bitfield(位域)  

**介绍:**  
通过bitfield命令可以一次性操作多个<font color="#FF0000">比特位域(指的是连续的多个比特位)</font>,它会执行一系列操作并返回一个响应数组,这个数组中的元素对应参数列表中的相应操作的执行结果.  
说白了就是通过bitfield命令我们可以一次性对多个比特位域进行操作.  




### 1.10 Stream(流)

**介绍:**  
Redis版本的消息中间件,Redis本身是有一个Redis发布/订阅(pub/sub)来实现消息队列的功能,但是它有个缺点就是消息无法持久化,如果出现网络断开、Redis宕机等,消息就会被丢弃.  



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
`cd /user/local/bin` 进入Redis安装路径  
`ls -al` 查看路径内容  
* redis-benchmark:测试redis性能工具  
* redis-check-aof:修复有问题的AOF
* redis-check-dump:修复有问题的dump.rdb
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
* `save [second] [count]` 指定redis每隔second秒产生count次更新就将数据持久化;  
  默认为save 3600 1 300 100 60 10000  
  表示:分别表示3600s(30分钟)内有一个更改,300秒(5分钟)内有100个更改以及60秒内有10000个更改.
* `rdbcompression [yse(default)|no]` 是否开启压缩持久化,默认为true;开启这项功能相对而言会占用CPU资源,关闭后会导致持久化文件变大  
* `dbfilename [fileName(default=dump.rdb)]` 指定RBD持久化文件的名称
* `dir [filePath(default=./)]` 指定持久化文件的存放路径(默认为当前路径)  
* `` *前提:当前Redis服务为从* 该配置设置当前从Redis去哪个IP和端口同步主Redis
* ` ` *前提:当前Redis服务为从* 当主Redis设置密码时,从Redis同步主Redis时要提供的主Redis密码;也就是说如果主Redis设置了`requirepass`这里要提供主Redis设置的密码
* `maxclients [connectCount(default=10000)]` 设置Redis可以同时打开的客户端连接数
* `maxmemory [bytes]` 设置Redis最大内存限制;如果达到该限制则Redis会尝试清除已经过期的或即将过期的Key;如果清除过后还是不够则Redis将不允许写入,但允许读取;不过现在的Redis会将Key放入内存,将value放入swap(交换区)  
* `appendonly [yes|no(default)]` 设置Redis是否每次更新数据都写入日志文件;如果设置成yes会造成性能损耗;如果设置成false则由于Redis默认持久化策略是按照上面的`save`策略来保证的;就可能导致Redis宕机时部分数据丢失.  
* `appendfilename "[fileName(default=appendonly.aof)]"` 指定更新日志文件名  
* `appendfsync [no|always|everysec(default)]` 指定更新日志文件条件;这里和MySQL中持久化是一样的,持久化文件不是直接刷盘,而是写入到文件系统缓存中去的(page cache);只有当系统调用fsync()时才会真正刷盘
  * no:表示等操作系统进行数据缓存同步到磁盘(块)
  * always:表示每次更新操作后手动调用fsync()将数据写到磁盘(慢,安全)
  * everysec:表示每秒同步一次(折中,默认值)
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

  


# 高级篇







# 实战篇
**目录:**  
1.丰富系统功能  


## 1. 丰富系统功能  
**目录:**  
1.1 利用incr命令增加用户点赞信息  
1.2 利用lpush命令实现文章推送功能  


### 1.1 利用incr命令增加用户点赞信息  
**介绍:** 因为Redis命令是原子性的,所以用这种很合适.  


### 1.2 利用lpush命令实现文章推送功能
假设,现在CSDN和尚硅谷发布了两篇文章,id分别为10 22  
执行`lpush uuid 10 22`  
那么查询的时候带上个人的uuid,去查询当前我们的文章时,执行`lrange uuid 0 9` 分页查询一次查询10条数据  
显示的结果为:10=>20

