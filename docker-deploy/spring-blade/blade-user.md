mkdir -p /home/sonin/Documents/spring-blade/blade-user
cd /home/sonin/Documents/spring-blade/blade-user
rz (blade-user.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-user.jar ./blade-user.jar
CMD ["java", "-jar", "blade-user.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-user_image -f Dockerfile .
docker run --restart=always --net=host --name blade-user_container -d blade-user_image