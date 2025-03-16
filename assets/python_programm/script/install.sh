#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "Please run this script as root or using sudo!"
  exit
fi


if [ -d /opt/3bb/modbus ]; then
  echo "3bb pi modbus already installed use update.sh" 
exit 1
fi

mkdir -p /opt/3bb/modbus

cp modbus_server.py /opt/3bb/modbus
cp modbus_client.py /opt/3bb/modbus
cp PCA9685.py /opt/3bb/modbus
cp 3bb_cfg.json /opt/3bb/modbus
cp 3bb-start-raspberry-modbusserver-for-trackswitching.sh /usr/local/bin/
cp 3bb-test-client.sh /usr/local/bin/
cp mbus_track_switch.service /etc/systemd/system
systemctl daemon-reload
