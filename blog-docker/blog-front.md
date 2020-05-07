* tar -zcvf dist.tar.gz dist //本地压缩dist文件
* mkdir blog-front-dir
  cd blog-front-dir
* rz dist.tar.gz //上传文件
* tar -zxvf dist.tar.gz //解压文件
* vim Dockerfile
 # 设置基础镜像
    FROM nginx
    # 定义作者
    MAINATNER songning
    # 将dist文件中的内容复制到 /usr/share/nginx/html/ 这个目录下面
    COPY dist/ /usr/share/nginx/html/
* docker build -t blog-front_image -f Dockerfile .
* docker run --name blog-front_container -d -p 8070:80 --restart=always -v /etc/localtime:/etc/localtime blog-front_image
