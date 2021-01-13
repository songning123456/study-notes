cd /root/docker-hexo-dir/
rz (public文件夹)
docker stop hexo_container
docker rm hexo_container
docker run --name hexo_container -v /root/docker-hexo-dir/public/:/usr/local/apache2/htdocs/ -p 8052:80 -d httpd
