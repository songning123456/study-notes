参考: <https://blog.csdn.net/qq_34807429/article/details/103779305>
docker pull nacos/nacos-server
docker run -d --restart=always --net=host --name nacos_container -p 8848:8848 -e PREFER_HOST_MODE=hostname -e MODE=standalone nacos/nacos-server
地址：http://ip:8848/nacos (查看linux端口是否已经开放)
username: nacos
password: nacos

* 注意 
mysql版本5.7(docker pull mysql:5.7)，否则会nacos和mysql版本冲突


docker restart nacos_container

