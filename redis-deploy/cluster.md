cp ./conf-4.0.0/redis.conf ./conf-4.0.0/redis-cluster.conf
vim ./conf-4.0.0/redis-cluster
> cluster-enable yes
> cluster-config-file /app/appmgr/deploy/service/nodes-6379.conf

sed -i 's/6379/17000/' ./service/redis.conf.17000
sed -i 's/6379/17001/' ./service/redis.conf.17001
sed -i 's/6379/17002/' ./service/redis.conf.17002
sed -i 's/6379/17003/' ./service/redis.conf.17003
sed -i 's/6379/17004/' ./service/redis.conf.17004
sed -i 's/6379/17005/' ./service/redis.conf.17005