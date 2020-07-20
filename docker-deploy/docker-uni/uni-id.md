cd /home/songning/pro/docker-uni-id
git clone https://github.com/songning123456/uni-id.git (USE HTTPS)
cd uni-id/
mvn clean install -DskipTests
cp ./target/uni-id-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-id
vim Dockerfile
    FROM java:8
    COPY uni-id-1.0.0-SNAPSHOT.jar /uni/uni-id.jar
    CMD ["java", "-jar", "/uni/uni-id.jar"]
    RUN echo "Asia/Shanghai" > /etc/contentzone
    ENV LANG C.UTF-8
    // 这里是开始配置环境变量，非常重要
    // DUBBO_IP_TO_REGISTRY 这个是docker容器所在宿主机的外网ip，也就是docker所在服务器的ip
    ENV DUBBO_IP_TO_REGISTRY 192.168.0.109
    // DUBBO_PORT_TO_REGITRY 是dubbo服务的端口，用于注册到zookeeper中的
    ENV DUBBO_PORT_TO_REGISTRY 30003
    // 这个也是dubbo的服务端口，和上面的一样都填dubbo的端口，而不是zookeeper的端口
    ENV DUBBO_PORT_TO_BIND 30003
docker build -t uni-id_image -f Dockerfile .
docker run --restart=always --net=host --name uni-id_container -d uni-id_image