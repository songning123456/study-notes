#!/bin/sh

cd /home/songning/pro/docker-uni-gateway
rm -rf uni-gateway-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/uni-gateway.git
cd uni-gateway/
mvn clean install -DskipTests
cp ./target/uni-gateway-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-gateway
containerName=uni-gateway_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi uni-gateway_image
docker build -t uni-gateway_image -f Dockerfile .
docker run --net=host --name uni-gateway_container -d --restart=always uni-gatewayimage

# 用notepade转为unicode然后上传
# chmod u+x uni-gateway.sh