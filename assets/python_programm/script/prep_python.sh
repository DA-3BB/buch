#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "Please run this script as root or using sudo!"
  exit
fi


if [ -d /opt/3bb/modbus ]; then
  echo "3bb pi modbus already installed use update.sh"
  echo "if you want to update python venv -->"
  echo "sudo -i source /opt/3bb/venv/bin/activate
pip3 install pyModbusTCP
pip3 install RPi.GPIO
deactivate"
  exit 1
fi

apt-get install python3-full
sudo apt-get install python3-pip
sudo apt-get install python3-smbus

mkdir -p /opt/3bb/modbus
python3 -m venv --system-site-packages /opt/3bb/venv
source /opt/3bb/venv/bin/activate
pip3 install pyModbusTCP
pip3 install RPi.GPIO
deactivate

