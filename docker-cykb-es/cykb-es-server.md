cd /home/songning/pro/cykb-es-server
git clone https://github.com/songning123456/cykb-es-server.git
cd cykb-es-server/
mvn clean install -DskipTests
cp ./target/cykb-es-server-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-server
vim Dockerfile
    FROM java:8
    EXPOSE 8020
    COPY cykb-es-server-1.0.0-SNAPSHOT.jar /cykb/cykb-es-server.jar
    CMD ["java", "-jar", "/cykb/cykb-es-server.jar"]
    RUN echo "Asia/Shanghai" > /etc/timezone
    ENV LANG C.UTF-8
docker build -t cykb-es-server_image -f Dockerfile .
docker run --restart=always --net=host --name cykb-es-server_container -d cykb-es-server_image