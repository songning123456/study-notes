mkdir -p /home/sonin/Documents/spring-blade/blade-develop
cd /home/sonin/Documents/spring-blade/blade-develop
rz (blade-develop.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-develop.jar ./blade-develop.jar
CMD ["java", "-jar", "blade-develop.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-develop_image -f Dockerfile .
docker run --restart=always --net=host --name blade-develop_container -d blade-develop_image