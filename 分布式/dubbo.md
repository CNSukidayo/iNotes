# 目录  
1.任务  



## 1.任务  
**目录:**  
1.1 开发任务  
1.2 部署服务  
1.3 流量管理  

### 1.1 开发任务
**目录:**  
1.1.1 发布调用dubbo  
1.1.2 异步调用  
1.1.3 版本与分组  
1.1.4 上下文参数传递  
1.1.5 泛化调用  
1.1.6 IDL开发服务  


#### 1.1 发布调用dubbo  
1.编写pom  
*提示:本次示例基于springboot3.0,本次案例来源于dubbo-sample=>1-basic=>dubbo-samples-spring-boot*  
```xml
<!-- registry dependency -->
<dependency>
    <groupId>com.alibaba.nacos</groupId>
    <artifactId>nacos-client</artifactId>
    <version>${nacos.version}</version>
</dependency>

<!-- dubbo dependency-->
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-spring-boot-starter</artifactId>
    <version>${dubbo.version}</version>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
</dependency>
```

2.定义服务接口  
类似于OpenFeign一样需要定义一个服务接口  
```java
public interface DemoService {
    String sayHello(String name);
}
```

3.服务接口实现  
```java
@DubboService
public class DemoServiceImpl implements DemoService {
    @Override
    public String sayHello(String name) {
        return "Hello " + name;
    }
}
```
*提示:这里需要使用@DubboService注解将服务注册到Spring中*  

4.服务消费者  
```java
@Component
public class Task implements CommandLineRunner {
    @DubboReference
    private DemoService demoService;

    @Override
    public void run(String... args) throws Exception {
        String result = demoService.sayHello("world");
        System.out.println("Receive result ======> " + result);

        new Thread(()-> {
            while (true) {
                try {
                    Thread.sleep(1000);
                    System.out.println(new Date() + " Receive result ======> " + demoService.sayHello("world"));
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    Thread.currentThread().interrupt();
                }
            }
        }).start();
    }
}
```
*提示:通过@DubboReference注解对需要调用的服务进行依赖注入*  

5.编写服务消费者和服务生产者的yml  
```yml
dubbo:
  application:
    # 这里是服务提供者,如果是服务消费者就使用服务消费者的名称
    name: dubbo-springboot-demo-provider
    # 关闭qos
    qos-enable: false
  protocol:
    name: dubbo
    port: -1
  registry:
    # 选择一个合适的注册中心,推荐使用nacos
    # address: nacos://${nacos.address:192.168.230.128}:8848?username=nacos&password=nacos
    # address: zookeeper://${zookeeper.address:192.168.230.128}:2181
```

6.编写服务消费者和服务提供者的启动类  
```java
@SpringBootApplication
@EnableDubbo
public class ConsumerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ConsumerApplication.class, args);
    }
}
```
*提示:不管是服务消费者还是服务提供者,都需要在启动类上标注@EnableDubbo注解*  

7.运行  
运行成功后在消费者控制台成功打印如下内容  
![运行成功](resources/dubbo/1.png)  
同理查看远程nacos的信息  
服务列表和配置列表两个地方都有了两个微服务的相关信息,并且点击进入服务消费者或者服务生产者的详情会看到当前服务的元数据信息  
![元数据](resources/dubbo/2.png)  

#### 1.1.2 异步调用
*提示:本节的示例来自dubbo-sample->2-advanced->dubbo-samples-async-simple-boot*  

1.接口定义  
```java
public interface AsyncService {
    /**
     * 同步调用方法
     */
    String invoke(String param);
    /**
     * 异步调用方法
     */
    CompletableFuture<String> asyncInvoke(String param);
}
```

