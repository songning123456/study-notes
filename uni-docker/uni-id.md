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
docker build -t uni-id_image -f Dockerfile .
docker run --restart=always --net=host --name uni-id_container -d uni-id_image