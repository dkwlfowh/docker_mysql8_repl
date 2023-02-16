#!/bin/bash
#### ENV
port=3305

echo "################ HOW MANY SERVER ##############"
echo "COUNT: "
read count

echo "#################### BUILD DOCKER IMAGES #####################"
docker-compose -f /root/docker_mysql8_repl/docker-compose.yml build


echo "#################### Network Create #####################"
check_net=`docker network ls | grep 'lee' | awk '{print $2}'`

if [ $check_net == "lee" ]; then
  echo 'exists Network'
else
  docker network create --gateway 172.19.0.1 --subnet 172.19.0.0/24 lee
fi


echo "#################### CREATE MASTER DATABASE ####################"
echo "Master IP:172.16.0.11 / Port 3306:3306"
docker run -itd --net lee --ip 172.19.0.11 -p 3306:3306 --name my8_master leeyunhyeong/master
docker exec my8_master /root/master.sh


echo "#################### CREATE SLAVE DATABASE ####################"

for cnt in `seq 2 $count`;
do
 echo -e "\n Slave IP:172.16.0.1${cnt} / Port `expr $port + $cnt`:3306"
 docker run -itd --net lee --ip 172.19.0.1${cnt} -p `expr $port + $cnt`:3306 --name my8_slave`expr ${cnt} - 1` leeyunhyeong/slave
 docker exec my8_slave`expr ${cnt} - 1` /root/slave.sh $cnt
done

docker ps

echo -e "\n################### Slave Database Replicaiton Check ##################"

for cnt in `seq 2 $count`;
do
 echo -e "\n Current Container =  my8_slave`expr ${cnt} - 1`"
 docker exec my8_slave`expr ${cnt} - 1` /mysql/bin/mysql -uroot -proot -e "show slave status\G" | grep "Master_Host\|Slave_IO_Running\|Slave_SQL_Running\|Last_IO_Error\|Last_SQL_Error"
done
