#!/bin/sh

cd /home/songning/pro/docker-uni-register
rm -rf uni-register-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/uni-register.git
cd uni-register/
mvn clean install -DskipTests
cp ./target/uni-register-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf uni-register
containerName=uni-register_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi uni-register_image
docker build -t uni-register_image -f Dockerfile .
docker run --net=host --name uni-register_container -d --restart=always uni-register_image

# 用notepade转为unicode然后上传
# chmod u+x uni-register.sh