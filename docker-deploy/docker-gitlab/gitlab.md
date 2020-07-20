mkdir docker-gitlab-dir
cd docker-gitlab-dir
docker pull beginor/gitlab-ce:11.0.1-ce.0
mkdir etc
mkdir log
mkdir data
docker run --name gitlab_container -d --hostname 122.511.193.191 -p 8443:443 -p 880:80 --privileged=true --restart unless-stopped -v $PWD/etc:/etc/gitlab -v $PWD/log:/var/log/gitlab -v $PWD/data:/var/opt/gitlab beginor/gitlab-ce:11.0.1-ce.0
vim etc/gitlab.rb
```
external_url 'http://122.151.193.191'
```
// vim data/gitlab-rails/etc/gitlab.yml