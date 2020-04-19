#!/bin/sh

cd /home/songning/pro/cykb-es-time
rm -rf time-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/cykb-es-time.git
cd cykb-es-time/
mvn clean install -DskipTests
cp ./target/time-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-time
containerName=cykb-es-time_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi cykb-es-time_image
docker build -t cykb-es-time_image -f Dockerfile .
docker run --net=host --name cykb-es-time_container -d --restart=always cykb-es-time_image

# 用notepade转为unicode然后上传
# chmod u+x cykb-es.time.sh