2.服务实现  
```java
@DubboService
public class AsyncServiceImpl implements AsyncService {

    @Override
    public String invoke(String param) {
        try {
            long time = ThreadLocalRandom.current().nextLong(1000);
            Thread.sleep(time);
            StringBuilder s = new StringBuilder();
            s.append("AsyncService invoke param:").append(param).append(",sleep:").append(time);
            return s.toString();
        }
        catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return null;
    }

    @Override
    public CompletableFuture<String> asyncInvoke(String param) {
        // 建议为supplyAsync提供自定义线程池
        return CompletableFuture.supplyAsync(() -> {
            try {
                // Do something
                long time = ThreadLocalRandom.current().nextLong(1000);
                Thread.sleep(time);
                StringBuilder s = new StringBuilder();
                s.append("AsyncService asyncInvoke param:").append(param).append(",sleep:").append(time);
                return s.toString();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return null;
        });
    }
}
```
通过`return CompletableFuture.supplyAsync()`,业务执行已从Dubbo线程切换到业务线程,避免了对Dubbo线程池的阻塞  
**理解:** 这句话是什么意思?每当来一个请求Dubbo都会起一个线程去处理,假设该线程要执行的业务方法时长非常长,则该线程会一直阻塞处理不被利用,而现在dubbo调用`asyncInvoke()`方法,该方法快速返回一个CompletableFuture接口不阻塞,dubbo拿到该返回对象就会自动使用业务线程来执行该方法,dubbo线程会立即得到释放,等到执行完毕之后再将结果返回出去.  

3.消费端异步  
```java
@DubboReference
private AsyncService asyncService;

@Override
public void run(String... args) throws Exception {
    //调用异步接口
    CompletableFuture<String> future1 = asyncService.asyncInvoke("async call request1");
    future1.whenComplete((v, t) -> {
        if (t != null) {
            t.printStackTrace();
        } else {
            System.out.println("AsyncTask Response-1: " + v);
        }
    });
    //两次调用并非顺序返回
    CompletableFuture<String> future2 = asyncService.asyncInvoke("async call request2");
    future2.whenComplete((v, t) -> {
        if (t != null) {
            t.printStackTrace();
        } else {
            System.out.println("AsyncTask Response-2: " + v);
        }
    });
    //consumer异步调用
    CompletableFuture<String> future3 =  CompletableFuture.supplyAsync(() -> {
        return asyncService.invoke("invoke call request3");
    });
    future3.whenComplete((v, t) -> {
        if (t != null) {
            t.printStackTrace();
        } else {
            System.out.println("AsyncTask Response-3: " + v);
        }
    });

    System.out.println("AsyncTask Executed before response return.");
}
```
*提示:这里的whenComplete()方法并不会阻塞,这样就可以做到同时发送多个远程调用,而不是等一个远程调用处理完毕之后再处理一个远程调用;这里的三个远程全是异步的*  

4.使用场景  
* 对于服务提供者来说,如果接口比较耗时,避免dubbo线程被阻塞,可以使用异步将线程切换到业务线程
* 对于服务消费者来说,要一次性调用多个dubbo接口,并且这些接口在时间上没有严格的顺序就可以使用异步调用
  最终组装数据的时候可以同步等待所有接口返回完毕后再组装数据,这个例子可以看之前的尚上优选项目


#### 1.1.3 版本与分组  
在dubbo中接口并不能唯一确定一个服务,<font color="#00FF00">只有接口+分组+版本号才能唯一确定一个服务</font>
*提示:本节的示例可以参考dubbo-sample->2-advanced->dubbo-samples-group*  
1.使用场景  
* 当同一个接口针对不同的业务场景、不同的使用需求或者不同的功能模块等场景,可使用服务分组来区分不同的实现方式.同时,这些不同实现所提供的服务是可并存的,也支持互相调用
* <font color="#00FF00">当接口实现需要升级又要保留原有实现的情况下,即出现不兼容升级时,我们可以使用不同版本号进行区分</font>

2.接口定义  
```java
public interface DevelopService {
    String invoke(String param);
}
```

3.接口实现  
使用`@DubboService`注解,添加group参数和version参数  
**接口实现1**  
```java
@DubboService(group = "group1",version = "1.0")
public class DevelopProviderServiceV1 implements DevelopService{
    @Override
    public String invoke(String param) {
        StringBuilder s = new StringBuilder();
        s.append("ServiceV1 param:").append(param);
        return s.toString();
    }
}
```

