#### MySQL中的编码问题Incorrect string value: '\xE7\xA8\x8B\xE5\xBA\x8F...' for column '字段名' at row 1问题的解决方法
<https://blog.csdn.net/qq_39240270/article/details/86603715>

```mysql
ALTER TABLE TABLE_NAME CONVERT TO CHARACTER SET utf8mb4;
```


#### 查找某一数据库中包含某一字段的所有表

```mysql
SELECT * from information_schema.columns where TABLE_SCHEMA='数据库名称' and COLUMN_NAME = '字段名称';
```


#### Mysql日期Date和字符串String的互相转换（DATE_FORMAT&STR_TO_DATE）
<https://www.cnblogs.com/dehao/p/13372579.html>

Date ——> String

DATE_FORMAT(date,format)

e.g:

DATE_FORMAT(now(),"%Y-%m-%d %T") 20120-09-018 14:10:32
DATE_FORMAT(now(),"%Y-%m-%d %H:%i:%s %p") 2020-09-18 14:10:32 PM


String ——>Date

STR_TO_DATE(str,format) 

e.g

STR_TO_DATE('1992-04-12',"%Y-%m-%d") // 输出：1992-04-12（日期形式）