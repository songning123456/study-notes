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


#### VMware虚拟机安装Windows7
<https://blog.csdn.net/weixin_43465312/article/details/92662519>

Windows7产品密钥：237XB-GDJ7B-MV8MH-98QJM-24367


#### win7系统电脑如何设置固定IP地址
<https://jingyan.baidu.com/article/fec4bce21c4ebab2618d8bb2.html>


#### win7系统电脑如何设置密码
<http://www.windows7en.com/jiaocheng/45719.html>


#### win7系统电脑如何打开远程连接
<http://www.pc0359.cn/article/win7/69175.html>


#### Loadrunner11.0安装与简单使用
<https://www.cnblogs.com/chenzhazha/p/9897494.html>


#### 安装loadrunner时出现”命令行选项语法错误键入命令 \?获得帮助“的解决方法
<https://www.cnblogs.com/lelexiong/p/8974149.html>


#### window版nginx停止
1. tasklist /fi "magename eq nginx.exe"
2. taskkill /f /t /im nginx.exe