**接口实现2**  
```java
@DubboService(group = "group2",version = "2.0")
public class DevelopProviderServiceV2 implements DevelopService{
    @Override
    public String invoke(String param) {
        StringBuilder s = new StringBuilder();
        s.append("ServiceV2 param:").append(param);
        return s.toString();
    }
}
```

4.客户端调用  
> 使用`@DubboReference`注解,添加group参数和version参数  

```java
@DubboReference(group = "group1",version = "1.0")
private DevelopService developService;

@DubboReference(group = "group2",version = "2.0")
private DevelopService developServiceV2;

@Override
public void run(String... args) throws Exception {
    //调用DevelopService的group1分组实现
    System.out.println("Dubbo Remote Return ======> " + developService.invoke("1"));
    //调用DevelopService的group2分组实现
    System.out.println("Dubbo Remote Return ======> " + developServiceV2.invoke("2"));
}
```

4.小总结  
某个服务接口需要通过<font color="#FF00FF">接口+分组+版本号</font>才能唯一确定,这点相较于OpenFeign优势就非常大了  


#### 1.1.4 上下文参数传递
*提示:本节的示例可以参考dubbo-sample->2-advanced->dubbo-samples-async-simple-boot*  

在Dubbo3中,RpcContext被拆分为四大模块,它们分别担任不同的职责:  
* ServiceContext:在Dubbo内部使用,用于传递调用链路上的参数信息,如invoker对象等
* ClientAttachment:在Client端使用,往ClientAttachment中写入的参数将被传递到Server端
* ServerAttachment:在Server端使用,从ServerAttachment中读取的参数是从Client中传递过来的
  ServerAttachment和ClientAttachment是对应的
* ServerContext:在Client端和Server端使用,用于从Server端回传Client端使用,Server端写入到ServerContext的参数在调用结束后可以在Client端的ServerContext获取到

流程图大致如下  
![流程图](resources/dubbo/3.png)  


1.接口定义  
*提示:setAttachment设置的KV对,在完成下面一次远程调用会被清空,即多次远程调用要多次设置*  
```java
public interface ContextService {
    String invoke(String param);
}
```

2.服务实现  
```java
@DubboService
public class ContextServiceImpl implements ContextService{
    @Override
    public String invoke(String param) {
        //ServerAttachment接收客户端传递过来的参数
        Map<String, Object> serverAttachments = RpcContext.getServerAttachment().getObjectAttachments();
        System.out.println("ContextService serverAttachments:" + JSON.toJSONString(serverAttachments));
        //往客户端传递参数
        RpcContext.getServerContext().setAttachment("serverKey","serverValue");
        StringBuilder s = new StringBuilder();
        s.append("ContextService param:").append(param);
        return s.toString();
    }
}
```
`setAttachment`方法是设置一个KV键值对  
其中path、group、version、dubbo、token、timeout这几个字段是保留字段,不可以设置  

3.接口调用  
```java
//往服务端传递参数
RpcContext.getClientAttachment().setAttachment("clientKey1","clientValue1");
String res = contextService.invoke("context1");
//接收传递回来参数
Map<String, Object> clientAttachment = RpcContext.getServerContext().getObjectAttachments();
System.out.println("ContextTask clientAttachment:" + JSON.toJSONString(clientAttachment));
System.out.println("ContextService Return : " + res);
```

#### 1.1.5 泛化调用
泛化调用:是指调用方没有服务方提供的API(SDK)的情况下,对服务方进行调用,并且可以正常拿到调用结果  
之前的实验结果有一个前提是服务消费者拥有<font color="#00FF00">定义的接口</font>并且使用`@DubboReference`直接依赖注入了该接口,假设现在服务消费者没有该接口的定义,则如何调用目标服务并拿到返回值便是泛化调用  

*提示:本节示例参考自2-advanced=>dubbo-samples-generic=>dubbo-samples-generic-call*  

1.接口定义  
```java
public interface DevelopService {
    String invoke(String param);
}
```

