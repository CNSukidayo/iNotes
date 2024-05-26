# 目录  
1.配置说明  
2.源码架构  
3.QOS操作手册  
4.RPC协议  
5.配置中心  
6.元数据中心  
7.注册中心  
8.Mesh手册  
9.性能参考手册  
10.SPI扩展使用手册  
11.序列化  



## 1.配置说明
**目录:**  
1.1 配置概述  
1.2 API配置  
1.3 Annotation配置  
1.4 XML配置  
1.5 配置工作原理  
1.6 配置项手册  

### 1.1 配置概述
1.配置形式  
dubbo的<font color="#00FF00">配置形式</font>主要分为API配置、XML配置、Annotation(注解)配置、SpringBoot配置;

2.配置来源
dubbo的<font color="#00FF00">配置来源</font>有如下几种:  
* JVM System Properties(JVM系统配置),即通过`JVM -D [parameter]`来指定dubbo配置
* System environment(系统环境变量)
* Externalized Configuration(外部化配置),从配置中心读取配置
* Application Configuration(应用配置),从Spring应用的Environment中提取"dubbo"打头的属性集
* <font color="#00FF00">API/XML/注解</font>等编程接口采集的配置可以被理解成配置来源的一种,是直接面向用户编程的配置采集方式(编程式配置)
* 从classpath读取配置文件`dubbo.properties`
  关于dubbo.properties属性:
  * 如果在classpath下有超过一个dubbo.properties文件;比如两个jar包都<font color="#00FF00">各自包含</font>了dubbo.properties,<font color="#00FF00">dubbo将随机选择一个加载,并且打印错误日志</font>
  * Dubbo默认自动加载classpath根目录下的dubbo.properties,但是你同样可以使用 JVM参数来指定加载路径:`-Ddubbo.properties.file=xxx.propertie`


### 1.2 API配置  
1.特性说明  
通过API编码方式组装配置、启动 Dubbo、发布及订阅服务;此方式可以支持动态创建 ReferenceConfig/ServiceConfig,结合<font color="#00FF00">泛化调用</font>可以满足API Gateway或测试平台的需要  
*提示:本节的示例可以参考dubbo-sample->1-basic->dubbo-samples-api*  

2.服务提供者(Provider)  
通过`ServiceConfig`暴露服务接口,发布服务接口到注册中心  
*提示:为了更好支持Dubbo3应用级服务发现,推荐使用新的DubboBootstrap API,DubboBootstrap API见本节第4小点*  

```java
public class DemoProvider {
    public static void main(String[] args) {
        // 服务实现
        DemoService demoService = new DemoServiceImpl();

        // 当前应用配置
        ApplicationConfig application = new ApplicationConfig();
        application.setName("demo-provider");

        // 连接注册中心配置
        RegistryConfig registry = new RegistryConfig();
        registry.setAddress("zookeeper://10.20.130.230:2181");

        // 服务提供者协议配置
        ProtocolConfig protocol = new ProtocolConfig();
        protocol.setName("dubbo");
        protocol.setPort(12345);
        protocol.setThreads(200);

        // 注意：ServiceConfig为重对象,内部封装了与注册中心的连接,以及开启服务端口
        // 服务提供者暴露服务配置
        ServiceConfig<DemoService> service = new ServiceConfig<DemoService>(); // 此实例很重,封装了与注册中心的连接,请自行缓存,否则可能造成内存和连接泄漏
        service.setApplication(application);
        service.setRegistry(registry); // 多个注册中心可以用setRegistries()
        service.setProtocol(protocol); // 多个协议可以用setProtocols()
        service.setInterface(DemoService.class);
        service.setRef(demoService);
        service.setVersion("1.0.0");

        // 暴露及注册服务
        service.export();

        // 挂起等待(防止进程退出）
        System.in.read();
    }
}
```

3.服务消费者  
通过`ReferenceConfig`引用远程服务,从注册中心订阅服务接口  
```java
public class DemoConsumer {
    public static void main(String[] args) {
        // 当前应用配置
        ApplicationConfig application = new ApplicationConfig();
        application.setName("demo-consumer");

        // 连接注册中心配置
        RegistryConfig registry = new RegistryConfig();
        registry.setAddress("zookeeper://10.20.130.230:2181");

        // 注意：ReferenceConfig为重对象,内部封装了与注册中心的连接,以及与服务提供方的连接
        // 引用远程服务
        ReferenceConfig<DemoService> reference = new ReferenceConfig<DemoService>(); // 此实例很重,封装了与注册中心的连接以及与提供者的连接,请自行缓存,否则可能造成内存和连接泄漏
        reference.setApplication(application);
        reference.setRegistry(registry); // 多个注册中心可以用setRegistries()
        reference.setInterface(DemoService.class);
        reference.setVersion("1.0.0");

        // 和本地bean一样使用demoService
        // 注意：此代理对象内部封装了所有通讯细节,对象较重,请缓存复用
        DemoService demoService = reference.get();
        demoService.sayHello("Dubbo");
    }
}
```

4.Bootstrap API  
通过`DubboBootstrap API`可以减少重复配置,更好控制启动过程,<font color="#00FF00">支持批量发布/订阅服务接口</font>,还可以更好支持Dubbo3的应用级服务发现
4.1 服务端配置    
```java
public class DemoProvider {
    public static void main(String[] args) {

        ConfigCenterConfig configCenter = new ConfigCenterConfig();
        configCenter.setAddress("zookeeper://127.0.0.1:2181");

        // 服务提供者协议配置
        ProtocolConfig protocol = new ProtocolConfig();
        protocol.setName("dubbo");
        protocol.setPort(12345);
        protocol.setThreads(200);

        // 注意：ServiceConfig为重对象,内部封装了与注册中心的连接,以及开启服务端口
        // 服务提供者暴露服务配置
        ServiceConfig<DemoService> demoServiceConfig = new ServiceConfig<>();
        demoServiceConfig.setInterface(DemoService.class);
        demoServiceConfig.setRef(new DemoServiceImpl());
        demoServiceConfig.setVersion("1.0.0");

        // 第二个服务配置
        ServiceConfig<FooService> fooServiceConfig = new ServiceConfig<>();
        fooServiceConfig.setInterface(FooService.class);
        fooServiceConfig.setRef(new FooServiceImpl());
        fooServiceConfig.setVersion("1.0.0");

        ...

        // 通过DubboBootstrap简化配置组装,控制启动过程
        DubboBootstrap.getInstance()
                .application("demo-provider") // 应用配置
                .registry(new RegistryConfig("zookeeper://127.0.0.1:2181")) // 注册中心配置
                .protocol(protocol) // 全局默认协议配置
                .service(demoServiceConfig) // 添加ServiceConfig
                .service(fooServiceConfig)
                .start()    // 启动Dubbo
                .await();   // 挂起等待(防止进程退出）
    }
}
```

