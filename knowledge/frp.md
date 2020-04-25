[TOC]

#### linux 后台启动frp服务
```
服务端： nohup ./frps -c frps.ini >/dev/null 2>&1 &
客户端： nohup ./frpc -c frpc.ini >/dev/null 2>&1 &
```

#### linux 停止frp
```
(1)ps -aux|grep frp| grep -v grep
	[1]12345
(2)lsof -i:7000
	[1]12345
kill -9 12345
```

#### microsoft 远程桌面frp-stcp无效，必须本地远程桌面，还需设置
```
Win10远程桌面 出现 身份验证错误，要求的函数不受支持，这可能是由于CredSSP加密Oracle修正 解决方法

https://www.cnblogs.com/raswin/p/9018388.html
```