#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Modbus Injektion
Eine Injektion ist ein Angriff bei dem unerwünschte Programmzeilen in ein System initiiert werden. Häufig ist dieser Angriff im Webumfeld, dabei wird unter anderem von SQL Injektionen und von XML Injektionen gesprochen. In diesem Fall wird ein Modbus Paket an eine im Netzwerk endeckte Schnittstelle geschickt und die Auswirkung angeschaut. Somit wird das Paket in den Datenstrom der Modbuskommunikation initiiert beziehungsweise eingeschleust.

=== Vorrausetzungen und Tools für den Angirff
Um die Injektion ausführen zu können, wird ein Gerät benötigt, das Zugriff auf das Netzwerk hat und Python für den Angriff sowie Wireshark als Analysetool installiert hat.

Zusätzlich ist die Unit ID für die Modbuskommunikation zum Herrausfinden. Das kann man entweder mit einem Man in the Middle Angriff machen oder die Anleitungen von RTU Herstellern lesen, da die Unit ID dort festgelegt sein kann. In unserem Fall ist die Unit ID 1.

Weiters ist das Framework ModBusSploit herunterzuladen. Dieses ist unter diesem Link aufzufinden: "https://github.com/C4l1b4n/ModBusSploit". Das Framework arbeitet mit Modulen, welche Angriffsvektoren auf das Protokoll Modbus TCP aufzeigen. Dabei wird nur das Modul _writeSingleCoil_ verwendet, allerdings gibt es eine weitere Anzahl von Modulen mit Diverse Injektionen sowie Denail of Service Angriffen.

=== Umsetztung - Code Injektion
Um das Framework zu starten, wird die Datei _start.py_ ausgeführt. 
```
python3 ModBusSploit-main/start.py
```
#figure(
  image("../assets/Injection/modbussploit-start.png"),
  caption: "ModBusSploit gestartet"
)

Nun kann das Modul zum Ändern des Coils und somit zur Injektion aufgerufen werden.
```
use modules/exploit/Injektion/writeSingleCoil
```
Nachfolgend werden die entsprechenden Werte für den Angriff definiert.
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
  image("../assets/Injection/modbussploit-angirff.png"),
  caption: "Injektion Angriff ausgeführt"
)

Der Verlauf kann nun auch im Wireshark betrachtet werden. Dabei ist zu sehen, dass das Angreifergerät mit der IP-Adresse 10.100.0.99 zuerst eine TCP Session mit der RTU aufbaut. Danach kann beobachtet werden, dass das maliziöse Modbuspacket verschickt wird und schlussendlich die Verbindung wieder aufgelöst wird. Somit ist der Angirff in kürzerster Zeit erfolgt und die Angreifer*in nun wieder passiv geworden.

#figure(
  image("../assets/injection/wireshark-komplette-injection.png"),
  caption: "Injektion Angriff im Wireshark"
)
