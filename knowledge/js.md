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

#### npm镜像源设置(最好安装version=12)
```
npm config set registry https://registry.npm.taobao.org (切换至淘宝镜像)
npm get registry (查看当前镜像源)
npm config set registry https://registry.npmjs.org/ (切换至默认镜像)
npm config set sass_binary_site=https://npm.taobao.org/mirrors/node-sass (安装sass失败时补救措施)
```

#### chrome安装vue-devtools插件
```
把Vue.js Devtools_5.3.3.crx重名为Vue.js Devtools_5.3.3.zip
把Vue.js Devtools_5.3.3.zip解压到D:\ChromePlugins\目录下(D:\ChromePlugins\Vue.js Devtools_5.3.3)
chrome浏览器设置扩展程序,添加目录D:\ChromePlugins\Vue.js Devtools_5.3.3
```