#!/bin/bash

[[ $EUID -ne 0 ]] && echo "This script must be run as root. use command: sudo ./zabbix.sh" && exit 1

ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')

#echo "Cloning Git hub, please wait" && git clone https://github.com/zabbix/zabbix-docker.git

#sleep 2

#cd zabbix-docker

docker-compose -f docker-compose_v3_ubuntu_mysql_latest.yaml up -d

sleep 2

sudo docker update --restart unless-stopped zabbix-docker_mysql-server_1 && sudo docker update --restart unless-stopped zabbix-docker_db_data_mysql_1 && sudo docker update --restart unless-stopped zabbix-docker_zabbix-server_1 && sudo docker update --restart unless-stopped zabbix-docker_zabbix-web-nginx-mysql_1

sleep 2

sudo docker run --name zabbix-agent -p 10050:10050 -e ZBX_HOSTNAME="zabbix_agent" -e ZBX_SERVER_HOST="172.17.0.1" --restart=unless-stopped -d zabbix/zabbix-agent:latest

echo "Setting up Zabbix, this will take about 3 minutes. please be patient!!!" && sleep 3m



echo "all done, login at http://$ip:80 with the username:Admin & password:zabbix. Once in navaiagte to hosts on the left hand side and click on zabbix-server and then configuration then change ip from 172.0.0.1 to $ip"


#Creating zabbix-docker_mysql-server_1  ... done
#Creating zabbix-docker_db_data_mysql_1 ... done
#Creating zabbix-docker_zabbix-server_1 ... done
#Creating zabbix-docker_zabbix-web-nginx-mysql_1
