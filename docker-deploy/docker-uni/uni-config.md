cd /home/songning/pro/docker-uni-config
git clone https://github.com/songning123456/uni-config.git (USE HTTPS)
cd uni-config/
mvn clean install -DskipTests
cp ./target/uni-config-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-config
vim Dockerfile
    FROM java:8
    COPY uni-config-1.0.0-SNAPSHOT.jar /uni/uni-config.jar
    CMD ["java", "-jar", "/uni/uni-config.jar"]
    RUN echo "Asia/Shanghai" > /etc/contentzone
    ENV LANG C.UTF-8
docker build -t uni-config_image -f Dockerfile .
docker run --restart=always --net=host --name uni-config_container -d uni-config_image