2.接口实现1  
```java
@DubboService(group = "group1",version = "1.0")
public class DevelopProviderServiceV1 implements DevelopService{
    @Override
    public String invoke(String param) {
        StringBuilder s = new StringBuilder();
        s.append("ServiceV1 param:").append(param);
        return s.toString();
    }
}
```

3.消费者调用  
```java
@Component
public class GenericTask implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        GenericService genericService = buildGenericService("org.apache.dubbo.samples.develop.DevelopService","group2","2.0");
        //传入需要调用的方法,参数类型列表,参数列表
        Object result = genericService.$invoke("invoke", new String[]{"java.lang.String"}, new Object[]{"g1"});
        System.out.println("GenericTask Response: " + JSON.toJSONString(result));
    }

    private GenericService buildGenericService(String interfaceClass, String group, String version) {
        ReferenceConfig<GenericService> reference = new ReferenceConfig<>();
        reference.setInterface(interfaceClass);
        reference.setVersion(version);
        //开启泛化调用
        reference.setGeneric("true");
        reference.setTimeout(30000);
        reference.setGroup(group);
        ReferenceCache cache = SimpleReferenceCache.getCache();
        try {
            return cache.get(reference);
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }
}
```

#### 1.1.6 IDL开发服务
Dubbo开发的基本流程是:用户定义RPC服务,通过约定的配置方式将RPC声明为dubbo服务,然后就可以基于服务API进行变成了,<font color="#00FF00">对服务提供者来说是提供RPC服务的具体实现,而对服务消费者来说则是使用特定数据发起服务调用</font>.  
我们之前使用的特定数据实际上是依赖注入的`@DubboReference`接口,<font color="#FF00FF">IDL的思想是为了具备通用性,为了能够实现跨语言调用而提出的一种通用的接口定义格式</font>  
*提示:本节内容参考自3-extensions=>protocol=>dubbo-samples-triple*  

1.定义服务  
Dubbo3推荐使用IDL定义跨语言服务  
```proto
syntax = "proto3";

option java_multiple_files = true;
option java_package = "org.apache.dubbo.demo";
option java_outer_classname = "DemoServiceProto";
option objc_class_prefix = "DEMOSRV";

package demoservice;

// The demo service definition.
service DemoService {
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```
以上是使用IDL定义服务的一个简单示例(它的作用就类似我们之前定义的Java接口,但为了通用性别的语言肯定没有Java接口这种说法,<font color="#FF00FF">所以就高度抽象出一种语言无关的接口定义,这就是IDL</font>),我们可以把它命名为DemoService.proto,即IDL定义的服务文件名以.proto结尾;<font color="#00FF00">那么这个文件就可以做到一次编写到处使用了</font>  

proto文件中定义了RPC服务名称DemoService与方法签名S`ayHello (HelloRequest) returns (HelloReply) {}`,同时还定义了方法的入参结构体、出参结构体HelloRequest与HelloReply.IDL格式的服务依赖<font color="#00FF00">Protobuf编译器</font>,用来生成可以被用户调用的客户端与服务端编程API,<font color="#DDDD00">Dubbo在原生Protobuf Compiler的基础上提供了适配多种语言的特有插件</font>,框架特有的API与编程模型  
> 使用Dubbo3 IDL定义的服务只允许一个入参与出参,这种形式的服务签名有两个优势,一是对多语言实现更友好,二是可以保证服务的向后兼容性,依赖于Protobuf序列化的兼容性,我们可以很容易的调整传输的数据结构如增、删字段等,完全不用担心接口的兼容性

