#!/bin/sh

cd /home/songning/pro/cykb-content
rm -rf content-1.0.0-SNAPSHOT.jar
git clone https://github.com/songning123456/cykb-es-content.git
cd cykb-es-content/
mvn clean install -DskipTests
cp ./target/content-1.0.0-SNAPSHOT.jar ../
cd ..
rm -rf cykb-es-content
containerName=cykb-es-content_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi cykb-es-content_image
docker build -t cykb-es-content_image -f Dockerfile .
docker run --net=host --name cykb-es-content_container -d --restart=always cykb-es-content_image

# 用notepade转为unicode然后上传
# chmod u+x cykb-es-content.sh