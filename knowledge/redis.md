#### linux单机多端口部署redis5.0.0集群

<https://blog.csdn.net/a1102325298/article/details/80396450>

* 创建文件夹用来放置redis文件夹目录
```
mkdir redis-cluster
cd redis-cluster
mkdir 7001
mkdir 7002
mkdir 7003
mkdir 7004
mkdir 7005
mkdir 7006
rz
tar -zxf redis-5.0.0.tar.gz
rm -rf redis-5.0.0.tar.gz
cd redis-5.0.0/
```

* 安装相关环境
```
yum install gcc
make && make install
cd src
make install PREFIX=/usr/local/redis
```

* 配置7001文件
```
cp redis-5.0.0/redis.conf 7001/
vim 7001/redis.conf
port 7001	//六个节点配置文件分别是7001-7006
daemonize yes	//redis后台运行
pidfile /var/run/redis_7001.pid	//pidfile文件对应7001-7006
cluster-enabled yes	//开启集群
cluster-config-file nodes_7001.conf	//保存节点配置，自动创建，自动更新对应7001-7006
cluster-node-timeout 5000	//集群超时时间，节点超过这个时间没反应就断定是宕机
appendonly yes	//存储方式，aof，将写操作记录保存到日志中
// 最后两行必须执行，否则客户端不能连接
# bind 127.0.0.1 // 注释此行
protected no // yes修改为no
```
    
* 复制配置文件到7002~7006
```
cp 7001/redis.conf 7002/
cp 7001/redis.conf 7003/
cp 7001/redis.conf 7004/
cp 7001/redis.conf 7005/
cp 7001/redis.conf 7006/
```
	
* 修改配置文件
```
vim 7002/redis.conf 
vim 7003/redis.conf 
vim 7004/redis.conf 
vim 7005/redis.conf 
vim 7006/redis.conf 
把 port ，pidfile，cluster-config-file 分别修改下即可
```

* 启动6个节点的redis
```
/usr/local/redis/bin/redis-server /home/sonin/Documents/redis-cluster/7001/redis.conf 
/usr/local/redis/bin/redis-server /home/sonin/Documents/redis-cluster/7002/redis.conf 
/usr/local/redis/bin/redis-server /home/sonin/Documents/redis-cluster/7003/redis.conf 
/usr/local/redis/bin/redis-server /home/sonin/Documents/redis-cluster/7004/redis.conf 
/usr/local/redis/bin/redis-server /home/sonin/Documents/redis-cluster/7005/redis.conf 
/usr/local/redis/bin/redis-server /home/sonin/Documents/redis-cluster/7006/redis.conf 
```

* 查看redis进程
```
ps -ef | grep redis 
```

* 创建集群
```
/usr/local/redis/bin/redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005  127.0.0.1:7006 --cluster-replicas 1
```


#### linux单机多端口部署redis5.0.0主从模式
<https://blog.csdn.net/zhan123com/article/details/105512241>


#### redis-server/redis-cli命令添加到环境变量中
```
vim /etc/profile


// profile文件末尾添加如下配置
// $PATH 映射 命令所在文件位置
export PATH=$PATH:/usr/local/redis/bin

// 重新加载
source /etc/profile
```