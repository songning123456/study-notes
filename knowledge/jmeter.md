#### 设置环境变量

1. jdk和jmeter两个环境变量
```
JAVA_HOME=/home/esc/apps/jdk1.8.0_181
CLASSPATH=$JAVA_HOME/lib/
PATH=$JAVA_HOME/bin:$PATH
export PATH JAVA_HOME CLASSPATH

export PATH=/home/esb/apps/apache-jmeter-5.4.1/bin:$PATH
export JMETER_HOME=/home/esc/apps/apache-jmeter-5.4.1
export CLASSPATH=$JMETER_HOME/lib/ext/ApacheJMeter_core.jar:$JMETER_HOME/lib/jorphan.jar:$CLASSPATH
export PATH=$JMETER_HOME/bin:$PATH
```

2. 测试是否生效
```
jmeter -v
```


#### 启动

1. 前台
```
jmeter -n -t PA01-Group.jmx -l PA01-Group.jtl -e -o ./report/ 
```

2. 后台
```
nohup jmeter -n -t PA01-Group.jmx -l PA01-Group.jtl -e -o ./report/ &
nohup jmeter -n -t PA01-Group.jmx -l PA01-Group.jtl -e -o ./report/ >out.log 2>&1 &
```
	
			  
#### 参考文档

[生成HTML性能测试报告](www.cnblogs.com/imyalost/p/10239317.html)


#### jmeter负载测试

master: 172.172.16.127;
slave: 172.172.16.23, 172.172.16.24;


1. 修改slave-172.172.16.23文件: jmeter.properties
```
server.rmi.ssl.disable=true
```
		
2. 修改slave-172.172.16.23文件: jmeter-server
```
RMI_HOST_DEF=-Djava.rmi.server.hostname=172.172.16.123
```
		
3. 启动slave-172.172.16.23
```
./jmeter-server
```
	
4. 所有slave(172.172.16.23, 172.172.16.24...)如上操作

5. 修改master-172.172.16.127文件: jmeter.properties
```
server.rmi.ssl.disable=true
remote_hosts=172.172.16.123:1099,172.172.16.124:1099
```
		
6. master-172.172.16.127启动
```
// -r: 远程启动slave
jmeter -n -t PA01-400-5.jmx -r -l PA01-400-5-V1.jtl -e -o ./PA01-400-5-V1/	
```	
		
