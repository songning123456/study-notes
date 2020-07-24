docker pull bladex/sentinel-dashboard
docker run --name sentinel_container -d -p 8858:8858 -d bladex/sentinel-dashboard
dashboard 地址：http://localhost:8858
username: sentinel
password: sentinel