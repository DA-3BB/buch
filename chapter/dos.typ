#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Esther Lina Mayer")

== Denial of Service
=== Theoretische Grundlagen
Ein Denial of Service-Angriff (DoS-Angriff) ist eine Attacke auf die Verfügbarkeit eines Services auf einem Gerät. Hierbei möchte ein Angreifer die
normale Funktionalität eines Services unterbrechen beziehungsweise behindern, indem er die Dienste auf dem Computer mit Anfragen überlädt. Ein DoS wird von einem Gerät aus gestartet - werden mehrere verwendet (z.B. aus einem Botnet), dann spricht man von einem Distributed Denial of Service-Angriff (DDoS-Angriff).

DoS-Angriffe sind effektiv - auch gegen starke Ziele. Sie können einfach und ohne großen Aufwand ausgeführt werden. Angreifer überfluten ihr Ziel mit Massen an Paketen, die die Kapazität des Geräts überfordern, welches so neuen Nutzern den Zugang zu Services verweigern und bestehende Verbindungen verlangsamt.

=== Slowloris
Slowloris ist ein Tool, welches speziell für Angriffe auf Webserver geschrieben wurde. Es öffnet eine Vielzahl an HTTP(S)-Verbindungen und versucht, diese so lange wie möglich offen zu halten. Ein großer Vorteil des Tools ist es, dass es kaum Netzwerkressourcen benötigt.

==== Testen der Anfälligkeit auf Slowloris
Das Tool nmap, welches für die Port-Scans im Kapitel "Port-Scanning" bereits installiert wurde, besitzt ein eingebautes Script#footnote("https://nmap.org/nsedoc/scripts/http-slowloris.html"), welches die Anfälligkeit eines Servers auf einen möglichen Slowloris-Angriff testet.

Hierfür kann die Option `--script http-slowloris` verwendet werden, um das Skript auszuführen. Weiters empfiehlt nmap die Verwendung von `--max-parallelism 400`, um die Aggressivität des Skriptes zu erhöhen. Diese Option legt die maximale Anzahl an zeitgleichen Verbindungen fest. Der gesamte Befehl lautet:

`nmap --script http-slowloris --max-parallelism 400 10.100.0.1`

#pagebreak()

Die Ausgabe des Befehls lautet wie folgt:

```
C:\Users\esthie>nmap --script http-slowloris --max-parallelism 400 10.100.0.1
Starting Nmap 7.95 ( https://nmap.org ) at 2025-01-20 14:47 Mitteleuropõische Zeit
Nmap scan report for 10.100.0.1
Host is up (0.0029s latency).
Not shown: 997 closed tcp ports (reset)
PORT     STATE SERVICE
80/tcp   open  http
| http-slowloris:
|   Probably vulnerable:
|   the DoS attack took +12s
|   with 949 concurrent connections
|   and 0 sent queries
|_  Monitoring thread couldn't communicate with the server. This is probably due to max clients exhaustion or something similar but not due to slowloris attack.
135/tcp  open  msrpc
8443/tcp open  https-alt
|_http-slowloris: false
MAC Address: 4C:E7:05:93:E7:F2 (Siemens Industrial Automation Products, Chengdu)

Nmap done: 1 IP address (1 host up) scanned in 1836.76 seconds
```

Ab Zeile 9 findet sich das Ergebnis des Scans: "`Probably vulnerable`". Die SPS ist also anfällig für einen DoS-Angriff.

==== Vorbereitung von Slowloris
Slowloris wird in einer Virtuellen Maschine am Management-PC installiert. Das Betriebssystem der VM kann beliebig gewählt werden. Im folgenden wird die Kali-Linux-VM (Version 2024.3) verwendet, welche im Kapitel Port-Scanning für unicornscan aufgesetzt wurde. Hierfür werden die folgenden Befehle ausgeführt.

```
wget https://web.archive.org/web/20090620230243/http://ha.ckers.org/slowloris/slowloris.pl
chmod +x slowloris.pl
sudo apt-get install libio-socket-ssl-perl
```

#pagebreak()

==== Durchführung von Slowloris
Das Skript kann mit dem folgenden Befehl ausgeführt werden.

`perl slowloris.pl -dns 10.100.0.1`


Im obigen Befehl wird kein Port angegeben, da per default der Port 80 verwendet wird. Der Output lautet wie folgt.

