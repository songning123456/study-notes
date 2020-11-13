mkdir -p /home/sonin/Documents/spring-blade/blade-gateway
cd /home/sonin/Documents/spring-blade/blade-gateway
rz (blade-gateway.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-gateway.jar ./blade-gateway.jar
CMD ["java", "-jar", "blade-gateway.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-gateway_image -f Dockerfile .
docker run --restart=always --net=host --name blade-gateway_container -d blade-gateway_image