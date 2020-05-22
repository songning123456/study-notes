// window
* cykb图片地址:		https://www.iconfont.cn/collections/detail?
					spm=a313x.7781069.1998910419.d9df05512&cid=2350
* HX: 发行h5版本
* cd ...(项目路径)\unpackage\dist\build
* tar -zcvf h5.tar.gz h5
	// linux
* mkdir cykb-web-dir
* cd cykb-web-dir
* rz (h5.tar.gz)
* tar -zxvf h5.tar.gz
* vim Dockerfile
	FROM nginx
	COPY h5/ /usr/share/nginx/html/
* docker build -t cykb-web_image -f Dockerfile .
* docker run --name cykb-web_container -d -p 8030:80 cykb-web_image