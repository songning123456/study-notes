cd /home/songning/pro/docker-blog-server
git clone https://github.com/songning123456/multi-server.git
cd multi-server/
mvn clean install -DskipTests
cp ./blog-server/target/blog-server-1.0-SNAPSHOT.jar ../
cd ..
rm -rf multi-server
vim Dockerfile
    FROM java:8
    EXPOSE 8072
    COPY blog-server-1.0-SNAPSHOT.jar /blog/blog-server.jar
    CMD ["java", "-jar", "/blog/blog-server.jar"]
    RUN echo "Asia/Shanghai" > /etc/timezone
    ENV LANG C.UTF-8
docker build -t blog-server_image -f Dockerfile .
docker run --restart=always --net=host --name blog-server_container -d blog-server_image