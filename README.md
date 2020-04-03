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

#### window关闭资源管理器黑屏
```
ctrl+alt+delete
任务管理器 新建任务
explorer.exe
```

# 2020-04-03

#### 安装maven时修改maven settings.xml
```
安装maven时，修改settings.xml文件(Documents/maven/apachemaven/conf)
在<mirrors>中添加 
	<mirror>
		<id>alimaven</id>
		<mirrorOf>central</mirrorOf>
		<name>aliyun maven</name>
		<url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
	</mirror> 
否则 bug: 
[ERROR] Plugin org.springframework.boot:spring-boot-maven-plugin:2.2.5.RELEASE or one of its dependencies could not be resolved: Failed to read artifact descriptor for org.springframewo
rk.boot:spring-boot-maven-plugin:jar:2.2.5.RELEASE: Could not transfer artifact org.springframework.boot:spring-boot-maven-plugin:pom:2.2.5.RELEASE from/to central (https://repo.maven.a
pache.org/maven2): Connect to repo.maven.apache.org:443 [repo.maven.apache.org/151.101.24.215] failed: Connection timed out: connect -> [Help 1]

yum install java-devel
否则 bug:
No compiler is provided in this environment. Perhaps you are running on a JRE rather than a JDK?
```

#### docker部署cykb-server
```
* linux安装git,maven,java
* cd /home/songning/Documents/cykb
* git clone git@github.com:songning123456/cykb-server.git
	(https://github.com/songning123456/cykb-server.git)
* cd cykb-server/
* mvn clean install -DskipTests
* cp ./target/cykb-1.0.0-SNAPSHOT.jar ../
* cd ..
* rm -rf cykb-server
* vim Dockerfile
	FROM java:8
	EXPOSE 8012
	COPY cykb-1.0.0-SNAPSHOT.jar /cykb/cykb-server.jar
	CMD ["java", "-jar", "/cykb/cykb-server.jar"]
	RUN echo "Asia/Shanghai" > /etc/timezone
	ENV LANG C.UTF-8
* docker build -t cykb_image -f Dockerfile .
* docker run --net=host --name cykb_container -d cykb_image
  (最后一步被坑，不需要bridge模式，host模式直接用宿主机端口)
```

#### centos7 防火墙
```
* 操作防火墙要重启docker
	service docker restart
* 基本命令
	firewall-cmd --state (检查防火墙的状态)
	systemctl stop firewalld.service (停止firewall)
	systemctl disable firewalld.service (禁止firewall开机启动)
	systemctl start firewalld.service (启动)
```