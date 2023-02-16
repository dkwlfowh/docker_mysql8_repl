#!/bin/bash
####STOP CONTAINER####
echo -e "#####################################"
echo -e "####### SELECT STOP Container #######"
echo -e "#####################################\n"

docker ps

while true; do
 echo -e "\n###### Conatiner name ##### : IF you wanna stop => exit, ALL Conteiner => all"
 read name
 if [ ${name} == "exit" ]; then
   break;
 elif [ ${name} == "all" ]; then
   docker stop $(docker ps --format={{.Names}});
   break;
 else
   docker stop ${name};
 fi
done

while true; do
 echo -e "\n###### REMOVE CONTAINER NAME ########"
 read name
 if [ ${name} == "exit" ]; then
  break;
 elif [ ${name} == "all" ]; then
  docker rm $(docker ps -a --format={{.Names}});
  break;
 else
  docker rm ${name};
 fi
done

echo -e "\n ###### DOCKER CONTAINER CEHCK ######"
docker ps

