#!/bin/bash

echo -e "
\e[42mBriefly introduction:\e[0m
- The script is used to setup monitoring tool of your Avail Light node.
- All collected metrics will be output Prometheus and Grafana
"


cd $HOME
git clone https://github.com/viennguyenbkdn/Avail_Monitoring_lightnode;
cd $HOME/Avail_Monitoring_lightnode;
sleep 1;

HOST_IP=$(curl -s -4 ipconfig.io/ip);
sleep 1;
sed -i.bak -e "s/^HOST_IP=.*/HOST_IP=$HOST_IP/g" $HOME/Avail_Monitoring_lightnode/.env
sleep 1;

docker compose up -d;
sleep 15;

docker compose down;
sleep 15;

chmod -R 777 $HOME/Avail_Monitoring_lightnode/*
sleep 3;
docker compose up -d;
sleep 3;

PORT_GRAFANA=$(sed -n 's/^PORT_GRAFANA=\(.*\)/\1/p' $HOME/Avail_Monitoring_lightnode/.env) 


echo -e "\n\033[0;32mYou have finished installation of monitoring DA node\033[0m"
echo -e "\nLogin Grafana link: \033[0;31mhttp://$HOST_IP:$PORT_GRAFANA\033[0m"
