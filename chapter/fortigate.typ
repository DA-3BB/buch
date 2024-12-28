= Zertifizierungsprüfungen 
== Übersicht
Um das Ziel der Zertifizierungsprüfung positiv abschließen zu können, wurde der Weg des FAQ-Lernens gewählt. 

== Ablauf
Von Fortinet wurde uns das Training für die Zertifizierung auf der eigenen Fortinet-Lernplattform www.training.fortinet.com freigeschalten. Diese beinhaltet sowohl Videos welche die einzelnen Kapitel genau erklären, als auch Labs welche einen Schritt für Schritt durch die Konfiguration der jeweiligen Themen führen. Da das Lernen nur anhand von Videos nicht ausreichend ist, wurden anhand der schriftlichen Version der Videos Frage-Antwort-Paare verfasst. Insgesamt wurden für die Zertifizierung "FortiGate Administrator 7.4" 1255-Fragen verfasst und für "FortiManager Administrator 7.4" 475-Fragen. 
Mithilfe von "Anki" einer bekannten App um FAQs zu lernen, wurden nachdem alle Paare selbst verfasst wurden, importiert und jeden Tag 20 neue gelernt, sowie alle Fragen, welche laut Anki wiederholt werden sollten. 

== Anki
Es wurde eine Liste von FAQs als CSV-Datei importiert. Anschließend wurden 20 Neue jeden Tag gelernt. Man bekommt jeweils eine Frage angezeigt, mit der Antwort noch versteckt. Somit muss man sich zuerst seine eigenen Antwort denken, bevor man die Korrekte sieht. Mit dem Drücken einer Taste auf der Tastatur wird die richtige Antwort sichtbar und man hat vier Auswahlsmöglichkeiten um sein eigenes Wissenslevel einzuschätzen: "Again", "Hard", "Good", "Easy". Je nach dem wie oft man diese Frage schon beantwortet hat, sieht man neben jeder Möglichkeit eine Nummer an Tagen/Monaten, wann man diese Frage wieder beantworten muss. Wenn man also eine Frage schon mehrmals beantwortet hat und gerade wieder, würde neben der Option "Good" "1.1Mo" stehen, diese Frage muss man in 1.1 Monaten wieder beantworten, bis dahin erscheint diese Frage nicht mehr.

== FortiGate Administrator 7.4
=== System and Network Settings
Im ersten Kapitel des Kurses lernt man die Grundlagen über die FortiGate, also die Next-Generation Firewall (NGFW) von Fortinet. Man lernt wie man sich das erste mal mit der FortiGate verbinden kann, die Interfaces konfiguriert und DHCP- und VLAN-Einstellungen tätigt. Ebenfalls welche Möglichkeiten der Administrierung zur Verfügung stehen bzw. die Einschränken dieser, wie zum Beispiel "trusted Hosts".\ 
Es gibt auch ein Feature um eine Firewall-Instanz in Mehrere aufzuteilen. Die einzelnen Virtual-Domains (VDOMs) können (per-default) nicht untereinander komminzieren, sind dementsprechend gut wenn man mehrere Kunden getrennt verwalten möchte (MSSP).
// backups und updates? oder useless weil eh klar

=== Firewall Policies and NAT
Dieser Teil beschäftigt sich hauptsächlich mit Firewall Policies, diese sind Regeln welche den Datenverkehr zwischen den Interfaces der Firewall einschränken. Es gibt verschiedene... //hier stop
was sind sie, ein interface zu anderem, einschränken mit Src/Dest  IP, User, Address, Schedule, service, action..., implicit deny, sicherheit der Firewall der 1. gen 
example ftp, einschränken auf paar server, dest: paar server, src: any, sched: always, serv: ftp, action:accept
security profiles
reihenfolge wichtig, policy id identifiziert
first policy applies --> genauere am anfang
logging: all, security events
inspection modes
NAT, SNAT, DNAT, static, pool
VIP: DNAT, port forwarding, fw policies dont match, cli config: only deny action
=== Routing
=== Firewall Authentication
=== Fortinet Single Sign-On (FSSO)
=== Certificate Operations
=== Antivirus
=== Web Filtering
=== Intrusion Prevention and Application Control
=== SSL VPN
=== IPsec VPN
=== SD-WAN Configuration and Monitoring
=== Security Fabric
=== High Availability
=== Diagnostics and Troubleshooting 



// Quelle alles Kapitel FortiGate Guide