```
Connecting to 10.100.0.1:80 every 100 seconds with 1000 sockets:
                Building sockets.
                Building sockets.
                Building sockets.
                Building sockets.
                Building sockets.
                Building sockets.
                Building sockets.
                Sending data.
Current stats:  Slowloris has now sent 524 packets successfully.
This thread now sleeping for 100 seconds...

                Building sockets.
                Building sockets.
                Building sockets.
                Building sockets.
                Sending data.

[...]

                Sending data.
Current stats:  Slowloris has now sent 51504 packets successfully.
This thread now sleeping for 100 seconds...

^C
```

Der Code ist aus Gründen der Übersichtlichkeit gekürzt#footnote("Dazwischen sind Informationen über neue Sockets sowie die Anzahl der derzeitigen Sockets (zwischen 524 und 51504)."). Außerdem ist ersichtlich, dass das Skript nach 51504 Paketen abgebrochen wurde (`^C`). Das ist darauf zurückzuführen, dass nach circa einer halben Stunde des Skripts noch immer kein Effekt erreicht wurde. Um das festzustellen, wurden parallel Tests ausgeführt - welche im folgenden Abschnitt dieses Kapitels noch genauer beschrieben und interpretiert werden. Um es kurz zu sagen: Die Tests verliefen positiv. Slowloris konnte den HTTP-Server der SPS nicht beeinträchtigen.

#pagebreak()

==== Stabilitätstests während Slowloris
Die Erwartung an den DoS-Angriff ist es, dass ein User, welcher das Bahnnetzwerk über den Webserver der SPS steuern möchte, keinen Zugriff auf diesen hat. Während der Ausführung des Slowloris-Skripts wurde laufend ein Tests des Webservers und der Kommunikation mit dem Raspberry Pi durchgeführt.

Zur Demonstration der Funktionalität ist im folgenden ein Ablauf der Kommunikation dokumentiert. Dieser wurde mehrfach durchgeführt.

1. Zugriff auf den Webserver: Der User kann auf den Webserver der SPS zugreifen und die Weichen (hier Weiche 2) ansteuern.

#figure(
  image("../assets/angriffe/dos/sps_screenshot.png", width: 90%),
  caption: "Editieren der Position von Weiche 2"
)

2. Kommunikation zum Raspberry Pi: Die SPS muss nun die Änderungen der Weichen an den Raspberry Pi weiter geben. Dieser wirft Log-Messages, sobald er eine Änderung empfängt.

#figure(
  image("../assets/angriffe/dos/py_log.png", width: 90%),
  caption: "Log-Messages auf dem Raspberry Pi"
)

Aus der Abbildung ist ersichtlich, dass die Weiche 2 einen neuen Wert erhält. Die Kommunikation zwischen der SPS und dem Raspberry Pi ist also erfolgreich.

Anmerkung: Eine genaue Beschreibung, was die Log-Messages bedeuten, befindet sich im Kapitel über die Weichensteuerung.

#pagebreak()

==== Ergebnis von Slowloris
Laut der Analyse durch das Skript von nmap ist die SPS anfällig auf einen Slowloris-DoS-Angriff. Nach rund 50.000 Paketen, welche durch Slowloris abgesendet wurden, gab es jedoch keine (erkennbare) Einschränkung des Webservers der SPS.

=== Python-Skript - Denial of Service-Angriff
Da der Angriff mit Slowloris fehlgeschlagen ist, musste eine alternative Möglichkeit für einen Angriff ausgesucht werden, um eine "zweite Meinung" einzubringen. Hierfür wurde ein selbst geschriebenes Python-Skript erstellt, welches Verbindungen mit dem Webserver der SPS aufbaut.

==== Vorbereitung des Angriffs mit Python
Das Skript `dos.py` ist im folgenden Abschnitt genauer beschrieben. Die Methoden des Python-Skripts sind einzeln genauer erklärt.

#pagebreak()

#htl3r.code-file(
  caption: "dos.py - Methode send_request",
  filename: [dos.py],
  lang: "python",
  ranges: ((10, 25),),
  text: read("../assets/angriffe/dos/dos.py")
)

Die Methode aus dem oben stehenden Ausschnitt sendet HTTP-GET-Anfragen an die gegebene URL. Die aktuelle Zeit wird gespeichert, um später die Dauer der Antwort berechnen zu können. Anschließend wird eine Anfrage mit einer Timeout-Grenze von 5 Sekunden gesendet. Bei einer Antwort mit einem Statuscode von 200 (OK) wird die Anzahl der Erfolge (`success_count`) erhöht. Bei einem anderen Statuscode bzw. wenn ein Fehler auftritt, wird die Anzahl der Fehler (`failure_count`) erhöht.

#pagebreak()