4.2 客户端配置  
```java
public class DemoConsumer {
    public static void main(String[] args) {

        // 引用远程服务
        ReferenceConfig<DemoService> demoServiceReference = new ReferenceConfig<DemoService>();
        demoServiceReference.setInterface(DemoService.class);
        demoServiceReference.setVersion("1.0.0");

        ReferenceConfig<FooService> fooServiceReference = new ReferenceConfig<FooService>();
        fooServiceReference.setInterface(FooService.class);
        fooServiceReference.setVersion("1.0.0");

        // 通过DubboBootstrap简化配置组装,控制启动过程
        DubboBootstrap bootstrap = DubboBootstrap.getInstance();
        bootstrap.application("demo-consumer") // 应用配置
                .registry(new RegistryConfig("zookeeper://127.0.0.1:2181")) // 注册中心配置
                .reference(demoServiceReference) // 添加ReferenceConfig
                .reference(fooServiceReference)
                .start();    // 启动Dubbo

        ...

        // 和本地bean一样使用demoService
        // 通过Interface获取远程服务接口代理,不需要依赖ReferenceConfig对象
        DemoService demoService = DubboBootstrap.getInstance().getCache().get(DemoService.class);
        demoService.sayHello("Dubbo");

        FooService fooService = DubboBootstrap.getInstance().getCache().get(FooService.class);
        fooService.greeting("Dubbo");
    }

}
```

5.其它配置  
*提示:API提供了最灵活丰富的配置能力,以下几点是一些可配置组件示例*  
5.1 基本配置  
可以在DubboBootstrap中设置全局基本配置,包括<font color="#00FF00">应用配置、协议配置、注册中心、配置中心、元数据中心、模块、监控、SSL、provider 配置、consumer配置</font>等  

5.2 方法级设置  
```java
// 方法级配置
List<MethodConfig> methods = new ArrayList<MethodConfig>();
MethodConfig method = new MethodConfig();
method.setName("sayHello");
method.setTimeout(10000);
method.setRetries(0);
methods.add(method);

// 引用远程服务
ReferenceConfig<DemoService> reference = new ReferenceConfig<DemoService>(); // 此实例很重,封装了与注册中心的连接以及与提供者的连接,请自行缓存,否则可能造成内存和连接泄漏
reference.setMethods(methods); // 设置方法级配置
```
5.3 点对点直连  
```java
// 此实例很重,封装了与注册中心的连接以及与提供者的连接,请自行缓存,否则可能造成内存和连接泄漏
ReferenceConfig<DemoService> reference = new ReferenceConfig<DemoService>();
// 如果点对点直连,可以用reference.setUrl()指定目标地址,设置url后将绕过注册中心,
// 其中,协议对应provider.setProtocol()的值,端口对应provider.setPort()的值,
// 路径对应service.setPath()的值,如果未设置path,缺省path为接口名
reference.setUrl("dubbo://10.20.130.230:20880/com.xxx.DemoService");
```

### 1.3 Annotation配置
1.特性说明  
在Dubbo Spring Boot开发中,你只需要增加几个注解,并配置application.properties或application.yml文件即可完成Dubbo服务定义:  
* 注解有`@DubboService`、`@DubboReference`、`@EnableDubbo`
  其中`@DubboService`与`@DubboReference`用于标记Dubbo服务,`@EnableDubbo`启动Dubbo相关配置并指定SpringBoot扫描包路径
* 配置文件`application.properties`或`application.yml`

*提示:本节的示例可以参考dubbo-sample->1-basic->dubbo-samples-annotation*  

2.添加Maven依赖  
```xml
<dependencyManagement>
    <dependencies>
        <!-- Spring Boot -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>${spring-boot.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!-- Dubbo -->
        <dependency>
            <groupId>org.apache.dubbo</groupId>
            <artifactId>dubbo-bom</artifactId>
            <version>${dubbo.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!-- Zookeeper -->
        <!-- NOTICE: Dubbo only provides dependency management module for Zookeeper, add Nacos or other product dependency directly if you want to use them. -->
        <dependency>
            <groupId>org.apache.dubbo</groupId>
            <artifactId>dubbo-dependencies-zookeeper</artifactId>
            <version>${dubbo.version}</version>
            <type>pom</type>
        </dependency>
    </dependencies>
</dependencyManagement>
```

3.application.yml或application.properties  
除service、reference之外的组件都可以在application.yml文件中设置,如果要扩展service或reference的注解配置,则需要增加dubbo.properties配置文件或使用其他非注解如`Java Config`方式;具体请看下文  

service、reference组件也可以通过id与application中的全局组件做关联,以下面配置为例  
```yml
dubbo:
  application:
    name: dubbo-springboot-demo-provider
  protocol:
    name: dubbo
    port: -1
  registry:
    id: zk-registry
    address: zookeeper://127.0.0.1:2181
  config-center:
    address: zookeeper://127.0.0.1:2181
  metadata-report:
    address: zookeeper://127.0.0.1:2181
```
<font color="#00FF00">通过注解将service关联到上文定义的特定注册中心</font>  
```java
@DubboService(registry="zk-registry")
public class DemoServiceImpl implements DemoService {}
```

通过Java Config配置进行关联也是同样道理  
```java
@Configuration
public class ProviderConfiguration {
    @Bean
    public ServiceConfig demoService() {
        ServiceConfig service = new ServiceConfig();
        service.setRegistry("zk-registry");
        return service;
    }
}
```

