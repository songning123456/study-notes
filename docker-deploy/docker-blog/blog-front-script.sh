#!/bin/sh
rm -rf dist.tar.gz
rm -rf dist
rz
tar -zxvf dist.tar.gz
docker stop blog-front_container
docker rm blog-front_container
docker rmi blog-front_image
docker build -t blog-front_image -f Dockerfile .
docker run --name blog-front_container -d -p 8070:80 --restart=always -v /etc/localtime:/etc/localtime blog-front_image


# chmod u+x blog-front-script.sh // 添加文件执行权限
# ./blog-front-script.sh // 执行文件