from pyModbusTCP.client import ModbusClient
import logging
import json
import argparse
import sys
import time


__version__ = "0.1.0"
__changed__ = ""
__author__ = ""
__copyright__ = ""

# DEFAULTS
host = '0.0.0.0'
port = 502
cfg_json_file = "3bb_cfg.json"

wait_cycle_send = 1
wait_cycle_read = 3

def main():
    return_code = 0
    try:
        epilog = f"example: {sys.argv[0]}"
        parser = argparse.ArgumentParser(epilog=epilog)
        parser.add_argument('--cfg_file', default=cfg_json_file, help='Mod bus cfg file in json format')
        args = parser.parse_args()
        cfg_file_name = args.cfg_file

        print(f'+{"":-<60}+')
        print(f'|{" config file: " + cfg_file_name:<60}|')
        print(f'+{"":-<60}+')

        with open(cfg_file_name, "r") as f:
            cfg = json.load(f)
        server_host = cfg["client"]["server"]
        server_port = cfg['client']['port']
        print(f'+{"":-<60}+')
        print(f'|{f" Server IP:   " + f"{server_host}":60}|')
        print(f'|{f" Server Port: " + f"{server_port}":60}|')
        print(f'+{"":-<60}+')

        client = ModbusClient(host=server_host, port=server_port, auto_open=True)
        while True:
            test_value = True
            while True:
                for servo in cfg['trackSwitches']:
                    time.sleep(wait_cycle_send)
                    print(f"sending {test_value} to {cfg['trackSwitches'][str(servo)]['name']}")
                    client.write_single_coil(int(servo), test_value)
                get_coils = client.read_coils(1, len(cfg['trackSwitches']))
                print(get_coils)
                if not get_coils:
                    print(f"Nothing received from {server_host}:{server_port}!")
                else:
                    print(f"holding_coils (on {server_host}:{server_port}):")
                    print(get_coils)
                for sleeper in reversed(range(wait_cycle_read)):
                    sys.stdout.write(f"sleep {sleeper}")
                    sys.stdout.write("\r")
                    sys.stdout.flush()
                    time.sleep(1)
                if test_value:
                    test_value = False
                else:
                    test_value = True


    except (OSError, RuntimeError) as err:
        return_code = 1
        print(f"err: {err}")

if __name__ == '__main__':
    sys.exit(main())
