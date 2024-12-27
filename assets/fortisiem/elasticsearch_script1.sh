#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# package installation
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch
sudo apt-get update && sudo apt-get install kibana
sudo systemctl enable kibana

# password will be printed on terminal
es_pwd="$({sleep 20; echo y;} | sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic)"
export ELASTIC_PASSWORD="$es_pwd"

TEMPFILE="$(mktemp)"
{ sleep 20; echo y; } | sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic > "$TEMPFILE"
export ELASTIC_PASSWORD="$(cat $TEMPFILE)"

# test elasticsearch
curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200

# set file descriptiors to 65535
# grant user elasticsearch permission for memory lock
# set number of threads to 4096#
# the dash in the middle means both soft and hard limit
echo "ubuntu  -  nofile  65535
ubuntu  -  memlock  unlimited
ubuntu  -  nproc  4096" >> /etc/security/limits.conf

# disable swapping
sudo swapoff -a

# disable memory lock in elasticsearch
echo "bootstrap.memory_lock: true" >> /etc/elasticsearch/elasticsearch.yml
echo "node.name: data" >> /etc/elasticsearch/elasticsearch.yml
#echo "search.remote.connect: false" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: <IP-Address>" >> /etc/elasticsearch/elasticsearch.yml

# increase virtual memory limit
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

echo "[Service]" >> /etc/systemd/system/elasticsearch.service.d/override.conf
echo "LimitMEMLOCK=infinity" >> /etc/systemd/system/elasticsearch.service.d/override.conf

reboot now
