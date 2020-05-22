cd /home/songning/pro/docker-uni-register
git clone https://github.com/songning123456/uni-register.git (USE HTTPS)
cd uni-register/
mvn clean install -DskipTests
cp ./target/uni-register-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-register
vim Dockerfile
    FROM java:8
    COPY uni-register-1.0.0-SNAPSHOT.jar /uni/uni-register.jar
    CMD ["java", "-jar", "/uni/uni-register.jar"]
    RUN echo "Asia/Shanghai" > /etc/contentzone
    ENV LANG C.UTF-8
docker build -t uni-register_image -f Dockerfile .
docker run --restart=always --net=host --name uni-register_container -d uni-register_image