4.注解  
4.1 `@DubboService`  
定义好Dubbo服务接口后,提供服务接口的实现逻辑,并用`@DubboService`注解标记,就可以<font color="#00FF00">实现Dubbo服务的暴露</font>  
```java
@DubboService
public class DemoServiceImpl implements DemoService {}
```
如果要设置服务参数,@DubboService也提供了常用参数的设置方式;如果有更复杂的参数设置需求,则可以考虑使用其他设置方式  
```java
@DubboService(version = "1.0.0", group = "dev", timeout = 5000)
public class DemoServiceImpl implements DemoService {}
```

4.2 `@DubboReference`注解  
`@DubboReference`注解将自动注入为Dubbo服务代理实例,使用demoService即可发起远程服务调用  
```java
@Component
public class DemoClient {
    @DubboReference
    private DemoService demoService;
}
```

4.3 `@EnableDubbo`注解  
`@EnableDubbo`注解必须配置,<font color="#00FF00">否则将无法加载Dubbo注解定义的服务</font>,`@EnableDubbo`可以定义在主类上  
```java
@SpringBootApplication
@EnableDubbo
public class ProviderApplication {
    public static void main(String[] args) throws Exception {
        SpringApplication.run(ProviderApplication.class, args);
    }
}
```

Spring Boot注解默认只会扫描main类所在的package,如果服务定义在其它package中,<font color="#00FF00">需要增加配置EnableDubbo(scanBasePackages = {"org.apache.dubbo.springboot.demo.provider"})</font>  

4.4 扩展注解配置  
虽然可以通过`@DubboService`和`@DubboReference`调整配置参数(如下代码片段所示),但总体来说注解提供的配置项还是非常有限;在这种情况下,如果有更复杂的参数设置需求,<font color="#00FF00">可以使用Java Config或dubbo.properties两种方式</font>  

4.5 使用JavaConfig代替注解  
注意,Java Config是`DubboService`或`DubboReference`的<font color="#00FF00">替代方式</font>,<font color="#FF00FF">对于有复杂配置需求的服务建议使用这种方式</font>  
```java
@Configuration
public class ProviderConfiguration {
    @Bean
    public ServiceConfig demoService() {
        ServiceConfig service = new ServiceConfig();
        service.setInterface(DemoService.class);
        service.setRef(new DemoServiceImpl());
        service.setGroup("dev");
        service.setVersion("1.0.0");
        Map<String, String> parameters = new HashMap<>();
        service.setParameters(parameters);
        return service;
    }
}
```

4.6 通过dubbo.properties补充配置  
对于使用`DubboService`或`DubboReference`的场景,可以使用`dubbo.properties`作为配置补充,示例如下  
```properties
dubbo.service.org.apache.dubbo.springboot.demo.DemoService.timeout=5000
dubbo.service.org.apache.dubbo.springboot.demo.DemoService.parameters=[{myKey:myValue},{anotherKey:anotherValue}]
dubbo.reference.org.apache.dubbo.springboot.demo.DemoService.timeout=6000
```

### 1.4 XML配置  
1.特性介绍  
Dubbo有基于Spring Schema扩展的自定义配置组件,<font color="#00FF00">使用XML能达到的配置能力总体与<font color="#FF00FF">配置参考手册</font>对等</font>  
*提示:本节的示例可以参考dubbo-sample->1-basic->dubbo-samples-spring-xml*  

2.服务提供者  
2.1 定义服务接口  
```java
public interface DemoService {
    String sayHello(String name);
}
```

2.2 在服务提供方实现接口  
```java
public class DemoServiceImpl implements DemoService {
    public String sayHello(String name) {
        return "Hello " + name;
    }
}
```

2.3 使用spring配置声明暴露服务  
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xmlns="http://www.springframework.org/schema/beans" xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    <context:property-placeholder/>

    <dubbo:application name="demo-provider"/>

    <dubbo:registry address="zookeeper://${zookeeper.address:127.0.0.1}:2181"/>

    <dubbo:provider token="true"/>

    <bean id="demoService" class="org.apache.dubbo.samples.basic.impl.DemoServiceImpl"/>

    <dubbo:service interface="org.apache.dubbo.samples.basic.api.DemoService" ref="demoService"/>

</beans>
```

2.4 加载Spring配置  
```java
public class DemoServiceImpl implements DemoService {
    @Override
    public String sayHello(String name) {
        System.out.println("[" + new SimpleDateFormat("HH:mm:ss").format(new Date()) + "] Hello " + name +
                ", request from consumer: " + RpcContext.getContext().getRemoteAddress());
        return "Hello " + name + ", response from provider: " + RpcContext.getContext().getLocalAddress();
    }
}
```

3.服务消费者  
3.1 使用Spring配置引用远程服务  
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xmlns="http://www.springframework.org/schema/beans" xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    <context:property-placeholder/>

    <dubbo:application name="demo-consumer"/>

    <dubbo:registry address="zookeeper://${zookeeper.address:127.0.0.1}:2181"/>

    <dubbo:reference id="demoService" check="true" interface="org.apache.dubbo.samples.basic.api.DemoService"/>

</beans>
```

3.2 加载Spring配置,并调用远程服务  
```java
public class BasicConsumer {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring/dubbo-demo-consumer.xml");
        context.start();
        DemoService demoService = (DemoService) context.getBean("demoService");
        String hello = demoService.sayHello("world");
        System.out.println(hello);
    }
}
```

### 1.5 配置工作原理
1.配置示例  
```properties
# Spring boot application
spring.applicationname=dubbo-externalized-configuration-provider-sample
# Base packages to scan Dubbo Component: @com.alibaba.dubbo.configannotation.Service
dubbo.scan.base-packages=com.alibaba.boot.dubbo.demo.providerservice
# Dubbo Application
## The default value of dubbo.application.name is ${springapplication.name}
## dubbo.application.name=${spring.application.name}
# Dubbo Protocol
dubbo.protocol.name=dubbo
dubbo.protocol.port=12345
## Dubbo Registry
dubbo.registry.address=N/A
## service default version
dubbo.provider.version=1.0.0
```

