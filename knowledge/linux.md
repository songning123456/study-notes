[TOC]

#### VMware安装CentOS7
```
https://blog.csdn.net/tsundere_x/article/details/104263100
https://blog.csdn.net/babyxue/article/details/80970526
```


#### linux命令行添加图形化界面
```
yum update grub2-common               
yum install fwupdate-efi
yum groupinstall "GNOME Desktop" "Graphical Administration Tools"   // 安装这个包即可，前面两个是依赖包
systemctl set-default graphical.target  // 设置图形化界面启动，可以不要。用init 5切换过去也可
```


#### CentOS7为docker-ce配置阿里云镜像加速器
```
https://www.cnblogs.com/geekdc/p/11173671.html
study-notes\阿里云docker镜像加速.txt
```

#### linux查看端口使用情况
```
lsof -i:7000
```

#### linux安装java
```
* 参考: https://blog.csdn.net/woshimeihuo/article/details/90608081
* yum search java|grep jdk (使用yum查找jdk)
* yum install java-1.8.0-openjdk
* yum install java-1.8.0-openjdk-devel.x86_64(安装开发环境)
* cd /usr/lib/jvm (通过yum安装的默认路径)
* vim /etc/profile (将jdk的安装路径加入到JAVA_HOME)
    #set java environment
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64 // java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64 修改为实际安装版本
    JRE_HOME=$JAVA_HOME/jre
    CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib 
    PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
    export JAVA_HOME JRE_HOME CLASS_PATH PATH

* source /etc/profile (刷新)
```

#### centos7防火墙
```
* 基本命令
	firewall-cmd --state (检查防火墙的状态)
	systemctl stop firewalld.service (停止firewall)
	systemctl disable firewalld.service (禁止firewall开机启动)
	systemctl start firewalld.service (启动)
	systemctl restart firewalld.service (重启)
	firewall-cmd --zone=public --add-port=5672/tcp --permanent(开放)
	firewall-cmd --zone=public --remove-port=5672/tcp --permanent(关闭)
	firewall-cmd --reload (配置立即生效)
    firewall-cmd --list-ports (查看已经开放的端口)
```

#### linux查看某个端口是否被占用
```
* netstat -ano | findstr "8080"
```


#### linux固定ip
```
参考 https://blog.csdn.net/qq_38138069/article/details/80982527

* vim /etc/sysconfig/network-scripts/ifcfg-ens33

    TYPE="Ethernet"
    PROXY_METHOD="none"
    BROWSER_ONLY="no"
    BOOTPROTO="static" (dhcp 改为 static)
    DEFROUTE="yes"
    IPV4_FAILURE_FATAL="no"
    IPV6INIT="yes"
    IPV6_AUTOCONF="yes"
    IPV6_DEFROUTE="yes"
    IPV6_FAILURE_FATAL="no"
    IPV6_ADDR_GEN_MODE="stable-privacy"
    NAME="ens33"
    UUID="faf68ce4-4ed9-4991-9475-7874b8fde25f"
    DEVICE="ens33"
    ONBOOT="yes"
    IPADDR="192.168.xxx(与宿主机相同).yyy" (填写需要的静态ip)
    GATEWAY="192.168.0.1" (宿主机网关)
    NETMASK="255.255.255.0" (宿主机子网掩码)
    DNS1=114.114.114.114
    DNS2=8.8.8.8

注意: =两侧一定不能有空格，不能留空白行

* reboot || service network restart
```

#### windows上传文件到linux需转换为unix格式
```
yum install dos2unix (如果已经安装，则略过此步骤)
dos2unix xxx.sh (xxx.sh是你需要转换的文件)
```

#### linux安装git
```
yum -y install git
git --version
```

#### linux模糊删除文件
```
find / -name "test*" |xargs rm -rf 
```


#### centos7如何安装sshpass
```
yum install -y epel-release
yum repolist
yum install -y sshpass
sshpass –V
```


#### 服务器A远程访问服务器B
<https://blog.csdn.net/sn3009/article/details/52779642>

```
服务器A => 192.168.0.10
服务器B => 192.168.0.11

服务器A xshell终端
    ssh 用户名@192.168.0.11 << remotessh
    > ...   // 具体操作
    > ...   // 具体操作
    > ...   // 具体操作
    > exit
    > remotessh


Q: Pseudo-terminal will not be allocated because stdin is not a terminal
A: ssh -tt 用户名@192.168.0.11 << remotessh
```

```
// 后续需要在机器上离线安装sshpass
// 目前在本机test环境下测试的
sshpass -p rediscloud ssh -tt rediscloud@10.5.181.32 << remotessh
> cd /home/rediscloud/deploy
> mkdir test
> exit
> remotessh     // 只有执行完这一步，10.5.181.32环境才会生成test文件夹
```

#### linux解压xxx.tar.gz
tar -zxvf filename.tar.gz 解压到当前文件夹 
tar -zxvf java.tar.gz  -C /usr/dir 解压到指定文件夹
