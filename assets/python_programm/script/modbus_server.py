import os

from pyModbusTCP.server import ModbusServer, DataBank
import logging
from logging.handlers import TimedRotatingFileHandler
import json
import argparse
import sys
import os
import PCA9685 as ws_hat

__version__ = "0.1.0"
__changed__ = ""
__author__ = ""
__copyright__ = ""

# DEFAULTS
host = '0.0.0.0'
port = 502
cfg_json_file = "3bb_cfg.json"

# LOGGING
default_level = logging.DEBUG

def logging_config(level, file_name, when="m", interval=5, backup_count=5):
    if level == "debug":
        log_level = logging.DEBUG
        handlers = [
            logging.StreamHandler(),
            TimedRotatingFileHandler(str(file_name),
                                       when=when,
                                       interval=interval,
                                       backupCount=backup_count
                                     )
        ]
    if level == "info":
        log_level = logging.INFO
        handlers = [
            logging.StreamHandler(),
            TimedRotatingFileHandler(str(file_name),
                                       when=when,
                                       interval=interval,
                                       backupCount=backup_count
                                     )
        ]
    if level == "silent":
        log_level = logging.INFO
        handlers = [
            TimedRotatingFileHandler(str(file_name),
                                       when=when,
                                       interval=interval,
                                       backupCount=backup_count
                                     )
        ]
    logging.basicConfig(
        level=log_level,
        format="%(asctime)s - %(levelname)s : %(message)s",
        datefmt="%m/%d/%y %H:%M:%S",
        handlers=handlers,
    )

class modBusDummyServant():
    # a dummy modbusserver to test network conectivity
    def __init__(self):
        self.holding_coils = dict()

    def do_init_servos(self, servo_definition):
        # dummy servo initialisation without i2c
        for servo_id in servo_definition:
            mod_bus_address = servo_definition[servo_id]['modBus']['holdingCoil']
            logging.info(f'init dummy servo {servo_definition[servo_id]["name"]} on coil {mod_bus_address} without i2c')
            self.holding_coils[mod_bus_address] = Servo()
            self.holding_coils[mod_bus_address].do_init(
                servo_definition[servo_id]['name'],
                servo_definition[servo_id]['gpio'],
                None)

    def update(self, address, new_value):
        logging.debug(f'update {self.holding_coils[address].name} to {new_value} msg from Servant')
        self.holding_coils[address].do_change(new_value)


class modBusServant():
    # The modbusserver for the i2c HAT
    def __init__(self):
        self.i2c = ws_hat.PCA9685(0x40)
        self.i2c.setPWMFreq(5)
        self.holding_coils = dict()

    def do_init_servos(self, servo_definition):
        # servo initialisation
        for servo_id in servo_definition:
            mod_bus_address = servo_definition[servo_id]['modBus']['holdingCoil']
            logging.info(f'init dummy servo {servo_definition[servo_id]["name"]} on coil {mod_bus_address}')
            self.holding_coils[mod_bus_address] = Servo()
            self.holding_coils[mod_bus_address].do_init(
                servo_definition[servo_id]['name'],
                servo_definition[servo_id]['gpio'],
                self.i2c)
        logging.info(self.holding_coils)

    def update(self, address, new_value):
        logging.debug(f'update {self.holding_coils[address].name} to {new_value} msg from Servant')
        self.holding_coils[address].do_change(new_value)


class Servo():
    # the servo definition for 3BB
    def __init__(self):
        super().__init__()
        self.gpio_settings = dict()
        self.mod_bus = dict()
        self.name = "dummy"
        self.i2c = None

    def do_init(self, name, gpio, i2c):
        self.name = name
        self.i2c = i2c
        self.pin = gpio['pin']
        self.pw_max = gpio['maxPw']*1000 + gpio['offset']*1000
        self.pw_min = gpio['minPw']*1000 + gpio['offset']*1000
        logging.info(f'initialising Servo {name} gpio pin {gpio["pin"]}, min PW: {self.pw_min}ms max PW:{self.pw_max}ms')

    def do_change(self, new_value):
        logging.debug(f'Servo {self.name} got new Value {new_value}')
        if new_value:
            logging.info(f'servo {self.name} switched to min')
            if self.i2c:
                self.i2c.setServoPulse (self.pin, self.pw_min)
        else:
            logging.info(f'servo {self.name} switched to max')
            if self.i2c:
                self.i2c.setServoPulse (self.pin, self.pw_max)