接下来,我们就围绕这个示例,分别从<font color="#00FF00">配置格式、配置来源、加载流程</font>三个方面对Dubbo配置的工作原理进行分析  

2.配置格式  
目前Dubbo支持的所有配置都是`.properties`格式的,包括`-D、Externalized Configuration`等配置来源,`.properties`中的所有配置项目遵循一种`path-based`的配置格式  
<font color="#00FF00">在Spring应用中也可以将属性配置放到application.yml中,其树层次结构的方式可读性更好一些</font>  
```properties
# 应用级配置（无id）
dubbo.{config-type}.{config-item}={config-item-value}

# 实例级配置（指定id或name）
dubbo.{config-type}s.{config-id}.{config-item}={config-item-value}
dubbo.{config-type}s.{config-name}.{config-item}={config-item-value}

# 服务接口配置
dubbo.service.{interface-name}.{config-item}={config-item-value}
dubbo.reference.{interface-name}.{config-item}={config-item-value}

# 方法配置
dubbo.service.{interface-name}.{method-name}.{config-item}={config-item-value}
dubbo.reference.{interface-name}.{method-name}.{config-item}={config-item-value}

# 方法argument配置
dubbo.reference.{interface-name}.{method-name}.{argument-index}.{config-item}={config-item-value}
```

2.1 应用级配置(无id)  
```properties
# 应用级配置（无id）
dubbo.{config-type}.{config-item}={config-item-value}
```

类似`application、monitor、metrics`等都属于应用级别组件,因此仅允许配置单个实例;而`protocol、registry`等允许配置多个的组件,在仅需要进行单例配置时,可采用此节描述的格式.常见示例如下:  
```properties
dubbo.application.name=demo-provider
dubbo.application.qos-enable=false

dubbo.registry.address=zookeeper://127.0.0.1:2181

dubbo.protocol.name=dubbo
dubbo.protocol.port=-1
```

2.2 实例级配置(指定id或name)  
针对某个实例的属性配置需要指定id或者name,其前缀格式为:<font color="#00FF00">配置类型+s + id/name</font>;适用于protocol、registry等支持多例配置的组件  
```properties
# 实例级配置(指定id或name)
dubbo.{config-type}s.{config-id}.{config-item}={config-item-value}
dubbo.{config-type}s.{config-name}.{config-item}={config-item-value}
```
*提示:相较于2.1,这里的{config-type}后面加了一个s*  

* 如果不存在该id或者name的实例,则框架会基于这里列出来的属性创建配置组件实例
* 如果已存在相同id或name的实例,则框架会将这里的列出的属性作为已有实例配置的补充,详细请参考本节的<font color="#00FF00">属性覆盖</font>
* 具体的配置复数形式可以参考<font color="#00FF00">单复数配置对照表</font>

配置示例  
```properties
dubbo.registries.unit1.address=zookeeper://127.0.0.1:2181
dubbo.registries.unit2.address=zookeeper://127.0.0.1:2182

dubbo.protocols.dubbo.name=dubbo
dubbo.protocols.dubbo.port=20880

dubbo.protocols.hessian.name=hessian
dubbo.protocols.hessian.port=8089
```

2.3 服务接口配置  
```properties
dubbo.service.org.apache.dubbo.samples.api.DemoService.timeout=5000
dubbo.reference.org.apache.dubbo.samples.api.DemoService.timeout=6000
```

**方法配置格式:**  
```properties
# 方法配置
dubbo.service.{interface-name}.{method-name}.{config-item}={config-item-value}
dubbo.reference.{interface-name}.{method-name}.{config-item}={config-item-value}

# 方法argument配置
dubbo.reference.{interface-name}.{method-name}.{argument-index}.{config-item}={config-item-value}

# 示例
dubbo.reference.org.apache.dubbo.samples.api.DemoService.sayHello.timeout=7000
dubbo.reference.org.apache.dubbo.samples.api.DemoService.sayHello.oninvoke=notifyService.onInvoke
dubbo.reference.org.apache.dubbo.samples.api.DemoService.sayHello.onreturn=notifyService.onReturn
dubbo.reference.org.apache.dubbo.samples.api.DemoService.sayHello.onthrow=notifyService.onThrow
dubbo.reference.org.apache.dubbo.samples.api.DemoService.sayHello.0.callback=true
```

**等价于的XML配置:**  
```xml
<dubbo:reference interface="org.apache.dubbo.samples.api.DemoService" >
    <dubbo:method name="sayHello" timeout="7000" oninvoke="notifyService.onInvoke"
                  onreturn="notifyService.onReturn" onthrow="notifyService.onThrow">
        <dubbo:argument index="0" callback="true" />
    </dubbo:method>
</dubbo:reference>
```

2.4 参数配置  
parameters参数为map对象,支持<font color="#00FF00">xxx.parameters=[{key:value},{key:value}]</font>方式进行配置  

2.5 传输层协议  
triple协议采用Http2做底层通信协议,使用者可以自定义如下这6个参数  
```properties
# 通知对端header压缩索引表的上限个数
dubbo.rpc.tri.header-table-size=4096

# 启用服务端推送功能
dubbo.rpc.tri.enable-push=false

# 通知对端允许的最大并发流数
dubbo.rpc.tri.max-concurrent-streams=2147483647

# 声明发送端的窗口大小
dubbo.rpc.tri.initial-window-size=1048576

# 设置帧的最大字节数
dubbo.rpc.tri.max-frame-size=32768

# 通知对端header未压缩的最大字节数
dubbo.rpc.tri.max-header-list-size=8192
```

**等价于yml配置**  
```yml
dubbo:
  rpc:
    tri:
      header-table-size: 4096
      enable-push: false
      max-concurrent-streams: 2147483647
      initial-window-size: 1048576
      max-frame-size: 32768
      max-header-list-size: 8192
```

