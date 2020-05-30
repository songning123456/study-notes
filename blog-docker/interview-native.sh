#!/bin/sh

cd /root/docker-interview
rm -rf _book
rz (book.tar.gz)
tar -zxvf book.tar.gz
rm -rf book.tar.gz
cp Dockerfile ./_book/
cd ./_book/
containerName=interview_container
imageName=interview_image
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker rmi ${imageName}
docker build -t ${imageName} -f Dockerfile .
docker run --name ${containerName} -d -p 8040:80 --restart=always -v /etc/localtime:/etc/localtime ${imageName}