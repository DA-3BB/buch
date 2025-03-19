#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Esther Lina Mayer")

= Port-Scanning
== Theoretische Grundlagen
Port-Scanning ist eine Methode, um herauszufinden, welche Ports in einem Netzwerk oder auf einem Host offen sind und Daten empfangen könnten. Sie wird verwendet, um Schwachstellen zu entdecken und zu analysieren - nicht nur als Schutzmaßnahme durch Administratoren, sondern auch als potenzieller Angriffsvektor. Außerdem kann man Konfigurationen simpel prüfen und testen, ob gewünschte Ports auch offen sind.

Die grundlegende Funktionsweise eines Port-Scans besteht darin, Pakete an Ports zu versenden
und so herauszufinden, in welchem Status sich diese befinden. Es gibt drei Arten der Antwort:
- *Open* - Der Port nimmt Verbindungen an.
- *Closed* - Der Port ist erreichbar, nimmt aber keine Verbindungen an.
- *Filtered* - Der Port reagiert nicht oder wird durch z.B. eine Firewall blockiert.

Es gibt unterschiedlichste Arten von Scans und Tests, von denen die wichtigsten in der folgenden
Tabelle zusammengefasst sind:

#figure(
    table(
        columns: (20%,70%,10%),
        table.header(
            [*Scan oder Test*], [*Beschreibung*], [*Art*],
        ),
        [TCP-Connect-Scan], [Vollständige TCP-Verbindung mittels Three-Way-Handshake \ Sendet TCP-SYN-Pakete \ Ende via RST oder FIN \ Erzeugt viele Logs (leicht erkennbar)], [Scan],
        [TCP-SYN-Scan], [Half-Open-Scan, die Verbindung wird nicht abgeschlossen \ Sendet Pakete mit SYN-Flag (Verbindungsversuch vortäuschen) \ Kann für DoS verwendet werden (SYN-Floods)], [Scan],
        [TCP-FIN/XMAS/NULL Scan], [Verbindungsloser Scan, Stealth-Scan \ kann von Firewalls unentdeckt bleiben], [Scan],
        [Ping-Sweep], [Testet, welche Hosts erreichbar sind	\ Nutzt ICMP Echo Requests], [Test],
        [Banner Grabbing], [Informationen über das Gerät sammeln (z.B. Dienste, Softwareversion, ...) \ Liest Banner der offenen Ports aus], [Test]
    ),
    caption: [Beschreibung diverser Scan-Arten bzw. Tests]
)

#pagebreak()

===	Rechtliches
Der legale bzw. illegale Einsatz
von Port-Scans ist Gegenstand zahlreicher Diskussionen. Vereinfacht
dargestellt können sie in eigenen Systemen ohne rechtliche Probleme
eingesetzt werden. Beim Einsatz in Fremdsystemen, insbesondere zur
Vorbereitung eines Expolits, macht man sich strafbar. Die große Anzahl
an Verbindungsanfragen kann bei leistungsschwächeren Geräten zu
Fehlfunktionen, Funktionseinschränkungen bis hin zur Überlastung
führen, was auch ohne Absicht zum Angriff als Sabotage
gesehen werden kann und rechtliche Konsequenzen mit sich ziehen könnte.

Mögliche treffende Paragrafen aus dem Strafgesetzbuch #footnote[Siehe https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10002296] sind
- § 5 - Vorsatz bzw. § 15 - Versuch
- § 118a - Widerrechtlicher Zugriff auf ein Computersystem
- § 126b - Störung der Funktionsfähigkeit eines Computersystems


== Vorbereitung der Port-Scans
Im folgenden Abschnitt werden die Komponenten sowie Tools und deren installation
für das nachfolgende Netzwerk genauer beschrieben.

#figure(
  image("../assets/angriffe/port-scanning/TEMP_netzplan.png", width: 50%),
  caption: "Netzplan aus Betrachtungssicht des Port-Scans"
)

In der obigen Abbildung ist das Netzwerk ersichtlich, welches für die
Port-Scans betrachtet wird. Die Scans werden auf die Siemens LOGO SPS
mit der IP-Adresse 10.100.0.1 sowie dem Raspberry Pi mit der Adresse
10.100.0.2 ausgeführt. Das Gerät, welches die Port-Scans durchführt,
ist das ein Notebook mit dem Betriebssystem Windows 10 „MGMT-PC MAY“
mit der IP-Adresse 10.100.0.100.

Bevor die Scans durchgeführt werden, müssen die beiden verwendeten
Tools - nmap und unicornscan - aufgesetzt werden.

