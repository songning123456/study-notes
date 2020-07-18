#!/bin/sh

cd /home/songning/pro/cykb-es-server
rm -rf cykb-es-server-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/cykb-es-server.git
cd cykb-es-server/
mvn clean install -DskipTests
cp ./target/cykb-es-server-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-server
containerName=cykb-es-server_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi cykb-es-server_image
docker build -t cykb-es-server_image -f Dockerfile .
docker run --net=host --name cykb-es-server_container -d --restart=always cykb-es-server_image

# 用notepade转为unicode然后上传
# chmod u+x cykb-es-server.sh