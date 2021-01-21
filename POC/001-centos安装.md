<https://blog.csdn.net/babyxue/article/details/80970526>

dcits1: 192.168.8.181

dcits2: 192.168.8.182

* 无需安装图形化界面

* 固定IP地址
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

* 关闭防火墙
```
// 基本命令
	firewall-cmd --state (检查防火墙的状态)
	systemctl stop firewalld.service (停止firewall)
	systemctl disable firewalld.service (禁止firewall开机启动)
	systemctl start firewalld.service (启动)
	systemctl restart firewalld.service (重启)
	firewall-cmd --zone=public --add-port=5672/tcp --permanent(开放)
	firewall-cmd --zone=public --remove-port=5672/tcp --permanent(关闭)
	firewall-cmd --reload (配置立即生效)
    firewall-cmd --list-ports (查看已经开放的端口)
```