===	Installation von nmap
Nmap kann auf einem Linux-Rechner (Ubuntu/Debian) mit dem Befehl
`sudo apt-get install nmap` installiert werden. Da der Port-Scan
jedoch von einem Windows-Gerät ausgeführt wird, muss man entweder
eine VM aufsetzen oder das Tool über die Website herunterladen. In
diesem Fall wird - der Einfachheit halber - Letzteres gewählt.

Der Download-Link lautet: #link("https://nmap.org/download.html#windows")

Man kann nun mit dem folgenden Befehl testen, ob die Installation erfolgreich war:
#footnote[Die aktuelle Version ist 7.95 (Stand 12.12.2024)]

```
C:\Users\esthie>nmap --version
Nmap version 7.95 ( https://nmap.org )
Platform: i686-pc-windows-windows
Compiled with: nmap-liblua-5.4.6 openssl-3.0.13 nmap-libssh2-1.11.0 nmap-libz-1.3.1 nmap-libpcre2-10.43 Npcap-1.79 nmap-libdnet-1.12 ipv6
Compiled without:
Available nsock engines: iocp poll select
```

=== Installation von unicornscan
Zur Verwendung des Tools unicornscan, wurde auf Kali-Linux installiert.
Um diese aufzusetzen, wurde WSL (Windows Subsystem for Linux) verwendet.
 Als erster Schritt werden mögliche Distributionen gelistet, die
 WSL als VMs installieren kann. Der Befehl hierfür lautet:

```
C:\Users\esthie>wsl --list --online
Nachstehend finden Sie eine Liste der gültigen Distributionen, die installiert werden können.
Führen Sie die Installation mithilfe des Befehls „wsl.exe --install <Distro>“ aus.

NAME                            FRIENDLY NAME
[…]
kali-linux                      Kali Linux Rolling
[…]
```

Aus dieser Liste kann man den Namen herauslesen, der in folgendem Befehl
zur Installation der VM verwendet wird.

```
C:\Users\esthie>wsl --install -d kali-linux
```

#pagebreak()

Nach der erfolgreichen Installation der Kali-Linux-Distribution startet
 sich die VM im Regelfall automatisch. Falls sie sich nicht öffnet,
 kann man mit dem folgenden Befehl in die VM einsteigen:

```
C:\Users\esthie>wsl -d kali-linux
┏━(Message from Kali developers)
┃
┃ This is a minimal installation of Kali Linux, you likely
┃ want to install supplementary tools. Learn how:
┃ ⇒ https://www.kali.org/docs/troubleshooting/common-minimum-setup/
┃
┗━(Run: “touch ~/.hushlogin” to hide this message)
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$
```

Das Kali-Linux-Gerät ist nun bereit und man kann das Tool unicornscan installieren.

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ sudo apt-get update
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ sudo apt install unicornscan
```

Man kann nun testen, ob die Installation erfolgreich war.
#footnote[ Die aktuelle Version ist 0.4.7 (Stand 12.12.2024)]

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ unicornscan --version
#unicornscan version `0.4.7' using module version 1.03 build options [ ]
pcap version libpcap version 1.10.4 (with TPACKET_V3)
Compiled by kalibuild on Linux dionysus 4.19.0-26-amd64 x86_64 at Tue May  7 01:46:59 UTC 2024 with gcc version 13.2.013.2.024
report bugs to osace-users@lists.sourceforge.net
```

#pagebreak()

===	Host-Discovery
Host-Discovery bezeichnet den Prozess, Informationen über die
Geräte in einem Netzwerk zu sammeln. In diesem Fall wird es
verwendet, um die IP-Adressen des Raspberry Pi sowie der SPS
herauszufinden und zu testen, ob diese online sind. Hierfür
wird nmap - mit der Option -sn - verwendet, welche einen
Ping-Scan durchführt, ohne die Ports zu scannen.

```
C:\Users\esthie>nmap -sn 10.100.0.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-01-20 14:41 Mitteleuropäische Zeit
Nmap scan report for 10.100.0.1
Host is up (0.00s latency).
MAC Address: 4C:E7:05:93:E7:F2 (Siemens Industrial Automation Products, Chengdu)
Nmap scan report for 10.100.0.2
Host is up (0.0014s latency).
MAC Address: B8:27:EB:3D:F9:83 (Raspberry Pi Foundation)
Nmap scan report for 10.100.0.11
Host is up (0.0010s latency).
MAC Address: 04:EE:E8:14:02:D8 (Shanghai Zlan Information Technology)
Nmap scan report for 10.100.0.12
Host is up (0.0010s latency).
MAC Address: 04:EE:E8:13:58:A8 (Shanghai Zlan Information Technology)
Nmap scan report for 10.100.0.13
Host is up (0.0013s latency).
MAC Address: 04:EE:E8:13:03:FF (Shanghai Zlan Information Technology)
Nmap scan report for 10.100.0.253
Host is up (0.0010s latency).
MAC Address: 00:80:63:36:CB:66 (Hirschmann Automation and Control GmbH)
Nmap scan report for 10.100.0.100
Host is up.

