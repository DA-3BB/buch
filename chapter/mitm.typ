#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Man in the Middle Angriff
Druch einen Man in the Middle (MITM) Angriff fängt man die Kommunikation zwischen zwei Geräten ab und schaltet sich in die Mitte, sodass alle folgenden Pakete über einen selbst zuerst geschickt werden um diese dann entweder "nur" mitzulesen oder gegebenenfalls auch zu manipulieren. \

Eine MITM Angriff kann auf unterschiedliche Art und weiße passieren. In diesem Fall wird ARP Spoofing oder ARP Request Poisoning verwendet um den Datenverkehr abzufangen. Dabei werden ARP Request mit der IP Adresse des zu angreifenden Geräts in LAN gesannt um dem MAC-Adress-Table zu ändern. Ziel ist es dabei die eigene MAC-Adresse mit der IP-Adresse von einem anderen Gerät im Netzwerk zu assozieren. \
https://www.ionos.de/digitalguide/server/sicherheit/arp-spoofing-angriffe-aus-dem-internen-netzwerk/ \
Dadurch, dass Modbus alle Daten ohne Authentifizierung im Plaintext verschickt, kann kann der Datenverkehr sofort nach einem MITM Angriff mit dem Wireshark mitgelesen werden. \

=== Vorraussetzungen und Tools für den MITM Angriff
Um den Man in the Middle Angriff durchführen zu können wird zuallererst Zugang zum LAN benötigt. Dies kann durch eine offene Schnitstelle, z.B.: einem Port an einem Switch oder einem komprimierten Netzwerkgerät erfolgen. \

Weiters wird auf dem Angreiger Gerät eine Kali-Linux Distribution in einer VM oder als Hostbetriebssystem benötigt. Da für den Angriff die vorinstallierten Tools Ettercap, Etterfilter und Wireshark verwendet werden. \

==== Ettercap
Ettercap ist ein Multifunktionstool mit dessen Hilfe Man in the Middle Angriffe durchgeführt werden können um Sniffing, Filtering und Einspeisung von Malizösen Daten zu ereichen. Ettercap wird im @umsetztung-mitm mit folgenden Optionen verwendet. \  

#figure(
  table(
    columns: 3,
    table.header(
      [*Option*], [*Parameter*], [*Funktion*],
    ),
    [-T], [], [Für eine reines Textinferface.],
    [-s], [\'lq\'], [Gibt eine Liste mit allen Hosts im Netzwerk zurück.],
    [-F], [\<File>], [Ein Filter für den Traffic kann angegeben werden.],
    [-M], [arp], [Man in the Middle Angriff, in diesem Fall ARP Spoofing.]
    ),
    caption: "Verwendete Optionen von Ettercap",
)
Weiter können mithilfe von Schrägstrichen die Ziele nach MAC-Adresse, IP-Adresse und Port spefizieziert angegeben werden.
```
/MAC/IPs/PORT
``` 
Ein Beispiel für eine spezifische IP-Adresse und ohne spezifischen Port und ohne spezifischer MAC-Adresse ist:
```
//10.100.0.1/ 
```
Ein Beispiel für einen spezifischen Port aber ohne spezifische MAC und IP-Adresse ist:
```
///502
```

==== Etterfilter
Etterfilter ist eine erweiterte Funktion von Ettercap mihilfe dessen Filter für Ettercap compiled werden können. Hierbei werden folgende Optionen _-o_ verwendet um die Ausgabedatei zu spezifizieren.

==== Wireshark
Wireshark wird hierbei zusätzlich verwendet um den Traffic beim Angriff genauer zu inspizieren und mitzuverfolgen. 

=== Umsetztung - Man in the Middle Angriff <umsetztung-mitm>
Bevor der Angriff gestartet werden wird geschaut ob sich die zu angreifenden Ziele im Netzwerk befinden. Dabei wird auf in der Kali-Linux folgender befehlt ausgeführt:

#htl3r.code(caption: [Scan nach Hosts im LAN])[
  ```bash
  ettercap -T -s 'lq'
  ```
]

#htl3r.info("output screenshot wird noch ergänzt")

