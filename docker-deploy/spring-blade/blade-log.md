mkdir -p /home/sonin/Documents/spring-blade/blade-log
cd /home/sonin/Documents/spring-blade/blade-log
rz (blade-log.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-log.jar ./blade-log.jar
CMD ["java", "-jar", "blade-log.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-log_image -f Dockerfile .
docker run --restart=always --net=host --name blade-log_container -d blade-log_image