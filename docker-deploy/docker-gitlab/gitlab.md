mkdir docker-gitlab-dir
cd docker-gitlab-dir
docker pull gitlab/gitlab-ce
mkdir etc
mkdir log
mkdir data
docker run --name gitlab_container -d -p 8443:443 -p 880:80 --restart always -v $PWD/etc:/etc/gitlab -v $PWD/log:/var/log/gitlab -v $PWD/data:/var/opt/gitlab gitlab/gitlab-ce
// ...暂未完成