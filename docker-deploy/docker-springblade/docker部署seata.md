docker pull seataio/seata-server
docker run --restart=always --net=host --name seata_container -p 8091:8091 -e SEATA_IP=localhost -e SEATA_PORT=8091 seataio/seata-server