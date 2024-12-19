= Port-Scanning
== Theoretische Grundlagen
Port-Scanning ist eine Methode, um herauszufinden, welche Ports in einem Netzwerk oder auf einem Host offen sind und Daten empfangen könnten. Es wird verwendet, um Schwachstellen zu entdecken und zu analysieren - nicht nur als Schutzmaßnahme durch Administratoren, sondern auch als potenzieller Angriffsvektor für Kriminelle. 

Die grundlegende Funktionsweise eines Port-Scans besteht darin, Pakete an Ports zu versenden und so herauszufinden, in welchem Status sich diese befinden. Es gibt drei Arten der Antwort:
- *Open* - Der Port nimmt Verbindungen an.
- *Closed* - Der Port ist erreichbar, nimmt aber keine Verbindungen an. 
- *Filtered* - Der Port reagiert nicht oder wird durch z.B. eine Firewall blockiert. 

Es gibt unterschiedlichste Arten von Scans und Tests, von denen die wichtigsten in der folgenden Tabelle zusammengefasst sind.

#table(
    columns: 3,
    table.header(
        [*Scan oder Test*], [*Beschreibung*], [*Art*],
    ),
    [TCP-Connect-Scan], [Vollständige TCP-Verbindung mittels Three-Way-Handshake \ Sendet TCP-SYN-Pakete \ Ende via RST oder FIN \ Erzeugt viele Logs (leicht erkennbar)], [Scan],
    [TCP-SYN-Scan], [Half-Open-Scan, die Verbindung wird nicht abgeschlossen \ Sendet Pakete mit SYN-Flag (Verbindungsversuch vortäuschen) \ Kann für DoS verwendet werden (SYN-Floods)], [Scan],
    [TCP-FIN/XMAS/NULL Scan], [Verbindungsloser Scan	Stealth-Scan], [Scan],
    [Ping-Sweep], [Testet, welche Hosts erreichbar sind	\ Nutzt ICMP Echo Requests], [Test],
    [Banner Grabbing], [Informationen über das Gerät sammeln (z.B. Dienste, Softwareversion, ...) \ Liest Banner der offenen Ports aus], [Test]

)

===	Rechtliches
Bei Port-Scans gibt es diverse Streitigkeiten, ob sie legal oder rechtswidrig sind. In seinen eigenen Systemen kann es problemlos genutzt werden, um diverse Sicherheitschecks durchzuführen. Sollte man den Port-Scan verwenden, um z.B. einen Exploit-Versuch zu starten, so macht man sich strafbar. Schwächere Geräte können durch die vielen Verbindungsanfragen auch abstürzen oder in ihrer Verfügbarkeit leiden, was auch ohne Absicht zum Angriff als Sabotage gesehen werden kann und rechtliche Konsequenzen mit sich ziehen könnte.

Mögliche treffende Paragrafen aus dem Strafgesetzbuch  sind
- § 5 - Vorsatz bzw. § 15 - Versuch 
- § 118a - Widerrechtlicher Zugriff auf ein Computersystem
- § 126b - Störung der Funktionsfähigkeit eines Computersystems

#pagebreak()

== Vorbereitung
Im folgenden Abschnitt werden die Komponenten sowie Tools und deren Installation genauer beschrieben.

#figure(
  image("../assets/angriffe/port-scanning/TEMP_netzplan.png", width: 70%),
  caption: "Netzplan aus Betrachtungssicht des Port-Scans"
)

In der obigen Abbildung ist das Netzwerk ersichtlich, welches für die Port-Scans betrachtet wird. Die Scans werden auf die Siemens LOGO SPS mit der IP-Adresse 10.100.0.1 sowie dem Raspberry Pi mit der Adresse 10.100.0.2 ausgeführt. Das Gerät, welches die Port-Scans durchführt, ist das Windows-10-Gerät „MGMT-PC MAY“ mit der IP-Adresse 10.100.0.100. 
Bevor die Scans durchgeführt werden, müssen die beiden verwendeten Tools - nmap und unicornscan - aufgesetzt werden. 

===	Installation von nmap
Nmap kann auf einem Linux-Rechner (Ubuntu/Debian) mit dem Befehl `sudo apt-get install nmap` installiert werden. Da der Port-Scan jedoch von einem Windows-Gerät ausgeführt wird, muss man entweder eine VM aufsetzen oder das Tool über die Website herunterladen. In diesem Fall wird Letzteres ausgeführt, der Download-Link lautet: #link("https://nmap.org/download.html#windows") 

Man kann nun mit dem folgenden Befehl testen, ob die Installation erfolgreich war. #footnote[Die aktuelle Version ist 7.95 (Stand 12.12.2024)]

```bash
C:\Users\esthie>nmap --version
Nmap version 7.95 ( https://nmap.org )
Platform: i686-pc-windows-windows
Compiled with: nmap-liblua-5.4.6 openssl-3.0.13 nmap-libssh2-1.11.0 nmap-libz-1.3.1 nmap-libpcre2-10.43 Npcap-1.79 nmap-libdnet-1.12 ipv6
Compiled without:
Available nsock engines: iocp poll select
```

#pagebreak()

=== Installation von unicornscan
Das zweite Tool, unicornscan, läuft auf einer Kali-Linux-Maschine. Um diese aufzusetzen, wurde WSL (Windows Subsystem for Linux) verwendet. Als erster Schritt werden mögliche Distributionen gelistet, die WSL installieren kann. Der Befehl hierfür lautet

```bash
C:\Users\esthie>wsl --list --online
Nachstehend finden Sie eine Liste der gültigen Distributionen, die installiert werden können.
Führen Sie die Installation mithilfe des Befehls „wsl.exe --install <Distro>“ aus.

NAME                            FRIENDLY NAME
[…]
kali-linux                      Kali Linux Rolling
[…]
```

Aus dieser Liste kann man den Namen herauslesen, der in folgendem Befehl zur Installation der VM verwendet wird.

`C:\Users\esthie>wsl --install -d kali-linux`

Nach der erfolgreichen Installation der Kali-Linux-Distribution sollte sich die VM automatisch starten. Falls sie sich nicht öffnet, kann man mit dem folgenden Befehl in die VM einsteigen.

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
