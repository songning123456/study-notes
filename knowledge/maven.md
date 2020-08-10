[TOC]

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

#### Connection to http://repo.maven.apache.org refused(添加阿里镜像)
```
* idea => file => settings => Build,execution,Deployment => Build Tools => Maven => Users setting file
* 配置 config-file - maven - settings.xml
```

#### window安装maven
<https://blog.csdn.net/qq_37904780/article/details/81216179>
<https://www.cnblogs.com/happyday56/p/8968328.html>