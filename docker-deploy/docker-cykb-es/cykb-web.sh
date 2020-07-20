cd /root/cykb-web-dir
rm -rf h5
rm -rf h5.tar.gz
rz
tar -zxvf h5.tar.gz
containerName=cykb-web_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
	if [ "${exist}" == "true" ]; then
		docker stop ${containerName}
	fi
docker rm ${containerName}
docker rmi cykb-web_image
docker build -t cykb-web_image -f Dockerfile .
docker run --name cykb-web_container -d -p 8030:80 cykb-web_image