cd /home/songning/pro/cykb-es-theft
git clone https://github.com/songning123456/cykb-es-theft.git (USE HTTPS)
cd cykb-es-theft/
mvn clean install -DskipTests
cp ./target/cykb-es-theft-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-theft
vim Dockerfile
    FROM java:8
    EXPOSE 8022
    COPY cykb-es-theft-1.0.0-SNAPSHOT.jar /cykb/cykb-es-theft.jar
    CMD ["java", "-jar", "/cykb/cykb-es-theft.jar"]
    RUN echo "Asia/Shanghai" > /etc/timezone
    ENV LANG C.UTF-8
docker build -t cykb-es-theft_image -f Dockerfile .
docker run --restart=always --net=host --name cykb-es-theft_container -d cykb-es-theft_image