#htl3r.code-file(
  caption: "dos.py - Methode health_check",
  filename: [dos.py],
  lang: "python",
  ranges: ((27, 37),),
  text: read("../assets/angriffe/dos/dos.py")
)

In diesem Abschnitt des Skripts wird überprüft, ob der Server noch erreichbar ist. Wie auch bei der Methode `send_request` wird eine Verbindung an die gegebene URL gesendet und anhand deren Antwort überprüft, ob der Server mit dem Statuscode 200 (OK) antwortet. Der Unterschied zur vorherigen Methode ist, dass die Methode nicht die Anzahl der Erfolge bzw. der Fehlschläge erhöht, sondern stattdessen eine Nachricht auf der Konsole ausgibt. Diese Methode wird alle 100 Anfragen zusätzlich ausgeführt und gibt dem Nutzer so eine Einsicht während der Ausführung des Skripts.

#pagebreak()

#htl3r.code-file(
  caption: "dos.py - Methode stress_test",
  filename: [dos.py],
  lang: "python",
  ranges: ((39, 55),),
  text: read("../assets/angriffe/dos/dos.py")
)

Die letzte Methode des Skripts führt den Angriff auf den Server durch. Je größer die gegebene Anzahl an Threads (`thread_count`), desto eher wird der Denial of Service-Angriff erfolgreich sein. Die Anfragen mithilfe von `send_request` werden hierbei parallel gesendet. Alle 100 Threads wird die Methode `health_check` ausgeführt, um dem User den derzeitigen Status des Webservers zu vermitteln. Schlussendlich werden die Gesamtanzahl der erfolgreichen und der fehlgeschlagenen Verbindungen ausgegeben.

#pagebreak()

==== Angriff mithilfe Python-Skript
Das Skript wird ebenfalls von der Kali-Linux-VM (siehe Kapitel Port-Scanning) ausgeführt.

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ python3 dos.py
Starting DoS attack at 2025-01-22 16:53:47.557767
[Health Check] Server is unresponsive. Current time: 2025-01-22 16:53:47.784634
[Health Check] Server is unresponsive. Current time: 2025-01-22 16:53:48.258507
[Health Check] Server is unresponsive. Current time: 2025-01-22 16:53:48.493758
[Health Check] Server is unresponsive. Current time: 2025-01-22 16:53:48.735463
[Health Check] Server is unresponsive. Current time: 2025-01-22 16:53:49.298863
Test complete. Success: 326, Failures: 674
Finished DoS attack at 2025-01-22 16:53:50.205103
```

Aus der Ausgabe ist ersichtlich, dass der Server aus 1000 aufgebauten Verbindungen 674-mal nicht erreichbar war - ersichtlich in Zeile 9.

==== Ergebnisse des Python-Skripts
Im Gegensatz zu den Tests während dem Slowloris-Angriff ist das Python-Skript erfolgreich gewesen. Im Laufe der Tests wurde die Verbindung auf den Webserver der SPS abgebrochen.

Erwähnenswert ist, dass die Anzahl der Verbindungen drastisch erhöht werden musste, um einen Effekt zu erzielen. Beim erfolgreichen Versuch wurden die Verbindungen auf 100.000 hochgestuft.

#figure(
  image("../assets/angriffe/dos/dos_success.png", width: 80%),
  caption: "Fehlermeldung beim Zugriff auf den Webserver der SPS"
)

#pagebreak()

=== Fazit
Ein DoS-Angriff stellt also eine Gefahr für die SPS und damit das gesamte Bahnnetzwerk dar, da der User nicht auf Weichen und Blockschaltung zugreifen kann. Weiters kann man nicht sicher sein, was mit dem Programm oder gespeicherten Variablen während einer Überlastung auf der SPS passiert.

Erwähnenswert ist, dass der Webserver der SPS eine enorme Masse an Verbindungen ohne Probleme verarbeiten konnte.


/*
TODO add sources
https://www.ncsc.gov.uk/collection/denial-service-dos-guidance-collection
https://www.cloudflare.com/learning/ddos/glossary/denial-of-service/
https://de.wikipedia.org/wiki/Denial_of_Service
https://www.ncsc.gov.uk/files/Preparing%20for%20DoS%20(Denial%20of%20Service)%20attacks_V2.pdf
Zugriff 24.01. für 1-2 und 31.01. für 3, 4

30.12.
https://de.wikipedia.org/wiki/Slowloris
https://www.cloudflare.com/learning/ddos/ddos-attack-tools/slowloris/

4.1
https://nmap.org/nsedoc/scripts/http-slowloris.html

*/
