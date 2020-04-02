[TOC]

# 2020-04-01

#### microsoft 远程桌面frp-stcp无效，必须本地远程桌面，还需设置
```
Win10远程桌面 出现 身份验证错误，要求的函数不受支持，这可能是由于CredSSP加密Oracle修正 解决方法

https://www.cnblogs.com/raswin/p/9018388.html
```

#### CentOS7为docker-ce配置阿里云镜像加速器
```
https://www.cnblogs.com/geekdc/p/11173671.html
study-notes\阿里云docker镜像加速.txt
```

# 2020-04-02

#### linux 查看端口使用情况
```
lsof -i:7000
```

#### linux 后台启动frp服务
```
服务端： nohup ./frps -c frps.ini >/dev/null 2>&1 &
客户端： nohup ./frpc -c frpc.ini >/dev/null 2>&1 &
```

#### linux 停止frp
```
(1)ps -aux|grep frp| grep -v grep
	[1]12345
(2)lsof -i:7000
	[1]12345
kill -9 12345
```

#### docker 安装jenkins
```
(1) cd Documents/jenkins(安装在此目录下)
(2) docker pull jenkins:latest
(3) mkdir jenkins_home (为了方便安装插件，因此将jenkins_home目录映射出来)
	vim localtime
(4)sudo chown -R 1000:1000 $PWD/jenkins_home
(需要修改下目录权限, 因为当映射本地数据卷时，$PWD/jenkins_home目录的拥有者为root用户，而容器中jenkins user的uid为1000)
(5) docker run --name jenkins_container -d -p 8080:8080 -p 50000:50000 -v $PWD/jenkins_home:/var/jenkins_home -v $PWD/localtime:/etc/localtime jenkins
(6) docker ps -a (获取CONTAINER_ID)
	docker exec -u 0 -it CONTAINER_ID /bin/bash
	(-u 0 是使用root权限，如果不需要修改文件可以不使用此参数)
	cat /var/jenkins_home/secrets/initialAdminPassword(获取jenkins密码)
	(我的pro-jenkins
	username: admin
	password: ffc68d37caa046d1b605a3d2695008e7)
```

#### docker 安装脚本(未测试)
```
study-notes\docker-install.sh
```

#### linux 安装 maven
```
cd /home/songning/Documents
mkdir maven
cd /maven
wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
tar -zxvf  apache-maven-3.1.1-bin.tar.gz
mv apache-maven-3.1.1 apachemaven
vi /etc/profile (配置环境变量)
	export M2_HOME=/home/songning/Documents/maven/apachemaven
	export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
source /etc/profile (保存退出后运行下面的命令使配置生效，或者重启服务器生效)
mvn -v (source /etc/profile)
```

####  linux 安装java
```
yum install java
cd /usr/lib/jvm (通过yum安装的默认路径)
vim /etc/profile (将jdk的安装路径加入到JAVA_HOME)
	#set java environment
	JAVA_HOME=/usr/lib/jvm/jre-1.6.0-openjdk.x86_64(实际安装版本)
	PATH=$PATH:$JAVA_HOME/bin
	CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
	export JAVA_HOME CLASSPATH PATH
. /etc/profile
```

#### window关闭资源管理器黑屏
```
ctrl+alt+delete
任务管理器 新建任务
explorer.exe
```