2.6 属性与xml配置映射规则  
*提示:这里的属性就是dubbo的properties,讲的是dubbo.properties和xml配置之间如何转换的关系*  
可以将xml的tag名和属性组合起来,用`"."`分割
* `dubbo.application.name=foo`相当于`<dubbo:application name="foo" />`
* `dubbo.registry.address=10.20.153.10:9090`相当于`<dubbo:registry address="10.20.153.10:9090" />`
  
如果在xml配置中有超过一个tag,那么你可以使用`"id"`进行区分,如果你不指定id,它将作用于所有tag  
* `dubbo.protocols.rmi.port=1099`相当于`<dubbo:protocol id="rmi" name="rmi" port="1099" />`
* `dubbo.registries.china.address=10.20.153.10:9090`相当于`<dubbo:registry id="china" address="10.20.153.10:9090" />`

2.7 配置项单复数对照表  
*提示:详情参考官网配置,SDK用户手册->参考手册->配置说明->配置工作原理->配置项单复数对照表*  

3.配置来源  
*详情见:1.配置说明=>1.1 配置概述=>2.配置来源*  

4.配置加载流程  
4.1 处理流程  
![处理流程](resources/dubbo/38.png)  
* 第一阶段为DubboBootstrap初始化之前,在Spring context启动时解析<font color="#00FF00">处理XML配置/注解配置/Java-config或者是执行API配置代码</font>,创建config bean并且加入到ConfigManager中
* 第二阶段为DubboBootstrap初始化过程,从配置中心读取外部配置,依次处理实例级属性配置和应用级属性配置,最后刷新所有配置实例的属性,也就是<font color="#FF00FF">属性覆盖</font>

4.2 属性覆盖  
发生属性覆盖可能有两种情况,并且二者可能是会同时发生的:  
* 不同配置来源配置了相同的配置项
* 相同配置源,但在不同层次指定了相同的配置项

4.2.1 不同配置来源  
![不同配置来源](resources/dubbo/39.png)  
*提示:优先级按照图中所示,优先级从上至下依次变低*  

4.2.2 相同配置来源  
属性覆盖是指用配置的属性值覆盖config bean实例的属性,Dubbo的属性覆盖有多个匹配格式,优先级从高到低依次是  
```properties
#1.指定id的实例级配置
dubbo.{config-type}s.{config-id}.{config-item}={config-item-value}

#2.指定name的实例级配置
dubbo.{config-type}s.{config-name}.{config-item}={config-item-value}

#3.应用级配置（单数配置）
dubbo.{config-type}.{config-item}={config-item-value}
```

**属性覆盖处理流程:**  
按照优先级从高到低依次查找,如果找到此前缀开头的属性,则选定使用这个前缀提取属性.忽略后面的配置,<font color="#00FF00">优先级图示如下</font>  
![优先级](resources/dubbo/40.png)  


4.3 外部化配置  
外部化配置目的之一是实现配置的<font color="#00FF00">集中式管理</font>,可以使用业界成熟的配置管理系统nacos等,<font color="#00FF00">外部化配置和其他本地配置在内容和格式上并无区别</font>,<font color="#FF00FF">可以简单理解为dubbo.properties的外部化存储</font>,配置中心更适合将一些公共配置如注册中心、元数据中心配置等抽取以便做集中管理  
```properties
# 将注册中心地址、元数据中心地址等配置集中管理,可以做到统一环境、减少开发侧感知.
dubbo.registry.address=zookeeper://127.0.0.1:2181
dubbo.registry.simplified=true

dubbo.metadata-report.address=zookeeper://127.0.0.1:2181

dubbo.protocol.name=dubbo
dubbo.protocol.port=20880

dubbo.application.qos.port=33333
```

* 优先级外部化配置默认较本地配置有更高的优先级,因此这里配置的内容会覆盖本地配置值
* 作用域外部化配置有全局和应用两个级别,<font color="#00FF00">全局配置是所有应用共享的,应用级配置是由每个应用自己维护且只对自身可见的</font>

4.3.1 外部化配置使用方式  
4.3.1.1 增加`config-center`配置
```xml
<dubbo:config-center address="zookeeper://127.0.0.1:2181"/>
```
*提示:这段配置可以写入application.yml中,那么该application.yml本身也可以存放于配置中心中去,<font color="#00FF00">即先从配置中心获取dubbo的配置中心地址,在从dubbo的配置中心中获取dubbo的外部配置</font>*  

4.3.1.2 在相应的配置中新增加全局配置项,如下以Nacos为例  
![远程配置](resources/dubbo/41.png)  

开启外部化配置后,`registry、metadata-report、protocol、qos`等全局范围的配置理论上都不再需要在应用中配置,应用开发侧专注业务服务配置,<font color="#00FF00">一些全局共享的全局配置转而由运维人员统一配置在远端配置中心</font>

4.3.1.3 外部化配置的优势  
此时的应用只需要关心如下内容  
* 服务暴露、订阅配置
* 配置中心地址当部署到不同的环境时,其他配置就能自动的被从对应的配置中心读取到

举例来说,<font color="#00FF00">每个应用中Dubbo相关的配置只有以下内容可能就足够了,其余的都托管给相应环境下的配置中心</font>  
```yml
dubbo: 
  application: 
    name: demo
  config-center: 
    address: nacos://127.0.0.1:8848
```


4.3.2 自行加载外部化配置  
所谓Dubbo对配置中心的支持,本质上就是把`.properties`从远程拉取到本地,然后和本地的配置做一次融合.理论上只要Dubbo框架能拿到需要的配置就可以正常的启动,它并不关心这些配置是自己加载到的还是应用直接塞给它的,所以Dubbo还提供了以下API,让用户将自己组织好的配置塞给Dubbo框架(配置加载的过程是用户要完成的),这样 Dubbo 框架就不再直接和Apollo或Zookeeper做读取配置交互  
```java
// 应用自行加载配置
Map<String, String> dubboConfigurations = new HashMap<>();
dubboConfigurations.put("dubbo.registry.address", "zookeeper://127.0.0.1:2181");
dubboConfigurations.put("dubbo.registry.simplified", "true");

//将组织好的配置塞给Dubbo框架
ConfigCenterConfig configCenter = new ConfigCenterConfig();
configCenter.setExternalConfig(dubboConfigurations);
```


