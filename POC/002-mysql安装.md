1. cd /home/esc
   mkdir apps && mkdir logs && mkdir tools
   
2. cd /home/esc/tools
   rz/xftp (/packages/mysql-5.7.29-el7-x86_64.tar.gz)
   
3. tar –zxvf mysql-5.7.29-el7-x86_64.tar.gz
   mv mysql-5.7.29-el7-x86_64.tar.gz mysql
   
4. cd /home/esc/logs && mkdir mysql

5. cd /home/esc/tools/mysql && mkdir data;
   // ps: 主从复制时记得设置不同的server-id
   vi mysql.cnf
        ```
        [client]
        port=3306
        socket=/home/esc/tools/mysql/mysql.sock
        [mysqld]
        port=3306
        sql_mode=STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
        init_connect='SET NAMES utf8'
        basedir=/home/esc/tools/mysql
        datadir=/home/esc/tools/mysql/data
        pid-file=/home/esc/tools/mysql/mysql.pid
        socket=/home/esc/tools/mysql/mysql.sock
        log_error=/home/esc/logs/mysql/error.log
        collation_server=utf8_general_ci
        character_set_server=utf8
        log-bin=/home/esc/logs/mysql/mysql-bin
        server-id=100
        lower_case_table_names=1
        explicit_defaults_for_timestamp=ON
        ```
        
6. cd /home/esc/tools/mysql/bin;
   ./mysqld --defaults-file=/home/esc/tools/mysql/mysql.cnf --initialize --user=esc;
   
7. ./mysqld --defaults-file=/home/esc/tools/mysql/mysql.cnf --user=esc &

8. ln -s /home/esc/tools/mysql/mysql.sock /tmp/mysql.sock

9. /home/esc/logs/mysql/error.log中获取密码;

    ```
    A temporary password is generated for root@localhost: gpuH1NGhUk!k
    ```

10. cd /home/esc/tools/mysql/bin;
    ./mysql -u root -p;
    
11. ALTER USER 'root'@'localhost' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;
    flush privileges;
    exit; 
    
12. cd /home/esc/tools/mysql/bin;
    ./mysql -u root -p
    use mysql;
    update user set host='%' where user ='root';
    ALTER USER 'root'@'%' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;
    set global max_connect_errors=1000;
    flush privileges;
    quit;
    
13 . 修改mysql.cnf
    ```html
    replicate-do-db=smartemsp_db
    binlog-do-db=smartemsp_db
    ```
 

   
   
   
   