2.编译服务  
根据当前采用的比编程语言,配置相应的Protobuf插件,编译后将产生生产语言相关的服务定义stub  
Java compiler配置参考(本质是通过Maven插件来实现的)  
```xml
<plugin>
    <groupId>org.xolstice.maven.plugins</groupId>
    <artifactId>protobuf-maven-plugin</artifactId>
    <version>0.6.1</version>
    <configuration>
        <protocArtifact>com.google.protobuf:protoc:${protoc.version}:exe:${os.detected.classifier}
        </protocArtifact>
        <pluginId>grpc-java</pluginId>
        <pluginArtifact>io.grpc:protoc-gen-grpc-java:${grpc.version}:exe:${os.detected.classifier}
        </pluginArtifact>
        <protocPlugins>
            <protocPlugin>
                <id>dubbo</id>
                <groupId>org.apache.dubbo</groupId>
                <artifactId>dubbo-compiler</artifactId>
                <version>3.0.10</version>
                <mainClass>org.apache.dubbo.gen.tri.Dubbo3TripleGenerator</mainClass>
            </protocPlugin>
        </protocPlugins>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>compile</goal>
                <goal>test-compile</goal>
                <goal>compile-custom</goal>
                <goal>test-compile-custom</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

Java语言通过Protobuf生成的stub如下,实际上就是生成之前我们手动定义的那个Java接口  
```java
@javax.annotation.Generated(
value = "by Dubbo generator",
comments = "Source: DemoService.proto")
public interface DemoService {
    static final String JAVA_SERVICE_NAME = "org.apache.dubbo.demo.DemoService";
    static final String SERVICE_NAME = "demoservice.DemoService";

    org.apache.dubbo.demo.HelloReply sayHello(org.apache.dubbo.demo.HelloRequest request);

    CompletableFuture<org.apache.dubbo.demo.HelloReply> sayHelloAsync(org.apache.dubbo.demo.HelloRequest request);
}
```

Go语言生成的stub如下  
```go
func _DUBBO_Greeter_SayHello_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(HelloRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	base := srv.(dgrpc.Dubbo3GrpcService)
	args := []interface{}{}
	args = append(args, in)
	invo := invocation.NewRPCInvocation("SayHello", args, nil)
	if interceptor == nil {
		result := base.GetProxyImpl().Invoke(ctx, invo)
		return result.Result(), result.Error()
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/main.Greeter/SayHello",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		result := base.GetProxyImpl().Invoke(context.Background(), invo)
		return result.Result(), result.Error()
	}
	return interceptor(ctx, in, info, handler)
}
```

3.配置并加载服务  
服务提供者负责提供具体的dubbo服务实现,也就是遵循RPC签名所约束的格式,去实现具体的业务逻辑代码.在实现服务之后,<font color="#00FF00">要将服务实现注册为标准的Dubbo服务</font>,之后Dubbo框架就能根据接收到的请求转发给服务实现,执行方法,并将结果返回.  
消费端的配置会更简单一些,只需要声明IDL定义的服务为标准的Dubbo服务,框架就可以帮助开发者生成相应的proxy,开发者将完全<font color="#FF00FF">面向proxy编程</font>,基本上Dubbo所有语言的实现都保证了proxy依据IDL服务定义暴露标准化的接口  

Java生产者端代码示例  
```java
public class DemoServiceImpl implements DemoService {
    private static final Logger logger = LoggerFactory.getLogger(DemoServiceImpl.class);

    @Override
    public HelloReply sayHello(HelloRequest request) {
        logger.info("Hello " + request.getName() + ", request from consumer: " + RpcContext.getContext().getRemoteAddress());
        return HelloReply.newBuilder()
    .setMessage("Hello " + request.getName() + ", response from provider: "
            + RpcContext.getContext().getLocalAddress())
    .build();
    }

