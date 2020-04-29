cd /home/songning/pro/cykb-content
git clone https://github.com/songning123456/cykb-es-content.git (USE HTTPS)
cd cykb-es-content/
mvn clean install -DskipTests
cp ./target/content-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-content
vim Dockerfile
    FROM java:8
    COPY content-1.0.0-SNAPSHOT.jar /cykb/cykb-es-content.jar
    CMD ["java", "-jar", "/cykb/cykb-es-content.jar"]
    RUN echo "Asia/Shanghai" > /etc/contentzone
    ENV LANG C.UTF-8
docker build -t cykb-es-content_image -f Dockerfile .
docker run --restart=always --net=host --name cykb-es-content_container -d cykb-es-content_image