#### VSCode插件离线安装方法

1. 把下载下来的离线安装包拷贝到VSCode的安装目录下的/bin目录下，比如我的VSCode安装在D:\Microsoft VS Code，因此这里我应该拷贝到D:\Microsoft VS Code\bin这个目录下。

2. 在/bin目录下右键点击在此处打开命令窗口，输入命令，最后面的参数换成你下载的插件离线安装包的名字即可：

```
code --install-extension yzhang.markdown-all-in-one-1.4.0.vsix
```