[TOC]

#### VMware安装CentOS7
```
https://blog.csdn.net/tsundere_x/article/details/104263100
https://blog.csdn.net/babyxue/article/details/80970526
```


#### linux命令行添加图形化界面
```
yum update grub2-common               
yum install fwupdate-efi
yum groupinstall "GNOME Desktop" "Graphical Administration Tools"   // 安装这个包即可，前面两个是依赖包
systemctl set-default graphical.target  // 设置图形化界面启动，可以不要。用init 5切换过去也可
```


#### CentOS7为docker-ce配置阿里云镜像加速器
```
https://www.cnblogs.com/geekdc/p/11173671.html
study-notes\阿里云docker镜像加速.txt
```

#### linux查看端口使用情况
```
lsof -i:7000
```

#### centos7防火墙
```
* 基本命令
	firewall-cmd --state (检查防火墙的状态)
	systemctl stop firewalld.service (停止firewall)
	systemctl disable firewalld.service (禁止firewall开机启动)
	systemctl start firewalld.service (启动)
    systemctl enable firewalld (开机启动)
	systemctl restart firewalld.service (重启)
	firewall-cmd --zone=public --add-port=5672/tcp --permanent(开放)
	firewall-cmd --zone=public --remove-port=5672/tcp --permanent(关闭)
	firewall-cmd --reload (配置立即生效)
    firewall-cmd --list-ports (查看已经开放的端口)
```

#### CentOS7实现端口转发
由于普通用户无法通过80端口启动nginx，因此修改nginx.conf为1080，
通过防火墙实现端口转发，参考transport.sh。防火墙必须开启，同时源
端口80和目标端口1080必须开发。

```
// 判断端口转发是否成功
firewall-cmd --list-all

// 结果
public
  target: default
  icmp-block-inversion: no
  interfaces: 
  sources: 
  services: dhcpv6-client ssh
  ports: 80/tcp 1080/tcp 8090/tcp
  protocols: 
  masquerade: yes
  forward-ports: port=80:proto=tcp:toport=1080:toaddr=
  source-ports: 
  icmp-blocks: 
  rich rules: 
```


#### linux查看某个端口是否被占用
```
* netstat -ano | findstr "8080"
```


#### linux固定ip
```
参考 https://blog.csdn.net/qq_38138069/article/details/80982527

* vim /etc/sysconfig/network-scripts/ifcfg-ens33

    TYPE="Ethernet"
    PROXY_METHOD="none"
    BROWSER_ONLY="no"
    BOOTPROTO="static" (dhcp 改为 static)
    DEFROUTE="yes"
    IPV4_FAILURE_FATAL="no"
    IPV6INIT="yes"
    IPV6_AUTOCONF="yes"
    IPV6_DEFROUTE="yes"
    IPV6_FAILURE_FATAL="no"
    IPV6_ADDR_GEN_MODE="stable-privacy"
    NAME="ens33"
    UUID="faf68ce4-4ed9-4991-9475-7874b8fde25f"
    DEVICE="ens33"
    ONBOOT="yes"
    IPADDR="192.168.xxx(与宿主机相同).yyy" (填写需要的静态ip)
    GATEWAY="192.168.xxx.1" (宿主机网关)
    NETMASK="255.255.255.0" (宿主机子网掩码)
    DNS1=114.114.114.114
    DNS2=8.8.8.8

注意: =两侧一定不能有空格，不能留空白行

* reboot || service network restart
```

#### windows上传文件到linux需转换为unix格式
```
yum install dos2unix (如果已经安装，则略过此步骤)
dos2unix xxx.sh (xxx.sh是你需要转换的文件)
```

#### linux安装git
```
yum -y install git
git --version
```

#### linux模糊删除文件
```
find / -name "test*" |xargs rm -rf 
```


#### centos7如何安装sshpass
```
yum install -y epel-release
yum repolist
yum install -y sshpass
sshpass –V
```


#### 服务器A远程访问服务器B
<https://blog.csdn.net/sn3009/article/details/52779642>

```
服务器A => 192.168.0.10
服务器B => 192.168.0.11

服务器A xshell终端
    ssh 用户名@192.168.0.11 << remotessh
    > ...   // 具体操作
    > ...   // 具体操作
    > ...   // 具体操作
    > exit
    > remotessh


Q: Pseudo-terminal will not be allocated because stdin is not a terminal
A: ssh -tt 用户名@192.168.0.11 << remotessh
```

```
// 后续需要在机器上离线安装sshpass
// 目前在本机test环境下测试的
sshpass -p rediscloud ssh -tt rediscloud@10.5.181.32 << remotessh
> cd /home/rediscloud/deploy
> mkdir test
> exit
> remotessh     // 只有执行完这一步，10.5.181.32环境才会生成test文件夹
```

#### linux解压xxx.tar.gz
tar -zxvf filename.tar.gz 解压到当前文件夹 
tar -zxvf java.tar.gz  -C /usr/dir 解压到指定文件夹

#### xftp上传失败（磁盘空间已满）
df -h (查看各个挂载磁盘信息情况)
du -sh * (查看文件占用容量情况)


#### vi文字显示不同颜色

1. yum install -y vim
2. vi ~/.vimrc
```
set t_Co=256
syntax on
```
3. ln -sf /usr/bin/vim /bin/vi  // syntax: command not found


#### 编辑sudoers文件
vi /etc/sudoers
找到这行 root ALL=(ALL) ALL,在他下面添加xxx ALL=(ALL) ALL (这里的xxx是你的用户名)

ps:这里说下你可以sudoers添加下面四行中任意一条
youuser            ALL=(ALL)                ALL
%youuser           ALL=(ALL)                ALL
youuser            ALL=(ALL)                NOPASSWD: ALL
%youuser           ALL=(ALL)                NOPASSWD: ALL

第一行:允许用户youuser执行sudo命令(需要输入密码).
第二行:允许用户组youuser里面的用户执行sudo命令(需要输入密码).
第三行:允许用户youuser执行sudo命令,并且在执行的时候不输入密码.
第四行:允许用户组youuser里面的用户执行sudo命令,并且在执行的时候不输入密码.
