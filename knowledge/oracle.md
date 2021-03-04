1. create tablespace

```oracle
CREATE TABLESPACE ESBDATA DATAFILE 
  '+DATADG/orcl/datafile/esbdata.dbf' SIZE 20480M AUTOEXTEND ON
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