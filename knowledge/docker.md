[TOC]

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

#### 阿里云docker镜像加速
```
* cd /etc/docker/
* rz (daemon.json)
* sudo systemctl daemon-reload
* sudo systemctl restart docker
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

#### docker 安装zookeeper,kafka
```
*** https://www.jianshu.com/p/e8c29cba9fae
* docker pull wurstmeister/zookeeper:latest
* docker run -d --name zookeeper_container --restart=always --net=host -v /etc/localtime:/etc/localtime wurstmeister/zookeeper (占用port:2181)
* docker pull wurstmeister/kafka:2.11-0.11.0.3
* docker run -d --name kafka_container --restart=always --net=host -e KAFKA_BROKER_ID=0 -e KAFKA_ZOOKEEPER_CONNECT=192.168.0.108:2181/kafka -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.108:9092 -e KAFKA_LISTENERS=PLAINTEXT://192.168.0.108:9092 -v /etc/localtime:/etc/localtime wurstmeister/kafka:2.11-0.11.0.3
* docker exec -it kafka_container /bin/sh
* cd /opt/kafka_2.11-0.11.0.3/bin
* ./kafka-console-producer.sh --broker-list 192.168.0.108:9092 --topic sun (测试 生产者)
* ./kafka-console-consumer.sh --bootstrap-server 192.168.0.108:9092 --topic sun --from-beginning (测试消费者)

    注释: 
    防火墙开放2181,9092端口
    -e KAFKA_BROKER_ID=0  在kafka集群中，每个kafka都有一个BROKER_ID来区分自己
    -e KAFKA_ZOOKEEPER_CONNECT=192.168.0.108:2181/kafka 配置zookeeper管理kafka的路径192.168.0.108:2181/kafka
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.108:9092  把kafka的地址端口注册给zookeeper
    -e KAFKA_LISTENERS=PLAINTEXT://192.168.0.108:9092 配置kafka的监听端口
```

#### 下载docker日志
```
docker logs xxx_container > xxx-log.txt
sz xxx-log.txt
```

#### docker 安装 spring initializr
```
docker pull pollyduan/start_spring_io
docker run -tid --name spring-io_container -p 9999:8080 pollyduan/start_spring_io
```

#### docker 安装 nexus
```
*** 参考 https://www.cnblogs.com/niceyoo/p/11204143.html; https://blog.csdn.net/u012943767/article/details/79475718
mkdir nexus
cd nexus
mkdir nexus-data
docker pull sonatype/nexus3
docker run -d -p 8081:8081 --name nexus_container -v $PWD/nexus-data:/var/nexus-data --restart=always sonatype/nexus3
http://ip:8081
find / -name 'admin.password' => xxx/admin.password
cd xxx
cat admin.password
```
