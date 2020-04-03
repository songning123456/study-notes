#!/bin/sh

# 请在root 下执行
# 把yum包更新到最新
yum update
# 安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的
yum install -y yum-utils device-mapper-persistent-data lvm2
# 设置yum源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 安装Docker
yum install docker-ce-17.12.1.ce
# 启动Docker
systemctl start docker
systemctl enable docker
docker -v
