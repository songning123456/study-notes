#!/bin/sh

cd /root/docker-advanced
rm -rf _book
# _book.tar.gz
rz
tar -zxvf _book.tar.gz
rm -rf _book.tar.gz
cp Dockerfile ./_book/
cd ./_book/
containerName=advanced_container
imageName=advanced_image
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi ${imageName}
docker build -t ${imageName} -f Dockerfile .
docker run --name ${containerName} -d -p 8042:80 --restart=always -v /etc/localtime:/etc/localtime ${imageName}