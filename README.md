[TOC]

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

#### docker 安装
```
yum update
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install docker-ce-17.12.1.ce
systemctl start docker
systemctl enable docker
docker -v
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

#### 阿里云docker镜像加速
```
* cd /etc/docker/
* rz (daemon.json)
* sudo systemctl daemon-reload
* sudo systemctl restart docker
```

#### 修改window host文件(刷新)
```
ipconfig /flushdns
```

#### nginx反向代理
```
* cd /etc/nginx
* vim nginx.conf
* include /etc/nginx/conf.d/*.conf;(一定要注释掉默认的配置文件)
	server {
		listen        80;
		server_name   localhost;
		location ^~ /server/ {
			proxy_pass   http://localhost:8072/;
			proxy_set_header X-Real-IP $remote_addr;
		}
		location / {
			proxy_pass  http://localhost:8070/;
		}
	}
* systemctl restart nginx.service(修改配置文件后重启nginx)
```

#### docker安装elasticsearch&&kibana
```
* docker pull elasticsearch:6.5.4
* mkdir es-data
  chmod 777 es-data
  mkdir es-conf
  cd es-conf/
  rz elasticsearch.yml
* docker run -d -u 1000:1000 
	--restart=always --privileged=true 
	--name es_container 
	-v $PWD/es-data:/usr/share/elasticsearch/data
	-v $PWD/es-conf/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    -e "discovery.type=single-node"  
    -e "xpack.security.enabled=false"  
    -e "TZ=Asia/Shanghai"  
    -p 9200:9200 -p 9300:9300 elasticsearch:6.5.4
* docker pull kibana:6.5.4
* docker run --name kibana_container -p 5601:5601 --restart=always
	-d -e ELASTICSEARCH_URL=http://192.168.0.108:9200 kibana:6.5.4
```

#### linux查看某个端口是否被占用
```
* netstat -ano | findstr "8080"
```

#### nginx 二级域名自定义error页面
```
*** 参考 https://www.cnblogs.com/zhaiyt/p/10313913.html
        https://www.cnblogs.com/paul8339/p/6871750.html
* cd /etc/nginx
* mkdir errorpage
* cd errorpage
* rz (error.html)
* cd ../conf.d
* vim cykb-web.conf
        proxy_intercept_errors on;
        fastcgi_intercept_errors on;
        server {
            listen      80;
            server_name  cykb.simple-blog.xyz;
            error_page   502 503 504 /errorpage;

          location / {
              proxy_pass   http://localhost:8030/;
         }
          location /errorpage {
               root /etc/nginx/;
               index error.html;
          }
        }
*** 当发生50x的错误的时候，会去寻找/errorpage的信息，然后匹配到下面location /errorpage这个location的内容，
    跟着会去到这个/etc/nginx/目录下寻找相关页面，这个目录下面有errorpage这个目录，errorpage目录下面有
    error.html这个文件，这样一步一步就能找到自定义的错误页面了
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

#### docker 安装kafka
```
* docker pull wurstmeister/zookeeper:latest
* docker run -d --name zookeeper_container --restart=always -p 2181:2181 -v /etc/localtime:/etc/localtime wurstmeister/zookeeper
* docker pull wurstmeister/kafka:2.11-0.11.0.3
* docker run -d --name kafka_container --restart=always --link zookeeper_container -p 9092:9092 -e KAFKA_BROKER_ID=0 -e KAFKA_ZOOKEEPER_CONNECT=192.168.0.108:2181/kafka -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.108:9092 -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 -v /etc/localtime:/etc/localtime wurstmeister/kafka:2.11-0.11.0.3

    注释: 
    -e KAFKA_BROKER_ID=0  在kafka集群中，每个kafka都有一个BROKER_ID来区分自己
    -e KAFKA_ZOOKEEPER_CONNECT=192.168.0.108:2181/kafka 配置zookeeper管理kafka的路径192.168.0.108:2181/kafka
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.108:9092  把kafka的地址端口注册给zookeeper
    -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 配置kafka的监听端口
```

#### 下载docker日志
```
docker logs xxx_container > xxx-log.txt
sz xxx-log.txt
```

