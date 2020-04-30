cd /home/songning/pro/docker-uni-gateway
git clone https://github.com/songning123456/uni-gateway.git (USE HTTPS)
cd uni-gateway/
mvn clean install -DskipTests
cp ./target/uni-gateway-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-gateway
vim Dockerfile
    FROM java:8
    COPY uni-gateway-1.0.0-SNAPSHOT.jar /uni/uni-gateway.jar
    CMD ["java", "-jar", "/uni/uni-gateway.jar"]
    RUN echo "Asia/Shanghai" > /etc/contentzone
    ENV LANG C.UTF-8
docker build -t uni-gateway_image -f Dockerfile .
docker run --restart=always --net=host --name uni-gateway_container -d uni-gateway_image