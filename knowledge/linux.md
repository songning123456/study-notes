[TOC]

#### CentOS7为docker-ce配置阿里云镜像加速器
```
https://www.cnblogs.com/geekdc/p/11173671.html
study-notes\阿里云docker镜像加速.txt
```

#### linux 查看端口使用情况
```
lsof -i:7000
```

####  linux 安装java
```
* 参考:https://blog.csdn.net/woshimeihuo/article/details/90608081?depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1&utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1
* yum search java|grep jdk (使用yum查找jdk)
* yum install java-1.8.0-openjdk
* yum install java-1.8.0-openjdk-devel.x86_64(安装开发环境)
* cd /usr/lib/jvm (通过yum安装的默认路径)
* vim /etc/profile (将jdk的安装路径加入到JAVA_HOME)
	#set java environment
	JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.242.b08-        			0.el8_1.x86_64 (实际安装版本)   
	JRE_HOME=$JAVA_HOME/jre
	CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:
		$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib 
	PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
	export JAVA_HOME JRE_HOME CLASS_PATH PATH
* . /etc/profile (刷新)
```

#### centos7 防火墙
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


#### linux 固定ip
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
    
    # =两侧一定不能有空格，此处被坑
    IPADDR="192.168.0.110" (填写需要的静态ip)
    GATEWAY="192.168.0.1" (宿主机网关)
    NETMASK="255.255.255.0" (宿主机子网掩码)
    DNS1=114.114.114.114
    DNS2=8.8.8.8

* reboot
```