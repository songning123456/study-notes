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


#### SpringBoot子工程jar启动找不到main
1. cd 工程目录下
2. mvn dependency:copy-dependencies -DoutputDirectory=lib
3. resources保存.yml文件

![springboot启动目录.jpg](/images/springboot启动目录.jpg)


#### Springboot工程maven找不到jar包
![mvn-install](/images/mvn-install.jpg)

mvn install:install-file -DgroupId=com.ctrip.framework.apollo -DartifactId=smart-apollo-client -Dversion=1.2.0-SNAPSHOT -Dpackaging=jar -Dfile=E:\dcits\smart-apollo-client-1.2.0-SNAPSHOT.jar


#### Maven打包时去掉项目版本号
Maven打包后，jar或war文件名里带有版本号信息，如projectname0.0.1-SNAPSHOT.jar等，怎么去掉呢？

解决办法：

打开项目pom.xml文件，在<build></build>标签内加入如下内容：
```
<build>
    <finalName>projectname</finalName>
</build>
```

 举例，若要打包成apollo-configservice.jar，则<finalName></finalName>标签内填写apollo-configservice即可。
 
 #### maven引入依赖失败（删除_remote.repositories和*.lastUpdated）
 
 cd到本地仓库目录下
 for /r %i (*.lastUpdated) do del %i
 for /r %i in (_remote.repositories) do del %i
 
#### maven项目引用lib目录下的jar包

<dependency>
    <groupId>xxx</groupId>
    <artifactId>xxx</artifactId>>
    <verison>xxx</verison>
    <scope>system</scope>
    <systemPath>{project.baseDir}/lib/xxx.jar</systemPath>
</dependency>