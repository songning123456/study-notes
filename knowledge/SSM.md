#### springboot部署jar包读取配置文件

<https://blog.csdn.net/wangchaox123/article/details/99191001>

[注] 已测试 java -jar -Dspring.config.location=/.../.../application.yml(全路径) xxx.jar   


# Springboot配置文件优先级

1. 工程目录: ./config/
2. 工程目录: ./
3. classpath:/config/
4. classpath:/

# 配置日志

```
logging.config=config/log4j2.xml
```

```
logging.config=classpath:config/log4j2.xml
```

# 文件编译成jar包

```
cd ./xxx/
jar -cfM0 xxx.jar *
```

