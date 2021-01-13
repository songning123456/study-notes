#!/bin/sh

cd /root/docker-hexo-dir
rm -rf public
rz
containerName=hexo_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
      docker stop ${containerName}
fi
docker rm ${containerName}
docker run --name ${containerName} -v $PWD/public/:/usr/local/apache2/htdocs/ -p 8052:80 -d httpd