    @Override
    public CompletableFuture<HelloReply> sayHelloAsync(HelloRequest request) {
        return CompletableFuture.completedFuture(sayHello(request));
    }
}
```

4.服务生产者注册服务(以Spring XML为例)  
```xml
<bean id="demoServiceImpl" class="org.apache.dubbo.demo.provider.DemoServiceImpl"/>
<dubbo:service serialization="protobuf" interface="org.apache.dubbo.demo.DemoService" ref="demoServiceImpl"/>
```

5.服务消费者引用服务  
```xml
<dubbo:reference scope="remote" id="demoService" check="false" interface="org.apache.dubbo.demo.DemoService"/>
```

6.服务消费者使用服务proxy  
```java
public void callService() throws Exception {
    // do something...
    DemoService demoService = context.getBean("demoService", DemoService.class);
    HelloRequest request = HelloRequest.newBuilder().setName("Hello").build();
    HelloReply reply = demoService.sayHello(request);
    System.out.println("result: " + reply.getMessage());
}
```

### 1.2 部署服务  
**目录:**  
1.2.1 部署到虚拟机  
1.2.2 部署到docker  
1.2.3 部署到K8S+docker  
1.2.4 部署到K8S+Containerd  

#### 1.2.2 部署到docker
1.工作原理  
![工作原理](resources/dubbo/4.png)  

2.详情  
详情见:[https://cn.dubbo.apache.org/zh-cn/overview/tasks/deploy/deploy-on-docker/](https://cn.dubbo.apache.org/zh-cn/overview/tasks/deploy/deploy-on-docker/)  


### 1.3 流量管理
**目录:**  
1.3.1 流量管理基本介绍  
1.3.2 调整超时时间  
1.3.3 服务重试  
1.3.4 访问日志  



#### 1.3.1 流量管理基本介绍
1.实验环境  
本次实验环境基于一个简单的线上商城微服务系统演示了Dubbo的流量管控能力  
线上商城架构图如下  
![线上商城](resources/dubbo/5.png)  
系统由5个微服务应用组成:  
* Frontend商城主页:作为与用户交互的web界面,通过调用User、Detail、Order模块为用户提供服务
* User用户服务:负责用户数据管理、身份校验等
* Order订单服务:提供订单创建、订单查询等服务,调用`Detail`服务校验商品库存等信息
* Detail商品详情服务:展示商品详情信息,调用`Comment`服务展示用户对商品的评论记录
* Comment评论服务:管理用户对商品的评论数据

2.部署商城系统  
本节的代码参考自:dubbo-sample=>10-task=>dubbo-samples-shop  

3.完整部署的架构图  
![完整部署的架构图](resources/dubbo/6.png)  
`Order`订单服务有两个版本V1和V2,V2是订单服务优化后发布的新版本
* 版本v1只是简单的创建订单,不展示订单详情
* 版本v2在订单创建成功后会展示订单的收货地址详情

`Detail`和`Comment`服务也分别有两个版本v1和v2,我们通过多个版本来演示流量导流后的效果  
* 版本v1默认为所有请求提供服务
* 版本v2模拟被部署在特定的区域的服务,因此v2实例会带有特定的标签
  关于标签详情见dubboBasis笔记 2.dubbo功能=>2.5 流量管理=>2.5.2 标签路由

4.支撑环境  
除了上述的微服务外,示例还拉起了nacos注册中心、Dubbo Admin控制台和Skywalking链路追踪  

#### 1.3.2 调整超时时间
1.需求解释  
商城项目通过org.apache.dubbo.samples.UserService提供用户信息管理服务,访问 http://localhost:8080/ 打开商城并输入任意账号密码,点击Login即可以正常登录到系统  
![正常登录](resources/dubbo/7.png)  
有些场景下,User服务的运行速度会变慢,比如存储用户数据的数据库负载过高导致查询变慢,这时就会出现UserService访问超时的情况,导致登录失败  
![登陆超时](resources/dubbo/8.png)  

2.动态调整超时时间  
为了解决突发的登录超时问题,我们只需要<font color="#00FF00">适当增加UserService服务调用的等待时间即可</font>  

3.1 打开Dubbo Admin控制台  
3.2 在左侧导航栏选择[服务治理]>[动态配置]  
3.3 点击"创建",输入服务`org.apache.dubbo.samples.UserService`和新的超时时间如2000即可  
![超时](resources/dubbo/9.png)  

4.规则解释  
```yml
configVersion: v3.0
enabled: true
configs:
    # 针对服务提供者
  - side: provider
    parameters:
      timeout: 2000
