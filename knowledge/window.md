[TOC]

#### window关闭资源管理器黑屏
```
ctrl+alt+delete
任务管理器 新建任务
explorer.exe
```

#### 修改window host文件(刷新)
```
ipconfig /flushdns
```

#### window10安装docker(专业版/企业版)
```
1. 查看 任务管理器 -> 性能 -> CPU -> 虚拟化 是否启用。如果未启用，打开启用(百度)
2. 开启Hyper-V(百度)
3. 安装docker for windows
4. 修改镜像来源
    {
        "registry-mirrors": ["https://f35jtd7k.mirror.aliyuncs.com"]
    }
```

#### window10安装docker(家庭版)
```
https://www.cnblogs.com/jimmyshan-study/p/11161428.html
https://blog.csdn.net/Dandelion_drq/article/details/89600329
https://www.cnblogs.com/wangwenhui/p/11808488.html
```

```
* 镜像加速
docker-machine ssh default
sudo cat /var/lib/boot2docker/profile
sudo sed -i "s|EXTRA_ARGS='|EXTRA_ARGS='--registry-mirror=https://3laho3y3.mirror.aliyuncs.com |g"
exit
docker-machine restart default
docker info
```


#### window安装VMware
<https://blog.csdn.net/Fly_1213/article/details/90897738>

