#!/bin/bash
source /opt/3bb/venv/bin/activate
python3 /opt/3bb/modbus/modbus_server.py --cfg_file /opt/3bb/modbus/3bb_cfg.json
deactivate
