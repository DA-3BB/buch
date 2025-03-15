#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Modbus Injection
Eine Injection ist ein Angriff bei dem unerwünschte Programmzeilen in ein System iniziert werden. Häufig ist dieser Angriff im Webumfeld, dabei wird von unter anderem von SQL Injections und von XML Injections gesprochen. In diesem Fall wird ein Modbus Paket an eine im Netzwerk endeckte Schnittstelle geschickt und die auswirkung angeschaut. Somit wird das Paket in den Datenstrom der Modbuskommunikation injected beziehungsweise eingeschleust.
=== Vorrausetztungen und Tools für den Angirff
Um die Injection ausführen zu können wird ein Gerät bentötigt, das Zugriff auf das Netzwerk hat und python für den Angriff selbst sowie Wireshark als Analysetool installiert hat.

Zusätzlich ist die Unit ID für die Modbuskommunikation zum herrausfinden. Das kann man entweder mit einem Man in the Middle Angriff machen oder die Anleitungen von RTU Herstellern lesen, da die Unit ID dort festgelegt sein kann. In unserem Fall ist die Unit ID 1.

Weiters ist das Framework ModBusSploit herunterzuladen. Dieses ist unter diesem Link aufzufinden: "https://github.com/C4l1b4n/ModBusSploit". Das Framework arbeitet mit Modulen, welche Angriffsvektoren auf das Protokoll Modbus TCP aufgreifen. Hier wird dabei nur das Modul _writeSingleCoil_ verwendet, allerdings gibt es eine weitere Anzahl von Modulen mit dem Diverse Injections als auch Denail of Service Angriffe ausgeführt werden können.

=== Umsetztung - Code Injection
Um das Framework zu starten wird die Datei _start.py_ ausgeführt. 
```
python3 ModBusSploit-main/start.py
```
#figure(
  image("../assets/injection/modbussploit-start.png"),
  caption: "ModBusSploit gestartet"
)

Nun kann das Modul zum ändern des Coils und somit zur Injection aufgerufen werden.
```
use modules/exploit/injection/writeSingleCoil
```
Nachfolgend werden die entsprechenden Werte für den Angriff definiert werden.
```
set address 10.100.0.11
set register 4
set id 1
set value ON
```
Um schlussendlich den Angriff selbst ausführen zu können:
```
exploit
```
#figure(
  image("../assets/injection/modbussploit-angirff.png"),
  caption: "Injection Angriff ausgeführt"
)

Der Verlauf kann nun auch im Wireshark betrachtet werden. Dabei ist zu sehen, dass das Angreiffergerät mit der IP-Adresse 10.100.0.99 zuerst eine TCP Session mit der RTU aufbaut, danachdas maliziöse Modbuspacket und schlussendlich diese Verbindung wieder auflässt. Somit ist der Angirff in kürzerster Zeit erfolgt und die Angreiferin nun wieder passiv geworden.

#figure(
  image("../assets/injection/wireshark-komplette-injection.png"),
  caption: "Injection Angriff im Wireshark"
)