### 1.6 配置项手册  
*提示:参见官网->SDK用户手册->Java SDK->参考手册->配置说明->配置项手册*  


## 2.源码架构  
**目录:**  
2.1 代码架构  
2.2 服务调用  

### 2.1 代码架构
### 2.2 服务调用


## 3.QOS操作手册
**目录:**  
3.1 QOS概述  
3.2 基础命令手册  
3.3 服务管理命令  
3.4 框架状态命令  
3.5 日志框架运行时管理  
3.6 性能采样命令  
3.7 路由状态命令  
3.8 序列化安全审计  
3.9 默认监控指标命令  


### 3.1 QOS概述
1.参数说明  
QoS提供了一些启动参数,它们主要包括  
|                 参数                  |            说明            |  默认值   |
|:-------------------------------------:|:--------------------------:|:---------:|
|              qos-enable               |        是否启动QoS         |   true    |
|               qos-port                |     启动QoS绑定的端口      |   22222   |
|         qos-accept-foreign-ip         |      是否允许远程访问      |   false   |
|    qos-accept-foreign-ip-whitelist    | 支持的远端主机ip地址（段） |   (无)    |
| qos-anonymous-access-permission-level |  支持的匿名访问的权限级别  | PUBLIC(1) |


2.协议  
telnet模块现在同时支持http协议和telnet协议,方便各种情况的使用  
```shell
telnet localhost 22222
```

3.端口  
新版本的telnet端口与dubbo协议的端口是不同的端口,默认为22222,可以通过配置文件`dubbo.properties`修改:  
```properties
dubbo.application.qos-port=33333
```
也可以通过JVM参数设置  
```shell
-Ddubbo.application.qos-port=33333
```

4.安全  
默认情况下,dubbo接收任何主机发起的命令,可以通过配置文件`dubbo.properties`修改  
```properties
# 该配置拒绝远端主机发出的命令,只允许服务本机执行
dubbo.application.qos-accept-foreign-ip=false
```

可以通过设置`qos-accept-foreign-ip-whitelist`来指定支持的远端主机ip地址,多个ip地址之间用逗号分隔,`dubbo.properties`配置如下  
```properties
dubbo.application.qos-accept-foreign-ip-whitelist=123.12.10.13, 132.12.10.13/24
```

5.权限  
为了对<font color="#00FF00">生命周期探针</font>的默认支持,QoS提供了匿名访问的能力以及对权限级别的设置,目前支持的权限级别有  
* PUBLIC(1)
  默认支持匿名访问的命令权限级别,目前只支持生命周期探针相关的命令
* PROTECTED(2)
  命令默认的权限级别
* PRIVATE(3)
  保留的最高权限级别,目前未支持
* NONE(4)
  最低权限级别,即不支持匿名访问

权限级别<font color="#00FF00">PRIVATE>PROTECTED>PUBLIC>NONE</font>,高级别权限可访问同级别和低级别权限命令;当前以下命令权限为`PUBLIC`,其它命令默认权限别为PROTECTED  
|命令|权限等级|
|:-:|:-:|
|Live|PUBLIC (1)|
|Startup|PUBLIC (1)|
|Ready|PUBLIC (1)|
|Quit|PUBLIC (1)|

默认情况下(<font color="#00FF00">因为默认情况下dubbo接收任何主机发起的命令</font>),dubbo允许匿名主机发起匿名访问,<font color="#00FF00">但只有PUBLIC权限级别的命令可以执行</font>,其他更高权限的命令会被拒绝  

可以通过修改`dubbo.properties`配置文件内容如下,来<font color="#00FF00">修改匿名访问可以访问的最高权限命令</font>  
```properties
# 设置匿名主机可访问的最高权限命令为PROTECTED
dubbo.application.qos-anonymous-access-permission-level=PROTECTED
# 设置匿名主机可访问的最高权限命令为NONE,此时会关闭匿名访问
dubbo.application.qos-anonymous-access-permission-level=NONE
# 默认值
dubbo.application.qos-anonymous-access-permission-level=PUBLIC
```

6.配置优先级  
上述从协议到权限的配置(2-5)的配置加载优先级如下:<font color="#00FF00">系统属性>dubbo.properties>XML/Spring-boot自动装配</font>  



## 4.RPC协议
**目录:**  
4.1 协议概述  
4.2 Dubbo协议  
4.3 Triple协议  
4.4 Rest协议  
4.5 gRPC协议  
4.6 HTTP协议  
4.7 Rest协议  
4.8 Thrift协议  
4.9 Rmi协议  
4.10 Redis协议  
4.11 Hessian协议  
4.12 Webservice协议  
4.13 Memcached协议  


### 4.1 协议概述  
1.基本介绍  
Dubbo3提供了<font color="#00FF00">Triple(Dubbo3)、Dubbo2</font>协议,这是Dubbo框架的原生协议;除此之外,Dubbo3也对众多第三方协议进行了集成(<font color="#00FF00">这里说的都是RPC远程调用协议</font>),并将它们纳入Dubbo的编程与服务治理体系,包括<font color="#00FF00">gRPC、Thrift、JsonRPC、Hessian2、REST</font>等;以下重点介绍Triple与Dubbo2协议  

2.RPC协议  
协议是RPC的核心,它规范了数据在网络中的传输内容和格式;<font color="#00FF00">除必须的请求、响应数据外,通常还会包含额外控制数据,如单次请求的序列化方式、超时时间、压缩方式和鉴权信息等</font>  
RPC协议包含三部分:  
* `数据交换格式`:定义RPC的请求和响应对象在网络传输中的字节流内容,也叫作序列化方式(序列化协议)
  关于序列化协议可以参考dubboAdvance笔记->2.3.16 Kryo和FST序列化和2.3.2 服务端线程模型  
* `协议结构`:定义包含字段列表和各字段语义以及不同字段的排列方式
* 协议通过定义规则、格式和语义来约定数据如何在网络间传输,一次成功的RPC需要通信的双方都能够按<font color="#00FF00">照协议约定进行网络字节流的读写和对象转换</font>,否则两端使用的协议不一致就会造成鸡同鸭讲,无法进行远程通信

