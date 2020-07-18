#!/bin/sh

cd /home/songning/pro/cykb-theft
rm -rf cykb-es-theft-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/cykb-es-theft.git
cd cykb-es-theft/
mvn clean install -DskipTests
cp ./target/cykb-es-theft-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-theft
containerName=cykb-es-theft_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi cykb-es-theft_image
docker build -t cykb-es-theft_image -f Dockerfile .
docker run --net=host --name cykb-es-theft_container -d --restart=always cykb-es-theft_image

# 用notepade转为unicode然后上传
# chmod u+x cykb-es.theft.sh