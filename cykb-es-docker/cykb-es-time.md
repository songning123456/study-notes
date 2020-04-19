cd /home/songning/pro/cykb-es-time
git clone https://github.com/songning123456/cykb-es-time.git (USE HTTPS)
cd cykb-es-time/
mvn clean install -DskipTests
cp ./target/time-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-time
vim Dockerfile
    FROM java:8
    COPY time-1.0.0-SNAPSHOT.jar /cykb/cykb-es-time.jar
    CMD ["java", "-jar", "/cykb/cykb-es-time.jar"]
    RUN echo "Asia/Shanghai" > /etc/timezone
    ENV LANG C.UTF-8
docker build -t cykb-es-time_image -f Dockerfile .
docker run --restart=always --net=host --name cykb-es-time_container -d cykb-es-time_image