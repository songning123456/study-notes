*** redis-server redis-cli redis-sentinel redis.conf sentinel.conf在conf-4.0.0的目录下

tar xvf redis-4.0.0.bin.tar
cd /app/appmgr/deploy/

*** redis.conf 基本配置修改
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' ./conf-4.0.0/redis.conf
sed -i 's/protected-mode yes/protected-mode no/' ./conf-4.0.0/redis.conf
sed -i 's/daemonize no/daemonize yes/' ./conf-4.0.0/redis.conf
vim ./conf-4.0.0/redis.conf
> logfile '/app/appmgr/deploy/log/redis_log_6379.log'
> dir /app/appmgr/deploy/conf-4.0.0

cp ./conf-4.0.0/redis.conf ./service/redis.conf.15000
sed -i 's/6379/15000/' ./service/redis.conf.15000
./conf-4.0.0/redis-server ./service/redis.conf.15000