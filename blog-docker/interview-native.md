#### window
cd ../interview-book
gitbook build
tar -zcvf _book.tar.gz _book

#### linux 
cd /root/docker-interview
rz _book.tar.gz
tar -zxvf _book.tar.gz
rm -rf _book.tar.gz
cp Dockerfile ./_book/
cd ./_book/
docker build -t interview_image -f Dockerfile .
docker run --name interview_container -d -p 8040:80 --restart=always -v /etc/localtime:/etc/localtime interview_image