#### MySQL中的编码问题Incorrect string value: '\xE7\xA8\x8B\xE5\xBA\x8F...' for column '字段名' at row 1问题的解决方法
<https://blog.csdn.net/qq_39240270/article/details/86603715>

```mysql
ALTER TABLE TABLE_NAME CONVERT TO CHARACTER SET utf8mb4;
```


#### 查找某一数据库中包含某一字段的所有表

```mysql
SELECT * from information_schema.columns where TABLE_SCHEMA='数据库名称' and COLUMN_NAME = '字段名称';
```