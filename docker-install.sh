#!/bin/sh

# ����root ��ִ��
# ��yum�����µ�����
yum update
# ��װ��Ҫ��������� yum-util �ṩyum-config-manager���ܣ�����������devicemapper����������
yum install -y yum-utils device-mapper-persistent-data lvm2
# ����yumԴ
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# ��װDocker
yum install docker-ce-17.12.1.ce
# ����Docker
systemctl start docker
systemctl enable docker
docker -v
