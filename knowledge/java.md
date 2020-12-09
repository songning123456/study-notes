#### cmd上运行java程序遇到的问题（找不到或无法加载主类）
```
参考博客: https://blog.csdn.net/tb_youth/article/details/87356689?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1

主要是环境变量CLASSPATH 设置错误问题 => \ 分隔符 写成了 /
```

#### Web server failed to start. Port xxxx was already in use
```
netstat -ano|findstr xxxx
taskkill -PID xxxx -F
```


#### jdk1.8下载需要登陆oracle账号解决
```
账号：1789936303@qq.com
密码：Oracle123456
```

#### 替换jar包中的某个class文件
1. 使用jd-gui工具查看具体class信息(不要使用idea查看，有可能显示信息不全 Implmentation of methods is not available)
2. 新建项目
3. Project Settings => Libraries => + => Java => 所有*.jar包
4. 新建src包 => 引入(除src/java/main) 复制原项目整个目录
5. 修改。。。
6. 项目名 => 右键 Build Module '项目名'
7. 解压原来的jar包
8. 从生成的class目录文件中copy修改的文件
9. cd 解压原来的jar包目录下
10. jar -cfM0 xxx.jar *