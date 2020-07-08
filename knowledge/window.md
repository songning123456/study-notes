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

#### window10安装docker
```
1. 查看 任务管理器 -> 性能 -> CPU -> 虚拟化 是否启用。如果未启用，打开启用(百度)
2. 开启Hyper-V(百度)
3. 安装docker for windows
4. 修改镜像来源
    {
        "registry-mirrors": ["https://f35jtd7k.mirror.aliyuncs.com"]
    }
```