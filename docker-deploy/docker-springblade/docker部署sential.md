docker pull bladex/sentinel-dashboard
docker run --restart=always --name sentinel_container -d -p 8858:8858 -d bladex/sentinel-dashboard
dashboard 地址：http://ip:8858
username: sentinel
password: sentinel