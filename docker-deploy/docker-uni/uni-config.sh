#!/bin/sh

cd /home/songning/pro/docker-uni-config
rm -rf uni-config-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/uni-config.git
cd uni-config/
mvn clean install -DskipTests
cp ./target/uni-config-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-config
containerName=uni-config_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi uni-config_image
docker build -t uni-config_image -f Dockerfile .
docker run --net=host --name uni-config_container -d --restart=always uni-config_image

# 用notepade转为unicode然后上传
# chmod u+x uni-config.sh