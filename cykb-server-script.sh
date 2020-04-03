#!/bin/sh

# linux 安装git maven
cd /home/songning/Documents/cykb
# 删除原有的jar包
rm -rf cykb-1.0.0-SNAPSHOT.jar
# git下载
git clone https://github.com/songning123456/cykb-server.git
cd cykb-server/
# 生成target jar包
mvn clean install -DskipTests
# 复制jar文件
cp ./target/cykb-1.0.0-SNAPSHOT.jar ../
cd ..
# 删除源文件
rm -rf cykb-server
containerName=cykb_container
exist=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${exist}" == "true" ]; then
        docker stop ${containerName}
fi
docker rm ${containerName}
# 运行 cykb_container
docker run --name cykb_container -d -p 8012:8012 cykb_image