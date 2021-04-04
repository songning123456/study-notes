#!/bin/bash

#开启系统路由模式功能(net.ipv4.ip_forward=0修改成1)
echo net.ipv4.ip_forward=1>>/etc/sysctl.conf
#运行这个命令会输出上面添加的那一行信息，意思是使内核修改生效
sysctl -p
#开启firewalld
systemctl start firewalld
#开启80端口监听tcp请求
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=1080/tcp --permanent
#设置IP地址伪装
firewall-cmd --add-masquerade --permanent
#设置端口映射
# firewall-cmd --add-forward-port=port=4650:proto=tcp:toaddr=${1}:toport=${2} --permanent
# 考虑多执行几次，重启后也执行一次（经常不生效）
firewall-cmd --add-forward-port=port=80:proto=tcp:toport=1080
firewall-cmd --add-masquerade --permanent
#重启firewall
firewall-cmd --reload

# [注意] ${0} 和 ${2}这两个端口都要开放