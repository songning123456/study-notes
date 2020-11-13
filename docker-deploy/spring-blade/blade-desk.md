mkdir -p /home/sonin/Documents/spring-blade/blade-desk
cd /home/sonin/Documents/spring-blade/blade-desk
rz (blade-desk.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-desk.jar ./blade-desk.jar
CMD ["java", "-jar", "blade-desk.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-desk_image -f Dockerfile .
docker run --restart=always --net=host --name blade-desk_container -d blade-desk_image