#!/bin/sh

# linux ��װgit maven
cd /home/songning/Documents/cykb
# ɾ��ԭ�е�jar��
rm -rf cykb-1.0.0-SNAPSHOT.jar
# git����
git clone git@github.com:songning123456/cykb-server.git
cd cykb-server/
# ����target jar��
mvn clean install -DskipTests
# ����jar�ļ�
cp ./target/cykb-1.0.0-SNAPSHOT.jar ../
cd ..
# ɾ��Դ�ļ�
rm -rf cykb-server
# ���� cykb_container
docker run --name cykb_container -d -p 8012:8012 cykb_image