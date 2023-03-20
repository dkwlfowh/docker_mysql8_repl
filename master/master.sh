#!/bin/bash
set -e
sed -i -e '2 i\server_id=1' /etc/my.cnf
/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf --user=mysql &
echo "LEE"
## create user
sleep 10
/mysql/bin/mysql -uroot -p'root' -e "create user 'repl'@'172.19.0.%' identified with mysql_native_password by 'repl'"
/mysql/bin/mysql -uroot -p'root' -e "grant all on *.* to 'repl'@'172.19.0.%'"
/mysql/bin/mysql -uroot -p'root' -e "create user 'root'@'%' identified with mysql_native_password by 'root'"
/mysql/bin/mysql -uroot -p'root' -e "grant all on *.* to 'root'@'%'"

