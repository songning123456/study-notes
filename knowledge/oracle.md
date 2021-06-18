1. create tablespace

```oracle
CREATE TABLESPACE ESBDATA DATAFILE 
  '/home/esc/.../esbdata.dbf' SIZE 20480M AUTOEXTEND ON
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;
```

2. create users

```oracle
--创建ESBDATA用户并授权
create user esbdata identified by esbdata
default tablespace esbdata 
temporary tablespace temp 
quota unlimited on esbdata;

--password expire;
grant create procedure to esbdata with admin option;
grant create sequence to esbdata;
grant create session to esbdata;
grant create synonym to esbdata;
grant create table to esbdata;
grant create trigger to esbdata;
grant create type to esbdata;
grant create view to esbdata;

grant select on V_$SQLAREA to esbdata;
grant select on V_$SESSION to esbdata;
grant select on V_$LOCKED_OBJECT to esbdata;
grant select on V_$PARAMETER to esbdata;
grant select on V_$PROCESS to esbdata;
grant select on V_$RECOVERY_FILE_DEST to esbdata;
grant select on DBA_FREE_SPACE to esbdata;
grant select on DBA_DATA_FILES to esbdata;
```

3. back(删除user和tablespace)

```oracle
drop user esbdata cascade;
drop tablespace ESBDATA including contents and datafiles;
```

4. 进入oracle

```oracle
sqlplus / as sysdba
```

5. oracle命令行运行oracle文件

```oracle
SQL > @/.../.../xxx.sql
```


#### 导出某用户的数据库

exp username/password@服务名 file=存储dmp文件地址 log=存储log文件地址 owner=要导出的用户名

exp esb_xxljob/esb_xxljob@172.172.32.118:1521/esbdb file=/home/oracle/export/esb_xxljob.dmp log=/home/oracle/export/esb_xxljob.log owner=esb_xxljob

exp esb_smartemsp/esb_smartemsp@172.172.32.118:1521/esbdb file=/home/oracle/export/esb_smartemsp.dmp log=/home/oracle/export/esb_smartemsp.log owner=esb_smartemsp

exp esb_apolloconfig/esb_apolloconfig@172.172.32.118:1521/esbdb file=/home/oracle/export/esb_apolloconfig.dmp log=/home/oracle/export/esb_apolloconfig.log owner=esb_apolloconfig

exp esb_apolloportal/esb_apolloportal@172.172.32.118:1521/esbdb file=/home/oracle/export/esb_apolloportal.dmp log=/home/oracle/export/esb_apolloportal.log owner=esb_apolloportal
	
	
#### 导出某用户的数据库的某张表

exp username/password@服务名 tables=表名 file=存储dmp文件地址 log=存储log文件地址 owner=要导出的用户名
	
#### 导出某用户的整个数据库

exp username/password@服务名 file=存储dmp文件地址 log=存储log文件地址
	
#### 导入表到库

imp esb_xxljob/esb_xxljob@172.172.32.118:1521/esbdb BUFFER=64000 file=/home/oracle/export/esb_xxljob.dmp ignore=y full=y

imp esb_smartemsp/esb_smartemsp@172.172.32.118:1521/esbdb BUFFER=64000 file=/home/oracle/export/esb_smartemsp.dmp ignore=y full=y

imp esb_apolloconfig/esb_apolloconfig@172.172.32.118:1521/esbdb BUFFER=64000 file=/home/oracle/export/esb_apolloconfig.dmp ignore=y full=y

imp esb_apolloportal/esb_apolloportal@172.172.32.118:1521/esbdb BUFFER=64000 file=/home/oracle/export/esb_apolloportal.dmp ignore=y full=y

ignore=y: 忽略创建错误，继续后面的操作;
full=y: 导入文件的全部内容