#!/bin/sh

cd /root/docker-interview
rm -rf _book
git clone https://github.com/songning123456/interview-book.git
mv ./interview-book/_book/ .
rm -rf interview-book/
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