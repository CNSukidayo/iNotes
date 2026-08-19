# 目录  
1.基本介绍  
2.使用优化  



## 1.基本介绍  
**目录**  
1.1 下载KUbuntu  
1.2 下载Rufus  
1.3 进入KUbuntu  
1.4 安装KUbuntu  
1.5 安装问题总结  


### 1.1 下载KUbuntu  
1.进入[KUbuntu官网](https://kubuntu.org/)下载最新版本的LTS  

### 1.2 下载Rufus  
1.准备好U盘  

2.进入[Rufus官网](https://rufus.ie/zh/)下载  

3.设置  
打开软件下拉设备选项框选择U盘,在引导类型选择中选择下载的镜像,格式化选项下的选项保持默认  
点击开始->选择OK  


### 1.3 进入KUbuntu  
1.方式一  
不要取下U盘,如果当前是Windows正在运行,则按下shift->重启  
此时Windows会重启到Windows RE->点击使用设备->选择连接的U盘  

2.方式二  
开机进入BIOS选择U盘启动  

### 1.4 安装KUbuntu  
1.进入安装界面后  
选择try or install KUbuntu->这里还要按一下回车  
选择Language为中文->connection要选择disconnection(因为国内下载慢)->install KUbuntu 

2.进入初始化界面  
位置选择中国->上海;确保系统语言为中文;时区为中国  
键盘布局选Chinese->默认  
Customize选择最小化安装(不要选normal模式)  
分区选择抹除磁盘  
用户设置昵称和登陆用户名(建议全小写)并修改计算机名称,不要勾选"不询问密码自动登录"  

### 1.5 问题总结  
1.Select boot image did not authenticate  
进入BIOS设置->在顶部扎到Security或Boot选项卡->Secure Boot->将Enabled(启用)改为Disabled(不使用)->F10保存  





## 2.使用优化  
**目录**  
2.1 软件安装  
2.2 显卡驱动安装  
2.3 输入法安装  
2.4 设置交换分区  
2.5 修改hosts  
2.6 保险库  
2.7 卸载snap  

### 2.1 软件安装  
**目录:**  
2.1 更新软件  
2.2 Linux软件安装  
2.3 用户专属快捷方式  


#### 2.1 更新软件
1.更新可用软件包列表  
`sudo apt update`更新列表(更新菜单)  

2.更新软件  
`sudo apt upgrade`更新软件  

3.已安装的软件列表  
`apt list --installed 2>/dev/null`  
*解释:2是Linux的标准错误输出,将程序的错误信息输出到/dev/null这个文件中,而/dev/null这个文件是一个垃圾桶,意思就是丢掉这个错误输出,这个命令是高频命令,这样使用的话可以将命令产生的warning信息丢掉,保持输出干净*  

#### 2.2 Linux软件安装  
1.deb软件包安装在哪里  
Linux安装软件和Windows的设计不同,Windows一般会把软件的所有内容安装到一个文件夹剩下,而Linux会分类管理,deb包会把不同的文件放进系统的各个文件夹下  
* 可执行二进制文件通常放在`/usr/bin/`或`/opt`下,很多第三方的闭源软件或大型软件喜欢整个安装在opt目录下  
* 图标文件通常安装在`/usr/share/icons/`  
* 启动快捷方式`/usr/share/applications/`(这是你能从菜单找到它的核心)
* 用户配置文件`~/.config/clash-verge/`(假设这里安装clash-verge)
* 全局配置文件`/etc`所有的系统设置都在这,没有注册表,全是文本

#### 2.3 用户专属快捷方式  
1.在Linux中用户在菜单里看到的每一个软件图标,其实质都对应一个.desktop文件  

2.全局级别`/usr/share/applications/`  

3.用户级别`~/.local/share/applications/`

4.这两个文件夹就有点类似Windows的star menu菜单;一个是系统级的一个是用户级的  



### 2.2 显卡驱动安装

### 2.3 输入法安装  
1.安装软件
sudo apt install --install-suggests fcitx5 fcitx5-chinese-addons  

2.进入系统设置->键盘->虚拟键盘->选择Fcitx 5 Wayland启动器->应用  

3.进入系统设置->输入法->底部配置附加组件->点击经典用户界面右侧的配置图标->将主题和深色主题都设置为KDE Plasma(实验性)->应用设置  

4.终端执行im-config 前两个窗口都是确定->do not activate any Im-config and use desktop default

5.进入系统设置->输入法->配置全局选项->输入法设置
6.进入系统设置->输入法->配置附加组件->找到拼音->点击右侧的配置图标->输入法设置
7.设置快速输入(也就是按下分号`;`后的功能)
8.为了能够让fcitx5在WPS中输入中文,需要执行以下步骤  
```shell
# 1.安装Fcitx5的Qt模块
sudo apt update
sudo apt install fcitx5-frontend-qt5 libfcitx5qt5widgets1
# 2.检查环境变量设置
sudo vim /etc/environment
# 添加如下内容
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
```


### 2.4 设置交换分区  
1.查看是否已经存在交换分区  
`swapon --show`  

2.关闭交换分区  
`sudo swapoff /swapfile`  

3.重新分配空间  
`sudo fallocate -l 8G /swapfile`  

4.重新建立交换格式  
`sudo mkswap /swapfile`  

5.重新启用  
`sudo swapon /swapfile`  

6.调整Swappiness  
首先需要自已先创建一个配置文件,先执行`/etc/sysctl.d`进入到该目录下,然后执行`sudo vim 99-custom.conf`这个配置文件的名称的自定义的,99代表了该配置文件的优先级,custom是自定义的名称  
然后在该配置文件中填入`vm.swappiness=10`  
*解释:* swappiness的值默认是60,可以通过`cat /proc/sys/vm/swappiness`命令来查看,该值决定了内核使用Swap的"积极程度",取值范围0-100,调整为10的目的是让系统优先使用物理内存  
立即应用配置`sudo sysctl --system`  


### 2.6 保险库  
1.保险库介绍  
就是放加密数据的地方,这里面有两个关键的信息,加密数据位置和挂载点  

2.加密数据位置  
这个位置是真正存储数据的地方,无论保险库是否开启该文件夹始终存在,如果直接打开该文件夹显示的随机字符无法读取,默认路径通常位于`~/.local/share/plasma-vault/保险库名称.enc`  

3.挂载点  
它是一个虚拟的路径,只有当开启保险库并正确输入密码之后,系统才会把加密的数据翻译成明文,并映射到该文件夹下,此时可以像使用正常的文件夹一样,在该文件夹下进行操作,默认路径通常位于`~/Vaults/保险库名称`  


### 2.7 卸载snap  
详情访问项目:[nosnap](https://gitee.com/vincent-zyu/nosnap/tree/main)  









