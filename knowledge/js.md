#### 关于webStorm node -v 不是内部或外部命令解决方法
```
首先需要安装node.js，安装完成后配置环境变量。在cmd窗口中输入node -v检查是否配置成功！
cmd窗口成功后在WebStorm中启动终端输入node -v仍然不是内部或外部命令。
首先在File --setting中配置!
***最重要的是以管理员方式启动WebStorm才可以使用终端！！！
以普通用户的方式打开WebStorm无法使用终端执行node命令！！！***
```

#### 如何打开项目前端页面
```
 npm run build
 http-server dist
 chrome -> '生成的ip' + '/index.html'
 
 OR
 
 npm run build
 git commit & push
 chrome -> https://songning123456.github.io/blog-front/dist/#/
```