mkdir -p /home/sonin/Documents/spring-blade/blade-system
cd /home/sonin/Documents/spring-blade/blade-system
rz (blade-system.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-system.jar ./blade-system.jar
CMD ["java", "-jar", "blade-system.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-system_image -f Dockerfile .
docker run --restart=always --net=host --name blade-system_container -d blade-system_image