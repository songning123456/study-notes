#### window
cd ../view-book-dir
gitbook build
tar -zcvf _book.tar.gz _book

#### linux 
cd /root/docker-view-dir
rz _book.tar.gz
tar -zxvf _book.tar.gz
rm -rf _book.tar.gz
cp Dockerfile ./_book/
cd ./_book/
docker build -t view_image -f Dockerfile .
docker run --name view_container -d -p 8040:80 --restart=always -v /etc/localtime:/etc/localtime view_image