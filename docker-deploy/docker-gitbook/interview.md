cd /root/docker-interview
vim Dockerfile
    FROM nginx
    WORKDIR /usr/share/nginx/html
    ADD . /usr/share/nginx/html
    EXPOSE 80
git clone https://github.com/songning123456/interview-book.git
mv ./interview-book/_book/ .
rm -rf interview-book/
cp Dockerfile ./_book/
cd ./_book/
docker build -t interview_image -f Dockerfile .
docker run --name interview_container -d -p 8040:80 --restart=always -v /etc/localtime:/etc/localtime interview_image