class ThreeDB(DataBank):
    def __init__(self):
        super().__init__()

    def connect_servant(self, servant):
        logging.info(f'connect Servant to ThreeDB Object')
        self.servant = servant

    def on_holding_registers_change(self, address, from_value, to_value, srv_info):
        logging.debug(f'holding register {address} has changed from {from_value} to {to_value} (msg from ThreeDB modbus database)')

    def on_coils_change(self, address, from_value, to_value, srv_info):
        logging.debug(f'coil {address} has changed from {from_value} to {to_value} (msg from ThreeDB modbus database)')
        self.servant.update(address, to_value)

def main():
    return_code = 0
    try:
        epilog = f"example: {sys.argv[0]}"
        parser = argparse.ArgumentParser(epilog=epilog)
        parser.add_argument('--cfg_file', default=cfg_json_file, help='Mod bus server cfg file in json format')
        parser.add_argument('-test', help='Mod bus servant without any hardware functionality', action='store_true')
        args = parser.parse_args()
        cfg_file_name = args.cfg_file
        test_only = args.test

        with open(cfg_file_name, "r") as f:
            cfg = json.load(f)

        if test_only:
            root_path = "test"
        else:
            root_path = cfg['mutex']['rootPath']

        # check for root
        if os.getuid() != 0:
            print(f'+{"":-<60}+')
            print(f'|{"YOU ARE NOT ROOT":^60}|')
            print(f'|{"Try running with sudo":^60}|')
            print(f'+{"":-<60}+')
            print(f'|{"ports lower than 1024,":^60}|')
            print(f'|{"HAT accesss and":^60}|')
            print(f'|{"access to some directories":^60}|')
            print(f'|{"may not work":^60}|')
            print(f'+{"":-<60}+')

        root_path_exist = os.path.exists(root_path)
        if not root_path_exist:
            # Create a new directory because it does not exist
            os.makedirs(root_path)
            print(f"--> {root_path} is created!")

        logging_cfg = cfg['server']['logging']
        log_file_name = logging_cfg['fileName']
        log_file = os.path.join(root_path, log_file_name)
        if test_only:
            log_level = "debug"
        else:
            log_level = logging_cfg['level']
        log_rotate_when = logging_cfg['when']
        log_rotate_interval = logging_cfg['interval']
        log_rotate_count = logging_cfg['backupCount']
        print(f'+{"":-<60}+')
        print(f'|{" config file: " + cfg_file_name:<60}|')
        print(f'|{" log file:    " + log_file:<60}|')
        print(f'|{" log Level:   " + log_level:<60}|')
        print(f'+{"":-<60}+')

        logging_config(log_level, log_file, log_rotate_when, log_rotate_interval, log_rotate_count)

        server_host = cfg["server"]["host"]
        server_port = cfg['server']['port']
        print(f'+{"":-<60}+')
        print(f'|{f" Server IP:   " + f"{server_host}":60}|')
        print(f'|{f" Server Port: " + f"{server_port}":60}|')
        print(f'+{"":-<60}+')
        if test_only:
            mod_bus_servant = modBusDummyServant()
            logging.info('server is running in test mode')
        else:
            mod_bus_servant = modBusServant()

        mod_bus_servant.do_init_servos(cfg['trackSwitches'])

        server = ModbusServer(host=server_host, port=server_port, data_bank=ThreeDB())
        logging.info(f'starting modbusserver {server_host}:{server_port}')
        server.data_bank.connect_servant(mod_bus_servant)
        server.start()

    except Exception as err:
        return_code = 1
        print(f"err: {err}")

if __name__ == '__main__':
    sys.exit(main())
