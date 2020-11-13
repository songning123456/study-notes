mkdir -p /home/sonin/Documents/spring-blade/blade-auth
cd /home/sonin/Documents/spring-blade/blade-auth
rz (blade-auth.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-auth.jar ./blade-auth.jar
CMD ["java", "-jar", "blade-auth.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-auth_image -f Dockerfile .
docker run --restart=always --net=host --name blade-auth_container -d blade-auth_image