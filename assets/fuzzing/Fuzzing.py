import argparse
from boofuzz import *

def FuzzWriteCoil(session: Session):
    s_initialize("fuzz_modbus_write_coil")
    s_word(0x0001, name='Transaction ID', fuzzable=True, endian=BIG_ENDIAN)
    s_word(0x0000, name='Protocol ID', fuzzable=False, endian=BIG_ENDIAN)
    s_word(0x0008, name='Length', fuzzable=False, endian=BIG_ENDIAN)
    s_byte(0x01, name='Unit Identifier', fuzzable=False, endian=BIG_ENDIAN)

    s_byte(15, name='Function Code for Write Coil', fuzzable=False, endian=BIG_ENDIAN)
    s_word(00, name='Reference Number', fuzzable=False, endian=BIG_ENDIAN)
    s_word(0x0008, name='Bit Count', fuzzable=False, endian=BIG_ENDIAN)
    s_byte(0x0001, name='Byte Count', fuzzable=False, endian=BIG_ENDIAN)
    s_byte(0x0000, name='Data', fuzzable=True, endian=BIG_ENDIAN)

    session.connect(s_get("fuzz_modbus_write_coil"))
    session.fuzz()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Modbus Fuzzer for Write_Coils by Marlene Reder / HTL Rennweg")
    parser.add_argument("-a", "--address", help="IP Adresse des Tagrets; default = 10.100.0.11", default="10.100.0.11")
    args = parser.parse_args()
    
    target = Target(connection=TCPSocketConnection(host=args.address, port=502))
    session = Session(target=target)

    FuzzWriteCoil(session)