```
从`UserService`<font color="#00FF00">服务提供者视角</font>,将超时时间总体调整为2S,超时是针对服务提供者的  
`side: provider`配置会将规则发送到服务提供方实例,所有UserService服务实例会基于新的timeout值进行重新发布,并通过注册中心通知给所有消费方  
如果要基于服务粒度,<font color="#00FF00">则需要使用之前提到的scope: service作用域</font>  

#### 1.3.3 服务重试  
1.实验背景  
现在Frontend这个微服务需要访问User这个微服务,获取用户的个人信息;但User这个微服务本身可能存在网络不稳定等问题导致Frontend微服务获取用户信息的时候超时  
此时就可以通过设置Frontend微服务的超时次数从而使得数据最终能够展示出来  

2.1 打开Dubbo Admin控制台  
2.2 点击左侧导航栏选择**服务治理 -> 动态配置**  
2.3 点击创建,输入服务`org.apache.dubbo.samples.UserService`和失败重试次数即可  

3.规则详解  
规则key:`org.apache.dubbo.samples.UserService`  
规则体:  
```yml
configVersion: v3.0
enabled: true
configs:
    # 规则针对服务消费者
  - side: consumer
    parameters:
      # 设置重试次数为5次
      retries: 5
```

关于这里的key再说一下,dubbo中key就表明当前规则要对哪个对象生效,同时它需要配合scope使用  
<font color="#00FF00">当scope:service时,</font><font color="#FF00FF">key应该是该规则生效的服务名(Service)比如org.apache.dubbo.samples.CommentService,表明当前规则只对所有微服务的接口生效</font>  
<font color="#00FF00">当scope:application时,</font><font color="#FF00FF">则key应该是该规则应该生效的应用名称,比如说my-dubbo-service;则表明该规则对所有my-dubbo-service微服务下的所有接口生效</font>  

#### 1.3.4 访问日志  
1.实验背景  
商城的所有用户服务都由`User`应用的`UserService`提供,通过这个任务,我们为`User`应用的某一台或几台机器<font color="#00FF00">开启访问日志</font>,以便观察用户服务的整体访问情况  

2.动态开启访问日志  
通过dubbo的`accesslog`标记识别访问日志的开启状态   

3.1 打开Dubbo Admin控制台  
3.2 点击左侧导航栏选择**服务治理 -> 动态配置**  
3.3 点击创建,输入应用名`shop-user`并勾选开启访问日志  

4.再次登陆页面,查看任意一台User实例机器(物理机器),可以看到如下格式的访问日志  
```shell
[2022-12-30 12:36:31.15900] -> [2022-12-30 12:36:31.16000] 192.168.0.103:60943 -> 192.168.0.103:20884 - org.apache.dubbo.samples.UserService login(java.lang.String,java.lang.String) ["test",""], dubbo version: 3.2.0-beta.4-SNAPSHOT, current host: 192.168.0.103
[2022-12-30 12:36:33.95900] -> [2022-12-30 12:36:33.95900] 192.168.0.103:60943 -> 192.168.0.103:20884 - org.apache.dubbo.samples.UserService getInfo(java.lang.String) ["test"], dubbo version: 3.2.0-beta.4-SNAPSHOT, current host: 192.168.0.103
[2022-12-30 12:36:31.93500] -> [2022-12-30 12:36:34.93600] 192.168.0.103:60943 -> 192.168.0.103:20884 - org.apache.dubbo.samples.UserService getInfo(java.lang.String) ["test"], dubbo version: 3.2.0-beta.4-SNAPSHOT, current host: 192.168.0.103
```  

5.规则详解  
规则key:`shop-user`(表明为所有shop-user应用开启)  
规则体:  
```yml
configVersion: v3.0
enabled: true
configs:
  - side: provider
    parameters:
      accesslog: true
```

accesslog的有效值如下:
* `true`或`default`时,访问日志将随业务logger一同输出,此时可以在应用内提前配置 `dubbo.accesslog`appender调整日志的输出位置和格式
* 具体的文件路径如`/home/admin/demo/dubbo-access.log`这样访问日志将打印到指定的文件内容

在Admin界面,还可以单独指定开启某一台机器的访问日志,以方便精准排查问题,对应的后台规则如下  
```yml
configVersion: v3.0
enabled: true
configs:
  - match
     address:
       oneof:
        - wildcard: "{ip}:*"
    side: provider
    parameters:
      accesslog: true
```
