# 目录
1.基本环境搭建  
2.docker基本知识介绍  
  
**附录:**  
A.docker命令大全  
B.常用docker镜像大全  


## 1. 基本环境搭建  
**目录:**  
1.1 安装docker  
1.2 安装JDK  

### 1.1 安装docker  
1.卸载系统之前的 docker
```shell
sudo yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine
```

2.安装Docker-CE
```shell
sudo yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
```

3.设置docker-repo的yum位置
```shell
sudo yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo
```

4.安装docker
```shell
sudo yum install docker-ce docker-ce-cli containerd.io
```

5.启动docker
```shell
sudo systemctl start docker
```

6.开机自启docker
```shell
sudo systemctl enable docker
```

7.配置阿里云镜像 **一共四条命令**  
```shell
sudo mkdir -p /etc/docker
```
```shell
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://82m9ar63.mirror.aliyuncs.com"]
}
EOF
```
```shell
sudo systemctl daemon-reload
```
```shell
sudo systemctl restart docker
```

### 1.2 安装JDK  
**详情可以看附录B的安装及各种参数解释**    

1.docker仓库[https://hub.docker.com/search?q=](https://hub.docker.com/search?q=)  

2.拉取JDK17镜像  
```shell
docker pull openjdk:17
```

3.查看所有镜像  
```shell
docker images
```
![docker-images](resources/docker/1.png)  

4.启动容器  
```shell
docker run --name openjdk17 \
-v /jdk/bin:
-d openjdk:17
```

5.进入容器  
```shell
docker exec -it bf80164 /bin/bash
```
bf80164是容器的id(不是镜像的id);后面的bin/bash是必须的  

6.将

## 2.docker基本知识介绍
**目录**:  
1.容器应该是解决某个问题的功能单元，让容器保持单一用途才是正确的方式.如果一个容器中包含多个功能模块,则这个容器是不对的



## 附录:  
A. docker命令大全  
B. 常用docker镜像大全  

### A. docker命令大全  
1.[docker命令官方网站](//todo)  

* `docker pull [image-name]:[version]` 拉取镜像  
  解释:image-name是镜像名称;version是镜像版本  
* `docker images` 查看所有镜像  
* `docker ps -a` 查询运行的所有镜像  
  解释:-a 代表所有的镜像(包括没有正在运行的镜像)
* `docker exec -it [image-id] ` 进行一个镜像  
  解释:image-id是容器的id(不是镜像的id;是docker ps结果的CONTAINER ID字段)  
* `docker exec -it [containerId] /bin/bash` 进入一个容器  
* `docker rm [containerId]` 删除一个容器(是容器不是镜像)  
* `docker rmi [imageName]/[imageId]` 删除一个镜像  
* `docker rmi -f [imageName]/[imageId]` 强制删除一个镜像,推荐不使用-f参数,如果用上面没有-f删除docker镜像时出现问题(可能是当前要删除的镜像依赖某个容器,可以使用上面的docker rm [containerId]删除该容器后重试)
* `docker run ...` 运行一个镜像(注意和start区分)  
* `docker stop [containerId]` 停止一个容器  
* `docker start [containerId]` 启动一个容器  
* `docker restart [containerId]` 重启一个容器  
* `docker container update --mount type=bind,source=[hostPath],target=[containerPath] [containerId]` 挂载已经启动的容器目录(需要先将容器stop);source是宿主机的路径,target是容器内的路径.
* `docker cp [hostPath] [containerId]:[containerPath]` 将宿主机的文件拷贝到容器中  
* `docker cp [containerId]:[containerPath] [hostPath]` 将容器中的内容拷贝到宿主机
* `docker network ls` 查看docker所有的网络
* `docker network rm [netWorkId]` 根据network的ID移除一个docker网络
* `docker network create [netWordName]` 创建一个docker网络,网络名称为[netWordName];docker网络在搭建nacos集群的时候会用到

### B. 常用docker镜像大全  
**目录:**  
1.MySQL  
2.Redis  
3.Nacos  
4.RabbitMQ  
5.ElasticSearch  


#### 1.MySQL安装  
1.下载镜像  
`docker pull mysql:8.0.30`  

2.创建实例并启动  
```shell
docker run -p 7901:3306 --name mysql8.0 \
-v ~/software/mysql8.0/log:/var/log/mysql \
-v ~/software/mysql8.0/data:/var/lib/mysql \
-v ~/software/mysql8.0/conf:/etc/mysql/conf.d:rw \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:8.0.30
```

参数解释:  
* -v [hostPath]:[containerPaht]  挂载容器文件路径到本机;将containerPaht(容器)路径的文件挂载到(hostPath)  
* -e MYSQL_ROOT_PASSWORD=[password] -e参数的本质是启动容器时给容器设置参数,这里的参数意思是设置MySQL root用户的密码为root(看上面的例子)  
* --name 给当前容器其名  
* -p [hostPort]:[containerPort] 将容器的容器的端口(containerPort)映射到宿主机的端口(hostPort).  
* -d [repository]:[version] 启动的目标镜像坐标,通过docker images 命令可以查看到所有的镜像,目标镜像有仓库+version来决定  

3.进入到容器中修改密码  
`ALTER USER 'root'@'%' IDENTIFIED BY '这里是你要设置的密码';`

`flush privileges;` 刷新权限  

4.注意可能需要删除用户  


#### 2.Redis  
1.下载镜像  
`docker pull redis:7.0`  

2.先创建配置文件  
**解释:** 这有个小坑,在docker挂载的时候有可能将最后一个文件识别成目录,所有这里要先创建Redis配置文件的.  
`mkdir -p ~/software/redis/conf`  创建配置文件目录  
`touch ~/software/redis/conf/redis.conf` 创建Redis配置文件  
*提示:这个配置文件来源于Redis的官方github*  
**[redis.conf](resources/redis/redis.conf)**  
**注意:** 这个配置就是看一下,不要上传到Linux服务器上,有什么需要改的配置直接在刚才touch创建的配置文件中修改.  

3.创建容器并启动
```shell
docker run -p 7902:6379 --name redis \
-v ~/software/redis/data:/data \
-v ~/software/redis/conf/redis.conf:/etc/redis/redis.conf \
-d redis:7.0 redis-server /etc/redis/redis.conf
```

**解释:** 后面的/etc/redis/redis.conf是容器里面的配置文件,意思是启动redis的时候携带的配置文件  

4.设置Redis密码  
`vim ~/software/redis/conf/redis.conf` 编辑Redis配置文件,设置Redis密码  
`requirepass [password]` 在配置文件中设置Redis密码  
`redis-cli -a [password] --raw -h [host] -p [port]` 使用密码连接Redis客户局
* `-a [password]` 设置密码启动客户端
* `--raw` 解决中文乱码问题  
* `-h [host]`(非必填):连接的目标RedisIP  
* `-p [port]`(非必填):连接的目标Redis的port

**Redis详细配置见:Redis=>B.Redis命令大全=>5.redis.conf**  

5.Redis默认安装路径 /usr/local/bin(可以进入容器中访问)  

6.Redis中sentinel.conf配置文件  
该配置文件存放的路径应该与redis.conf配置文件中设置的`dir`路径的目录一致;sentinel.conf是Redis负载均衡的配置.  
如果redis.conf没有指定dir,则将sentinel.conf配置文件放到与redis.conf配置文件相同的目录下.  

7.启动sentinel  
sentinel的启动和Redis服务的启动是完全不一样的,虽然可以使用同一个镜像来完成  
```shell
docker run -p 7903:26379 --name redis-sentinel \
-v ~/software/redis/data:/data \
-v ~/software/redis/conf/sentinel.conf:/etc/redis/sentinel.conf \
-e --sentinel \
-d redis:7.0 redis-sentinel /etc/redis/sentinel.conf
```
**解释:**  
* -e --sentinel 启动sentinel时需要带上的参数

8.启动集群  
```shell
docker run -p 7903:26379 --name redis-sentinel \
-v ~/software/redis/data:/data \
-v ~/software/redis/conf/sentinel.conf:/etc/redis/sentinel.conf \
-e -c \
-d redis:7.0 redis-sentinel /etc/redis/sentinel.conf
```

**解释:**  
* -e -c 代表启动的有路由(这是集群中的概念,详情见Redis.md=>基础篇=>8.Redis集群=>8.3 三主三从集群环境=>8.3.3 主从容错切换迁移案例)

#### 3.Nacos
1.下载镜像  
`docker pull nacos/nacos-server:v2.2.0`  

2.启动容器  
```shell
docker run \
-p 8848:8848 \
-p 9848:9848 \
-p 9849:9849 \
--name nacos2 \
--env MODE=standalone \
--env NACOS_AUTH_ENABLE=true \
--env NACOS_AUTH_TOKEN_EXPIRE_SECONDS=18000 \
--env NACOS_AUTH_TOKEN=VGhpc0lzTXlDdXN0b21TZWNyZXRLZXkwMTIzNDU2Nzg= \
-e JVM_XMS=256m \
-e JVM_XMX=256m \
-d nacos/nacos-server:v2.2.0
```
**解释:**  
* --env NACOS_AUTH_ENABLE=true 代表开启新版本nacos的鉴权  
* --restart=always 重启  
* --env MODE=standalone 启动模式为单击启动  
* --env NACOS_AUTH_TOKEN_EXPIRE_SECONDS=18000 token默认的时效时间  
* nacos2.0之后还需要加上9848、9849端口

3.挂载目录(先启动再挂载)  
**这个第三点是无效的,不用看了,所以nacos就不指定挂载就行了**  
这里逻辑会非常混乱,可以看帖子:[https://www.yii666.com/blog/511435.html](https://www.yii666.com/blog/511435.html)  

**环境:**  
我这里启动了两个nacos;一个是没有挂载目录的;一个是正常挂载目录的.  
挂载目录实际上是由两个文件来共同决定的:hostconfig.json和config.v2.json  

没有挂载的hostconfig.json文件:
```json
{
  "Binds": null,
  "ContainerIDFile": "",
  "...":"..." // 后面的内容省略了
}
```

有挂载的hostconfig.json文件:
```json
{
	"Binds": ["/root/software/nacos/conf:/home/nacos/conf", "/root/software/nacos/data:/home/nacos/data", "/root/software/nacos/logs:/home/nacos/logs"],
	"ContainerIDFile": "",
  "...":"..."
}
```
着重看Binds属性,可以看到和挂载一样,冒汗前面指定的是宿主机路径,冒号后面指定的是容器内路径.  

没有挂载的config.v2.json:
```json
{
  "MountPoints":{}
}
```

有挂载的config.v2.json(省略部分不重要内容):  
```json
{
  	"MountPoints": {
		"/home/nacos/conf": {
			"Source": "/root/software/nacos/conf",
			"Destination": "/home/nacos/conf",
			"RW": true,
			"Name": "",
			"Driver": "",
			"Type": "bind",
			"Propagation": "rprivate",
			"Spec": {
				"Type": "bind",
				"Source": "/root/software/nacos/conf",
				"Target": "/home/nacos/conf"
			},
			"SkipMountpointCreation": false
		},
		"/home/nacos/data": {
			"Source": "/root/software/nacos/data",
			"Destination": "/home/nacos/data",
			"RW": true,
			"Name": "",
			"Driver": "",
			"Type": "bind",
			"Propagation": "rprivate",
			"Spec": {
				"Type": "bind",
				"Source": "/root/software/nacos/data",
				"Target": "/home/nacos/data"
			},
			"SkipMountpointCreation": false
		},
		"/home/nacos/logs": {
			"Source": "/root/software/nacos/logs",
			"Destination": "/home/nacos/logs",
			"RW": true,
			"Name": "",
			"Driver": "",
			"Type": "bind",
			"Propagation": "rprivate",
			"Spec": {
				"Type": "bind",
				"Source": "/root/software/nacos/logs",
				"Target": "/home/nacos/logs"
			},
			"SkipMountpointCreation": false
		}
	}
}
```

那实际上我们就把有挂载的容器的配置复制到给没有挂载的容器配置上即可.  

#### 4.RabbitMQ  
1.拉取镜像  
`docker pull rabbitmq:3.12.4-management`  

2.启动容器  
```shell
docker run --name rabbitmq \
-p 5671:5671 \
-p 5672:5672 \
-p 4369:4369 \
-p 25672:25672 \
-p 15671:15671 \
-p 15672:15672 \
-d rabbitmq:management
```
**解释:**  
* 4369:Erlang发现端口(必须指定)  
* 15672:Web前端管理端口(可以不指定,推荐指定)  
* 25672:集群端口(暂不指定)  
* 5672;5671:AMQP端口(暂不指定)
* 61613;61614:STOMP协议端口(暂不指定)  
* 1883;8883:MQTT协议端口(暂不指定)  

**可以这么指定:**
```shell
docker run --name rabbitmq \
--restart=always \
-p 7903:4396 \
-p 7904:15672 \
-d rabbitmq:3.12.4-management
```

3.进入容器修改密码  
`docker exec -it [containerId] /bin/bash`

运行`rabbitmqctl  list_users` 查看当前所有用户  
![rabbitMQ](resources/docker/2.png)  

运行`rabbitmqctl change_password [Username] [Newpassword]` 修改密码  


#### 5.ElasticSearch  
1.拉取镜像  
`docker pull elasticsearch:8.5.2`

2.在宿主机创建两个文件目录  
`mkdir -p ~/software/elasticsearch/plugins`  
`mkdir -p ~/software/elasticsearch/data`

3.运行容器  
```shell
docker run --name elasticsearch \
-p 9200:9200 \
-p 9300:9300 \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
-e xpack.security.enabled=false \
-v ~/software/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
-d elasticsearch:8.5.2
```

**解释:**
* 9200端口:HTTP协议(RESTful风格的接口)  
* 9300端口:TCP协议(主要是开放给java服务调用以及ES集群之间使用,微服务yml配置文件中配置该端口)  

4.停止容器  
`docker stop [containerId]`  

5.安装分词器插件  
分词器的下载见尚上优选  
将下载的分词器解压到~/elasticsearch/plugins 文件夹下(因为设置了挂载)  

`unzip -o -d [targetPath] [zipPath]`  解压zip到目标目录 -o 覆盖模式 -d 制定解压到的路径为(targetPath)  

当然可以先创建一个目录用于备份下载的分词插件压缩包,因为plugins目录下是不允许有压缩包的(只能有插件)  

6.进入容器
ElasticSearch8之后默认有权限验证,来到config/elasticsearch.yml配置文件,先备份该文件查看该文件内容:  
```yml
cluster.name: "docker-cluster"
network.host: 0.0.0.0

#----------------------- BEGIN SECURITY AUTO CONFIGURATION -----------------------
#
# The following settings, TLS certificates, and keys have been automatically
# generated to configure Elasticsearch security features on 16-09-2023 11:19:38
#
# --------------------------------------------------------------------------------

# Enable security features
xpack.security.enabled: true

xpack.security.enrollment.enabled: true

# Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
xpack.security.http.ssl:
  enabled: true
  keystore.path: certs/http.p12

# Enable encryption and mutual authentication between cluster nodes
xpack.security.transport.ssl:
  enabled: true
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
#----------------------- END SECURITY AUTO CONFIGURATION -------------------------
```  

由于不好在容器内进行编辑,故先退出容器 来到容器外部  
在~/software/elasticsearch/config目录下创建elasticsearch.yml配置文件  
将配置改为以下内容:  
```yml
cluster.name: "docker-cluster"
network.host: 0.0.0.0

#----------------------- BEGIN SECURITY AUTO CONFIGURATION -----------------------
#
# The following settings, TLS certificates, and keys have been automatically
# generated to configure Elasticsearch security features on 16-09-2023 11:19:38
#
# --------------------------------------------------------------------------------

# Enable security features 是否开启权限校验
xpack.security.enabled: false

xpack.security.enrollment.enabled: false

# Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
xpack.security.http.ssl:
  enabled: false
  keystore.path: certs/http.p12

# Enable encryption and mutual authentication between cluster nodes 是否开启https
xpack.security.transport.ssl:
  enabled: false
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
#----------------------- END SECURITY AUTO CONFIGURATION -------------------------
```
执行命令拷贝文件:  
`docker cp ./elasticsearch.yml [containerId]:/usr/share/elasticsearch/config `

7.重启容器
`docker start [containerId]`