Nun da die bekannten IP Adressen beim Scan aufgelistet wurden kann mit dem MITM Angriff und somit dem ARP Spoofing begonnen werden. Dabei wird im ersten Schritt noch nicht modifiziert sonder nur abgefangen und weitergeleitet.

#htl3r.code(caption: [Befehl für MITM durch ARP Spoofing])[
  ```bash
  ettercap -T -M arp //10.100.0.1/ //10.100.0.11/
  ```
]

#figure(
  image("../assets/mitm/arp-posioning-not-corr-without-filter.png"),
  caption: "MITM: ARP Spoofing"
)

#htl3r.code(caption: [Befehlt MITM durch ARP Spoofing mit filter])[
  ```bash
  ettercap -T -F coil-true-to-false.ef -M arp //10.100.0.1/ //10.100.0.11/
  ```
]

Das ARP Spoofing kann auch mittels Wireshark angeschaut werden. Hier zu betrachten ist der erste Teil des ARP Spoofing indem das Kali-Linux Gerät in diesemfall die _VMware_2f:2c..._ nach den MAC-Adressen zu den zugehörigen IP-Adressen aus dem ettercap Befehl fragt. Dabei Antworten die Geräte, genauer gesagt die SPS und die RTU, die die IP-Adressen 10.100.0.1 und 10.100.0.11 besitzen.

#figure(
image("../assets/mitm/wireshark-arp-spoofing_teil1.png"),
  caption: "ARP Request Posioning"
)

Im nächsten Schritt sendet die Kali-Linux-VM ARP Antworten an das jeweilg andere Gerät um vorzustäuschen die IP-Adresse terminiert bei einem selbst. 

#figure(
image("../assets/mitm/wireshark-arp-spoofing_teil2.png"),
  caption: "ARP Request Posioning"
)

Nun werden wie in @spooferfolg gezeigt die Modbuspackete über den Angreifer geleitet und der Angriff war somit erfolgreich.

#figure(
image("../assets/mitm/wireshark_mitm.png"),
  caption: "Wiresharkauszug von einem erfolgreichen MITM Angriff"
)<spooferfolg>

Um den Datenstrom nun nicht nur mitlesen zu können sondern auch ihn auch zu verändern wird ein Filter erstellt. Dieser beeinhaltet eine Abfrage nach einem Modbus Paket welches einen Coil auf _TRUE_ setzt und ändert den Inhalt sodass der Coil _FALSE_ bleibt.

#htl3r.code-file(lang: "c", text: read("../assets/mitm/coil-true-to-false.filter"), caption: "Filter für eine Coiländerung ")

Damit der Filter bei Ettercap angegeben werden kann muss er noch in eine Binärdatei umgewandelt werden. Dies wird mit dem Tool Etterfilter erreicht indem die vorhererstellte Filterdatei und ein Ausgabefile angegeben werden.

#htl3r.code(caption: [Befehl Etterfilter generieren])[
  ```bash
  etterfilter /usr/share/ettercap/3bb/coil-true-false.filter -o coil-true-to-false.ef
  ```
]

#figure(
  image("../assets/mitm/terminal-create-filter.png"),
  caption: "Etterfilter generieren"
)

Nun kann der MITM Angriff erneut mit dem Filter ausgeführt werden.

#htl3r.code(caption: [Befehl für MITM durch ARP Spoofing mit einem Filter])[
  ```bash
  ettercap -T -F coil-true-false.filter -M arp //10.100.0.1/ //10.100.0.11/
  ```
]

#figure(
  image("../assets/mitm/arp-posioning-not-corr.png"),
  caption: "MITM durch ARP Spoofing mit einem Filter"
)

Im Wireshark kann man nun beobachten, dass alle Modbus Packete mit einem _Write Single Coil_ Funktionscode alle als Datenwert _FALSE_ beziehungsweise 0 haben.

#figure(
  image("../assets/mitm/mitm-coil-false.png"),
  caption: "MITM durch ARP Spoofing mit einem Filter"
)

=== Quellen --> irgendwo anders hin???
https://www.geeksforgeeks.org/ettercap-sniffing-and-spoofing/ \
https://charlesreid1.com/wiki/Ettercap \
PDF