Nmap done: 256 IP addresses (6 hosts up) scanned in 30.88 seconds
```

#pagebreak()

Der Ping-Scan zeigt, dass zum Zeitpunkt des Scans sechs Geräte auf
den ICMP-Echo-Request antworten. Diese Geräte sind:
- die Siemens LOGO SPS (10.100.0.1),
- der Raspberry Pi (10.100.0.2),
- die drei WaveShare-Module (10.100.0.11 bis .13) und
- der Switch (10.100.0.253).
Außerdem sieht man in der Übersicht den Management-PC,
von dem aus der Ping-Scan ausgeführt wurde.

_Anmerkung: Falls etwaige Firewall-Settings keine ICMP-Echo-Requests
zulassen, kann es sein, dass sie bei diesem Befehl nicht auftauchen.
Für den Rahmen der Diplomarbeit kann dies jedoch ignoriert werden._

== Erwartete Werte
Da keine Angriffe auf ein fremdes Netz durchgeführt werden, besteht
die Möglichkeit, konfigurierte Parameter („Referenzwerte“) vom Raspberry Pi
sowie der SPS zu sammeln.

Für die SPS kann man die LOGO!Soft Comfort 8.4 verwenden und in den
Einstellungen bestimmte Parameter auslesen - wie im folgenden Unterkapitel
beschrieben, aus welchen dann die offenen Ports ermittelt werden können.
Beim Raspberry Pi werden die offenen Ports mit einem Befehl ausgelesen.

#pagebreak()

===	Siemens LOGO SPS
In der LOGO!Soft Comfort findet man unter den Online-Einstellungen der
SPS im Reiter „Einstellungen für Zugriffskontrolle“ folgende Übersichtstabelle:

#figure(
  image("../assets/angriffe/port-scanning/sps_zugriffssicherheit.png", width: 70%),
  caption: "Übersicht über die Zugriffssicherheit der SPS"
)

Aus dieser Liste sind die verwendeten Dienste herauszulesen. Die zugehörigen
Ports müssen nur noch ermittelt werden, um folgende Tabelle zu erstellen.

#figure(
    table(
        columns: (25%,10%,65%),
        table.header(
            [*Dienst*], [*Port*], [*Anmerkung*],
        ),
        [HTTP-Server],[80],[Verwendet für den Webserver, der das Gleisnetzwerk steuert],
        [S7-Zugriff],[102],[Kommunikation zwischen Siemens-Geräten],
        [Modbus-Zugriff],[502-510],[Modbus-TCP-Kommunikation],
        [TDE-Zugriff],[135],[LOGO per Fernverbindung überwachen]
    ),
    caption: [Erwartete offene Ports der SPS]
)

// TODO update as soon as chapter is written (and named)
_Anmerkung: Für Modbus wird die Port-Range 502 bis 510 angenommen, da
bei Aktivieren des Modbus-Zugriffs (genauer beschrieben im Kapitel SPS)
diese Ports genannt werden._

Diese Portrange wird in den allgemeinen Offline-Einstellungen der
LOGO gelistet, wenn man den Modbus-Zugriff erlaubt.

#pagebreak()


===	Raspberry Pi
Für den Raspberry Pi kann man einen Befehl zum Auflisten der
Ports verwenden.#footnote[Die IPv6-Dienste werden nicht behandelt.]
Der Befehl lautet wie folgt:

```
root@raspberrypi:/home/admin/3bb_mod_bus# sudo netstat -tlpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address   Foreign Address   State   PID/Program name
tcp        0      0 127.0.0.1:631   0.0.0.0:*         LISTEN  1880/cupsd
tcp        0      0 0.0.0.0:22      0.0.0.0:*         LISTEN  731/sshd: /usr/sbin
tcp        0      0 0.0.0.0:502     0.0.0.0:*         LISTEN  1789/python3
tcp        0      0 0.0.0.0:5900    0.0.0.0:*         LISTEN  729/vncserver-x11-c
[…]
```

Die Optionen, welche für den Befehl verwendet wurden, zeigen die
TCP-Ports (`-t`), welche sich im LISTEN-Status befinden (`-l`), der
Prozess - also PID sowie Programmname -, welcher den Port verwendet
(`-p`) und die Portnummer selbst (`-n`).

Durch diesen Befehl kann nun ermittelt werden, welche Ports offen sind.

#figure(
    table(
        columns: (25%,10%,65%),
        table.header(
            [*Dienst*], [*Port*], [*Anmerkung*],
        ),
        [CUPS (cupsd)],[631],[Drucker-Dienst],
        [SSH (sshd)],[22],[Fernzugriff auf den Raspberry Pi],
        [Modbus (python3)],[502],[Modbus-Server zum Empfangen von Daten von der SPS],
        [VNC (vncserver)],[5900],[VNC-Server für den Fernzugriff]
    ),
    caption: [Erwartete offene Ports des Raspberry Pi]
)

#pagebreak()

== Durchführung der Port-Scans
Nachdem nun die „Referenzwerte“ ermittelt wurden, werden - mit den
beiden gewählten Tools - nun Port-Scans auf den Raspberry Pi und
die SPS durchgeführt.

=== nmap
Für nmap werden die folgenden beiden Optionen verwendet.

```
nmap -sS -p- [IP-Adresse]
nmap -sS -p502-510 [IP-Adresse]
```

Die Option `-sS` steht für einen TCP-SYN-Scan , welcher entweder
auf alle Ports (`-p-`) oder auf eine Port-Range (`-p502-510`) ausgeführt wird.

Der erste Scan addressiert den Raspberry Pi. Der Befehl sowie der Output lauten wie folgt:

```
C:\Users\esthie>nmap -sS -p- 10.100.0.2
Starting Nmap 7.95 ( https://nmap.org ) at 2024-12-11 10:56 Mitteleuropäische Zeit
Nmap scan report for 10.100.0.2
Host is up (0.00088s latency).
Not shown: 65532 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
502/tcp  open  mbap
5900/tcp open  vnc
MAC Address: B8:27:EB:3D:F9:83 (Raspberry Pi Foundation)

Nmap done: 1 IP address (1 host up) scanned in 4.43 seconds
```

Aus dem Output lässt sich erkennen, dass die Ports 22, 502 und 5900 offen sind.

#pagebreak()

Der zweite Scan richtet sich nun an die SPS und ihre offenen Ports. Am Befehl selbst ändert sich nichts.

```
C:\Users\esthie>nmap -sS -p- 10.100.0.1
Starting Nmap 7.95 ( https://nmap.org ) at 2024-12-11 10:56 Mitteleuropäische Zeit
Nmap scan report for 10.100.0.1
Host is up (0.0014s latency).
Not shown: 65530 closed tcp ports (reset)
PORT     STATE SERVICE
80/tcp   open  http
102/tcp  open  iso-tsap
135/tcp  open  msrpc
510/tcp  open  fcp
8443/tcp open  https-alt
MAC Address: 4C:E7:05:93:E7:F2 (Siemens Industrial Automation Products, Chengdu)

Nmap done: 1 IP address (1 host up) scanned in 13.95 seconds
```

Die offenen Ports sind also Port 80, 102, 135, 510 und 8443. Aus dem
Output kann man erkennen, dass aus der Port-Range für Modbus (502 bis 510)
nur einer von diesen geöffnet ist. Um sicher zu gehen, wird die Range
separat noch einmal gescannt:

```
C:\Users\esthie>nmap -sS -p502-510 10.100.0.1
Starting Nmap 7.95 ( https://nmap.org ) at 2024-12-11 10:59 Mitteleuropäische Zeit
Nmap scan report for 10.100.0.1
Host is up (0.00076s latency).

PORT    STATE  SERVICE
502/tcp closed mbap
503/tcp closed intrinsa
504/tcp closed citadel
505/tcp closed mailbox-lm
506/tcp closed ohimsrv
507/tcp closed crs
508/tcp closed xvttp
509/tcp closed snare
510/tcp open   fcp
MAC Address: 4C:E7:05:93:E7:F2 (Siemens Industrial Automation Products, Chengdu)

Nmap done: 1 IP address (1 host up) scanned in 1.71 seconds
```

#pagebreak()

===	unicornscan
Nun werden analoge Befehle mit unicornscan ausgeführt, um zu vergleichen,
ob beide Tools zu denselben Outputs kommen. Das Kommando selbst lautet

`unicornscan -msf -p1-65535 [IP-Adresse]`

Die Option `-msf` legt den Modus des Scans fest, welcher in diesem
Fall (`sf`) wieder ein TCP-SYN-Scan ist. Bei unicornscan gibt es
keine Option für alle Ports, weshalb diese manuell eingegeben
werden müssen (`-p1-65535`).

Es wird wieder mit dem Scan auf den Raspberry Pi mit denselben Parametern begonnen:

```
┌──(root㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─# unicornscan -msf -p1-65535 10.100.0.2

TCP open                     ssh[   22]         from 10.100.0.2  ttl 63
TCP open          asa-appl-proto[  502]         from 10.100.0.2  ttl 63
TCP open                  winvnc[ 5900]         from 10.100.0.2  ttl 63
```

Nun wird die SPS erneut gescannt, ebenfalls mit demselben Befehl wie zuvor.

```
┌──(root㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─# unicornscan -msf -p1-65535 10.100.0.1
TCP open                    http[   80]         from 10.100.0.1  ttl 254
TCP open                iso-tsap[  102]         from 10.100.0.1  ttl 254
TCP open                   epmap[  135]         from 10.100.0.1  ttl 254
TCP open                     fcp[  510]         from 10.100.0.1  ttl 254
TCP open            pcsync-https[ 8443]         from 10.100.0.1  ttl 254
```

==	Ergebnisse der Port-Scans
Im folgenden Abschnitt werden die Ergebnisse von nmap und unicornscan
mit den erwarteten Werten in einer Tabelle verglichen.

#pagebreak()

===	Raspberry Pi
Nach den erfolgreichen Scans lässt sich nun die folgende Tabelle aufstellen.

#figure(
    table(
        columns: (10%, 12%, 12%, 15%),
        table.header(
            [*Port*], [*Erwartet*], [*nmap*], [*unicornscan*],
        ),
        [22],[✔],[✔],[✔],
        [502],[✔],[✔],[✔],
        [631],[✔],[X],[X],
        [5900],[✔],[✔],[✔]
    ),
    caption: [Vergleichstabelle der Port-Scans auf den Raspberry Pi]
)

Die Ports 22 (SSH), 502 (Modbus) und 5900 (VNC) sind alle wie erwartet
offen. Der Port 631 für CUPS (Common Unix Printing System) ist jedoch
bei keinem der beiden Scans als offen erkannt worden. Der wahrscheinlichste Grund
hierfür ist, das CUPS ist meist so konfiguriert, dass es nur lokale Verbindungen (von 127.0.0.1) akzeptiert. Bei einem Scan von einem anderen Gerät könnte der Dienst als nicht offen erscheinen.

#pagebreak()

===	Siemens LOGO SPS
Die erwarteten Werte sowie die Ergebnisse von nmap und unicornscan
befinden sich in der folgenden Tabelle.

#figure(
    table(
        columns: (10%, 12%, 12%, 15%),
        table.header(
            [*Port*], [*Erwartet*], [*nmap*], [*unicornscan*],
        ),
        [80],[✔],[✔],[✔],
        [102],[✔],[✔],[✔],
        [135],[✔],[✔],[✔],
        [502-510],[502-510],[510],[510],
        [8443],[X],[✔],[✔]
    ),
    caption: [Vergleichstabelle der Port-Scans auf die SPS]
)

Die Ports 80 (HTTP), 102 (S7) und 135 (TDE) sind - wie erwartet - offen.
Auffällig ist, dass statt der erwarteten Port-Range 502 bis 510 für Modbus
nur Port 510 offen ist. Das kann daran liegen, dass die SPS kein Modbus-Server,
sondern Modbus-Client ist und deswegen nur einen dieser Ports benötigt.
Der Port 8443 ist ein alternativer HTTPS-Port, auf der SPS ist jedoch nur
HTTP benötigt und nicht HTTPS.

Die LOGO!Soft 8.4 besitzt keine zentrale Port-Übersicht, daher ist es
schwer, ohne einen Port-Scan herauszufinden, dass Port 8443 offen ist.
Die Einstellungen für die Ports sind fixiert und können vom User nicht
verändert werden, was ein Grund für das fehlende Menü sein kann.
#footnote[https://support.industry.siemens.com/forum/at/en/posts/logo-soft-comfort-port-conflict/160301]


// TODOs
// include sources from word file

/*
Zugriff 16.11.2024
https://nmap.org/book/man.html
https://www.kali.org/tools/unicornscan/

Zugriff 11.12.2024
https://de.wikipedia.org/wiki/Portscanner

Zugriff 12.12.2024
https://de.wikipedia.org/wiki/Nmap

Zugriff 13.12.2024
https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10002296
*/
