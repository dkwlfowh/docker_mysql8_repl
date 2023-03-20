#!/bin/bash
set -e
sed -i -e '2 i\server_id=$1' /etc/my.cnf
sed -i -e '2 i\read_only=1' /etc/my.cnf
rm -rf /data/data/auto.cnf
/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf --user=mysql &

### create user
sleep 10

/mysql/bin/mysql -uroot -p'root' -e "create user 'repl'@'172.19.0.%' identified with mysql_native_password by 'repl'"
/mysql/bin/mysql -uroot -p'root' -e "grant all on *.* to 'repl'@'172.19.0.%'"
/mysql/bin/mysql -uroot -p'root' -e "create user 'root'@'%' identified with mysql_native_password by 'root'"
/mysql/bin/mysql -uroot -p'root' -e "grant all on *.* to 'root'@'%'"

## get  status
master_log_file=`/mysql/bin/mysql -uroot -p'root' -h 172.19.0.11 -e"show master status\G" | grep mysql-bin`
re="[a-z]*-bin.[0-9]*"

if [[ ${master_log_file} =~ $re ]];then
    master_log_file=${BASH_REMATCH[0]}
fi

master_log_pos=`/mysql/bin/mysql -uroot -p'root' -h 172.19.0.11 -e"show master  status\G" | grep Position`

re="[0-9]+"

if [[ ${master_log_pos} =~ $re ]];then
    master_log_pos=${BASH_REMATCH[0]}
fi

query="change master to master_host='172.19.0.11', master_user='repl', master_password='repl', master_log_file='${master_log_file}', master_log_pos=${master_log_pos}, master_port=3306"

/mysql/bin/mysql -uroot -p'root'  -e "${query}"
/mysql/bin/mysql -uroot -p'root'  -e "start slave"
/bin/bash

exit;
