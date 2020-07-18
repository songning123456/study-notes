#!/bin/sh

cd /home/songning/pro/docker-blog-server
rm -rf blog-server-1.0-SNAPSHOT.jar
git clone https://github.com/songning123456/multi-server.git
cd multi-server/
mvn clean install -DskipTests
cp ./blog-server/target/blog-server-1.0-SNAPSHOT.jar ../
cd ..
rm -rf multi-server
containerName=blog-server_container
imageName=blog-server_image
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi ${imageName}
docker build -t ${imageName} -f Dockerfile .
docker run --net=host --name ${containerName} -d --restart=always ${imageName}