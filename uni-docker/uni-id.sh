#!/bin/sh

cd /home/songning/pro/docker-uni-id
rm -rf uni-id-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/uni-id.git
cd uni-id/
mvn clean install -DskipTests
cp ./target/uni-id-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-id
containerName=uni-id_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi uni-id_image
docker build -t uni-id_image -f Dockerfile .
docker run --net=host --name uni-id_container -d --restart=always uni-id_image

# 用notepade转为unicode然后上传
# chmod u+x uni-id.sh