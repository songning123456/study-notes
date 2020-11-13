mkdir -p /home/sonin/Documents/spring-blade/blade-resource
cd /home/sonin/Documents/spring-blade/blade-resource
rz (blade-resource.jar)
vim Dockerfile
```
FROM java:8
COPY ./blade-resource.jar ./blade-resource.jar
CMD ["java", "-jar", "blade-resource.jar"]
RUN echo "Asia/Shanghai" > /etc/timezone
ENV LANG C.UTF-8
```
docker build -t blade-resource_image -f Dockerfile .
docker run --restart=always --net=host --name blade-resource_container -d blade-resource_image