[TOC]

#### nginx反向代理
```
* cd /etc/nginx
* vim nginx.conf
* include /etc/nginx/conf.d/*.conf;(一定要注释掉默认的配置文件)
	server {
		listen        80;
		server_name   localhost;
		location ^~ /server/ {
			proxy_pass   http://localhost:8072/;
			proxy_set_header X-Real-IP $remote_addr;
		}
		location / {
			proxy_pass  http://localhost:8070/;
		}
	}
* systemctl restart nginx.service(修改配置文件后重启nginx)
```


#### nginx 二级域名自定义error页面
```
*** 参考 https://www.cnblogs.com/zhaiyt/p/10313913.html
        https://www.cnblogs.com/paul8339/p/6871750.html
* cd /etc/nginx
* mkdir errorpage
* cd errorpage
* rz (error.html)
* cd ../conf.d
* vim cykb-web.conf
        proxy_intercept_errors on;
        fastcgi_intercept_errors on;
        server {
            listen      80;
            server_name  cykb.simple-blog.xyz;
            error_page   502 503 504 /errorpage;

          location / {
              proxy_pass   http://localhost:8030/;
         }
          location /errorpage {
               root /etc/nginx/;
               index error.html;
          }
        }
*** 当发生50x的错误的时候，会去寻找/errorpage的信息，然后匹配到下面location /errorpage这个location的内容，
    跟着会去到这个/etc/nginx/目录下寻找相关页面，这个目录下面有errorpage这个目录，errorpage目录下面有
    error.html这个文件，这样一步一步就能找到自定义的错误页面了
```

#### nginx重新刷新
```
nginx -s reload
```

#### centos7 安装 nginx
```
* yum install epel-release (No package nginx available)
* yum -y install nginx (安装 nginx)
* systemctl status nginx.service (查看nginx状态 未启动)
* service nginx start (启动nginx服务)
* systemctl status nginx.service (查看nginx的状态及进程与端口 启动后)
* sudo systemctl enable nginx (设置开始启动)

*** https://www.cnblogs.com/clubs/p/12346822.html(参考博客)
*** 使用yum进行Nginx安装时，Nginx配置文件在/etc/nginx目录下
    sudo systemctl enable nginx # 设置开机启动 
    sudo service nginx start # 启动nginx服务
    sudo service nginx stop # 停止nginx服务
    sudo service nginx restart # 重启nginx服务
    sudo service nginx reload # 重新加载配置，一般是在修改过nginx配置文件时使用。
    systemctl status nginx.service #查看nginx的状态及进程与端口
    netstat -antp | grep :80 #查看80端口被哪个服务占用
    netstat -antp | grep : #查看所有端口占用情况
    ps aux | grep nginx #查看nginx进程运行状态
    nginx -V #查看nginx版本
```

#### nginx: [error] open() "/var/run/nginx.pid" failed (2: No such file or directory)
```
cd /var/run
vim nginx.pid
nginx -c /etc/nginx/nginx.conf
nginx -s reload
```


#### nginx部署图片服务器
cd /etc/nginx/conf.d
vim image-server.conf
```
server {
    listen      80;
    server_name  image.sonin.cn;

    location / {
         root /etc/nginx/images/;
         autoindex on;
    }
}
```
nginx -s reload