所以RPC协议的设计需要考虑以下内容:  
* 通用性:统一的二进制格式,跨语言、跨平台、多传输层协议支持
* 扩展性:协议增加字段、升级、支持用户扩展和附加业务元数据
* 高性能:尽可能快
* 穿透性:<font color="#00FF00">能够被各种终端设备识别和转发:网关、代理服务器等</font>

*提示:通用性和高性能通常无法同时达到,需要协议设计者进行一定的取舍*  

3.HTTP/1.1协议  
比于直接构建于TCP传输层的私有RPC协议,构建于HTTP之上的远程调用解决方案会有更好的通用性,如WebServices或REST架构,使用HTTP + JSON可以说是一个事实标准的解决方案;本点在凤凰架构中也有讲到为什么REST服务能够流行的原因  
选择构筑在HTTP协议之上会有如下优点:  
* HTTP的语义和可扩展性能很好的满足RPC调用需求
* 通用性,HTTP协议几乎被网络上的所有设备所支持,具有很好的协议穿透性

同时它也存在如下缺点:  
* 典型的Request–Response模型,<font color="#00FF00">一个链路上一次只能有一个等待的Request请求</font>;会产生HOL  
* Human Readable Headers,使用更通用、更易于人类阅读的头部传输格式,但是性能相当差  
* 无直接Server Push(服务端推送)支持,需要使用Polling Long-Polling(长轮询)等变通模式

4.gRPC协议  
相比于Dubbo构建于TCP传输层之上,<font color="#00FF00">Google选择将gRPC直接定义在HTTP/2协议之上</font>;gRPC的优势由HTTP2和Protobuf继承而来,如下  
* 基于HTTP2的协议足够简单,用户学习成本低,<font color="#00FF00">天然有server push/多路复用/流量控制能力</font>
* 基于Protobuf的多语言跨平台二进制兼容能力,提供强大的统一跨语言能力
* 基于协议本身的生态比较丰富,k8s/etcd等组件的天然支持协议,<font color="#FF00FF">云原生的事实协议标准</font>

但是也存在部分问题  
* 对服务治理的支持比较基础,<font color="#00FF00">更偏向于基础的RPC功能</font>,协议层缺少必要的统一定义,对于用户而言直接用起来并不容易
* <font color="#FF00FF">强绑定protobuf的序列化方式</font>,需要较高的学习成本和改造成本,对于现有的偏单语言的用户而言,迁移成本不可忽视  

*提示:关于protobuf序列化协议可以参考dubboTask->1.6 IDL开发服务的笔记*  

5.Triple协议  
最终Dubbo选择了兼容gRPC,<font color="#00FF00">以HTTP2作为传输层构建新的协议</font>,<font color="#FF00FF">也就是Triple基于HTTP2</font>,而Dubbo协议是基于TCP协议的  
容器化应用程序和微服务的兴起促进了针对负载内容优化技术的发展,客户端中使用的传统通信协议(<font color="#00FF00">RESTFUL或其他基于HTTP的自定义协议</font>)难以满足应用在性能、可维护性、扩展性、安全性等方便的需求.一个跨语言、模块化的协议会逐渐成为新的应用开发协议标准;<font color="#00FF00">自从2017年gRPC协议成为CNCF的项目后</font>,包括k8s、etcd等越来越多的基础设施和业务都开始使用gRPC的生态,作为云原生的微服务化框架,<font color="#00FF00">自从2017年gRPC协议成为CNCF的项目后</font>;并且,对于gRPC协议中一些不完善的部分,Triple也将进行增强和补充,例如:  
* 性能上:Triple协议采取了metadata和payload分离的策略,这样就可以避免中间设备,如网关进行payload的解析和反序列化,从而降低响应时间
* 路由支持上:由于metadata支持用户添加自定义header,用户可以根据header更方便的划分集群或者进行路由;这样发布的时候切流灰度或容灾都有了更高的灵活性
* 安全性上:支持双向TLS认证(mTLS)等加密传输能力
  *提示:这点可以参考dubboAdvance笔记=>2.4 提升安全性=>2.4.1 TLS支持*  
* 易用性上Triple除了支持原生gRPC所推荐的`Protobuf`序列化外,使用通用的方式支持了Hessian/JSON等其他序列化,能让用户更方便的升级到Triple协议
  * *提示:对原有的Dubbo服务而言,修改或增加Triple协议,只需要在声明服务的代码块添加一行协议配置即可,改造成本几乎为0*
  * *提示:其它的序列化协议支持可以参考dubboBasis笔记=>1.5 dubbo与gRPC、Spring Cloud、Istio的关系*
  * *提示:关于序列化协议可以参考dubboAdvance笔记->2.3.16 Kryo和FST序列化和2.3.2 服务端线程模型*

6.最终选择协议  
![最终选择的协议](resources/dubbo/42.png)  
**现状:**  
* 完整兼容grpc、客户端/服务端可以与原生grpc客户端打通
* 目前已经经过大规模生产实践验证,达到生产级别

**特点与优势:**  
* 具备跨语言互通的能力,传统的多语言多SDK模式和Mesh化(服务网格)跨语言模式都需要一种更通用易扩展的数据传输格式
* 提供更完善的请求模型,除了支持传统的Request/Response模型(Unary单向通信),还支持Stream(流式通信)和Bidirectional(双向通信)
* 易扩展、穿透性高,包括但不限于`Tracing/Monitoring`等支持(追踪和监控),也应该能被各层设备识别,网关设施等可以识别数据报文,对Service Mesh部署友好,降低用户理解难度
* 多种序列化方式支持、平滑升级
* 支持Java用户无感知升级,不需要定义繁琐的IDL文件,仅需要简单的修改协议名便可以轻松升级到Triple协议


7.Triple协议内容介绍  
* Service-Version => "tri-service-version" {Dubbo service version}
* Service-Group => "tri-service-group" {Dubbo service group}
* Tracing-ID => "tri-trace-traceid" {tracing id}
* Tracing-RPC-ID => "tri-trace-rpcid" {_span id _}
* Cluster-Info => "tri-unit-info" {cluster infomation}* 

