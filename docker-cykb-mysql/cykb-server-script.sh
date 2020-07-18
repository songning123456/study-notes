#!/bin/sh

# linux ��װgit maven
cd /home/songning/Documents/cykb
# ɾ��ԭ�е�jar��
rm -rf cykb-1.0.0-SNAPSHOT.jar
# git����
git clone https://github.com/songning123456/cykb-server.git
cd cykb-server/
# ����target jar��
mvn clean install -DskipTests
# ����jar�ļ�
cp ./target/cykb-1.0.0-SNAPSHOT.jar ../
cd ..
# ɾ��Դ�ļ�
rm -rf cykb-server
containerName=cykb_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
        docker stop ${containerName}
fi
docker rm ${containerName}
# ���� cykb_container
docker run --name cykb_container -d -p 8012:8012 cykb_image