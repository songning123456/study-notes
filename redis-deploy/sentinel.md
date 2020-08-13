*** 在alone模式上开发

cp ./conf-4.0.0/redis.conf ./service/redis.conf.16000
cp ./conf-4.0.0/redis.conf ./service/redis.conf.16001
cp ./conf-4.0.0/redis.conf ./service/redis.conf.16002

*** 修改从节点配置
vim ./service/redis.conf.16001
> slaveof 166.8.65.16 16000

vim ./service/redis.conf.16002
> slaveof 166.8.65.16 16000

sed -i 's/6379/16000/' ./service/redis.conf.16000
sed -i 's/6379/16001/' ./service/redis.conf.16001
sed -i 's/6379/16002/' ./service/redis.conf.16002

./conf-4.0.0/redis-server ./service/redis.conf.16000
./conf-4.0.0/redis-server ./service/redis.conf.16001
./conf-4.0.0/redis-server ./service/redis.conf.16002

vim ./conf-4.0.0/sentinel.conf
> protected-mode no
> daemonize yes

sed -i 's/26379/16003/' ./service/sentinel.conf.16003
sed -i 's/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster 166.8.65.16 16000 2/' ./service/sentinel.conf.16003

sed -i 's/26379/16004/' ./service/sentinel.conf.16004
sed -i 's/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster 166.8.65.16 16000 2/' ./service/sentinel.conf.16004

sed -i 's/26379/16005/' ./service/sentinel.conf.16005
sed -i 's/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster 166.8.65.16 16000 2/' ./service/sentinel.conf.16005

./conf-4.0.0/redis-sentinel ./service/sentinel.conf.16003
./conf-4.0.0/redis-sentinel ./service/sentinel.conf.16004
./conf-4.0.0/redis-sentinel ./service/sentinel.conf.16005