8.Triple Streaming  
Triple协议相比传统的unary方式,多了目前提供的Streaming RPC的能力,Streaming适用于什么场景  
在一些大文件传输、直播等应用场景中,<font color="#00FF00">consumer或provider需要跟对端进行大量数据的传输,由于这些情况下的数据量是非常大的</font>,因此是没有办法可以在一个RPC的数据包中进行传输,<font color="#00FF00">因此对于这些数据包我们需要对数据包进行分片之后,通过多次RPC调用进行传输</font>,如果我们对这些已经拆分了的RPC数据包进行并行传输,那么到对端后相关的数据包是<font color="#FF00FF">无序的</font>,需要对接收到的数据进行排序拼接,相关的逻辑会非常复杂.但如果我们对拆分了的RPC数据包进行串行传输,那么对应的网络传输RTT与数据处理的时延会是非常大的  
为了解决以上的问题,<font color="#00FF00">并且为了大量数据的传输以流水线方式在consumer与provider之间传输,因此Streaming RPC的模型应运而生</font>

*提示:Streaming的相关知识详情见dubboAdvance=>2.6 Triple协议=>2.6.3 Streaming通信模式*  

通过Triple协议的Streaming RPC方式,会在consumer跟provider之间建立多条用户态的长连接,Stream;<font color="#00FF00">同一个TCP连接之上能同时存在多个Stream,其中每条Stream都有StreamId进行标识,对于一条Stream上的数据包会以顺序方式读写  </font>  

9.总结  
在API领域,最重要的趋势是标准化技术的崛起.Triple协议是Dubbo3推出的主力协议.它采用分层设计,其数据交换格式基于Protobuf(Protocol Buffers)协议开发,具备优秀的序列化/反序列化效率,当然还支持多种序列化方式,也支持众多开发语言.在传输层协议,Triple选择了HTTP/2,相较于 HTTP/1.1,其传输效率有了很大提升.此外HTTP/2作为一个成熟的开放标准,具备丰富的安全、流控等能力,同时拥有良好的互操作性.Triple不仅可以用于Server端服务调用,也可以支持浏览器、移动App和IoT设备与后端服务的交互,同时Triple协议无缝支持Dubbo3的全部服务治理能力.  
在Cloud Native的潮流下,跨平台、跨厂商、跨环境的系统间互操作性的需求必然会催生基于开放标准的RPC技术,而gRPC顺应了历史趋势,得到了越来越广泛地应用.在微服务领域,Triple协议的提出与落地,是Dubbo3迈向云原生微服务的一大步.  




## 5.配置中心  
**目录:**  
5.1 基本介绍  
5.2 Nacos  


### 5.1 基本介绍  
配置中心在dubbo中可承担两类职责:  
* 外部化配置:启动配置的集中式存储(简单理解为`dubbo.properties`的外部化存储)
  *提示:外部化配置详情见1.5 配置工作原理*
* 流量治理规则存储

值得注意的是Dubbo动态配置中心定义了两个不同层次的隔离选项,分别是namespace和group(就是nacos的层次)
* `namespace`:配置命名空间,默认值`dubbo`;命名空间通常用于多租户隔离,即对不同用户、不同环境或完全不关联的一系列配置进行逻辑隔离,<font color="#00FF00">区别于物理隔离的点是不同的命名空间使用的还是同一物理集群</font>
* `group`:配置分组,默认值`dubbo`;`group`通常用于归类一组相同类型/目的的配置项,是对namespace下配置项的进一步隔离

### 5.2 Nacos  
1.启动nacos配置中心  
```shell
# xml方式指定
<dubbo:config-center address="nacos://127.0.0.1:8848"/>
# yml方式指定
dubbo
  config-center
    address: nacos://127.0.0.1:8848
# properties方式指定
dubbo.config-center.address=nacos://127.0.0.1:8848
# Api方式指定
ConfigCenterConfig configCenter = new ConfigCenterConfig();
configCenter.setAddress("nacos://127.0.0.1:8848");
```

*提示:address的格式参考SDK用户手册=>Java SDK=>参考手册=>注册中心=>nacos*  

2.高级配置  
2.1 全局外部化配置  
2.1.1 应用开启`config-center`配置  
```yml
dubbo:
  config-center:
    address: nacos://127.0.0.1:2181
    config-file: dubbo.properties # optional
```

`config-file`全局外部化配置文件key值,默认`dubbo.properties`,`config-file`代表将Dubbo配置文件存储在远端注册中心时,文件在配置中心对应的key值,<font color="#00FF00">通常不建议修改此配置项</font>  
2.1.2  Nacos Server增加配置  
![增加配置](resources/dubbo/43.png)  
*注意:其中`dataId`是dubbo.properties,group分组设置为应用名即`demo-provider`*  

2.2 设置group与namespace  
```yml
dubbo:
  config-center:
    address: zookeeper://127.0.0.1:2181
    group: dubbo-cluster1
    namespace: dev1
```
对配置中心而言,`group`与`namespace`应该是全公司(集群)统一的,应该避免不同应用使用不同的值  

2.3 nacos扩展配置  
*提示:详情参考SDK用户手册=>Java SDK=>参考手册=>注册中心=>nacos*  

3.流量治理规则  
对Nacos而言,<font color="#00FF00">所有流量治理规则和外部化配置都应该是全局可见的</font>,因此相同逻辑集群内的应用都必须使用相同的`namespace`与`group`;其中,namespace的默认值是public,group默认值是dubbo,~~应用不得擅自修改namespace与group~~,除非能保持全局一致(实际上是可以修改的)  
流量治理规则的增删改<font color="#FF00FF">建议通过dubbo-admin完成</font>,更多内容可查看Dubbo支持的流量治理能力  
*提示:关于流量治理部分的内容可以参考dubboTask=>3.流量管理的内容*  
![流量治理](resources/dubbo/44.png)  


## 6.元数据中心
**目录:**  
6.1 元数据中心概述  


### 6.1 元数据中心概述  





