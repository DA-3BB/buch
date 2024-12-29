= Zertifizierungsprüfungen 
Um das Ziel der Zertifizierungsprüfung positiv abschließen zu können, wurde der Weg des FAQ-Lernens gewählt. 

== Ablauf
Von Fortinet wurde uns das Training für die Zertifizierung auf der eigenen Fortinet-Lernplattform www.training.fortinet.com freigeschalten. Diese beinhaltet Videos welche die einzelnen Kapitel genau erklären. Da das Lernen nur anhand von Videos nicht ausreichend ist, wurden anhand der schriftlichen Version der Videos Frage-Antwort-Paare verfasst. Insgesamt wurden für die Zertifizierung "FortiGate Administrator 7.4" 1255-Fragen verfasst und für "FortiManager Administrator 7.4" 475-Fragen. \
Mithilfe von "Anki" einer bekannten App um FAQs zu lernen, wurden nachdem alle Paare selbst verfasst wurden, die FAQs importiert und jeden Tag 20 neue gelernt, sowie einige schon beantworteten Fragen, welche laut Anki wiederholt werden sollten. \ 
Nebenbei wurden sogenannte "Labs" durchgeführt, hierfür stellt die Trainingsplattform von Fortinet eine virtuelle Umgebung zur Verfügung, sowie eine Schritt-für-Schritt Anleitung, welche Tasks wie erledigt werden sollen. \
Um die Inhalte des Kurses auch praktisch und intuitiv zu lernen, wird eine Topologie aufgebaut, in der die wichtigsten Themen implementiert werden.


=== Anki
Es wurde eine Liste von FAQs als CSV-Datei importiert. Anschließend wurden 20 Neue jeden Tag gelernt. Man bekommt jeweils eine Frage angezeigt, mit der Antwort noch versteckt. Somit muss man sich zuerst seine eigenen Antwort denken, bevor man die Korrekte sieht. Mit dem Drücken einer Taste auf der Tastatur wird die richtige Antwort sichtbar und man hat vier Auswahlmöglichkeiten um sein eigenes Wissenslevel einzuschätzen: "Again", "Hard", "Good", "Easy". Je nach dem wie oft man diese Frage schon beantwortet hat, sieht man neben jeder Möglichkeit eine Nummer an Minuten/Tagen/Monaten, wann man diese Frage wieder beantworten muss. Wenn man also eine Frage schon mehrmals beantwortet hat und gerade wieder, würde man die Option "Good" oder "Easy" wählen, neben welcher "1.1Mo" steht, diese Frage muss man in 1.1 Monaten wieder beantworten, bis dahin erscheint diese Frage nicht mehr. Somit werden jeden Tag zwischen 50 und 80 Fragen wiederholt, sowie 20 neue gelernt, für jede Zertifizierung einzeln.


== FortiGate Administrator 7.4
In den folgenden Abschnitten werden die einzelnen Kapitel des Zertifikatskurses zusammengefasst.
=== System and Network Settings
Im ersten Kapitel des Kurses lernt man die Grundlagen über die FortiGate, also die Next-Generation Firewall (NGFW) von Fortinet. Man erfährt wie man sich das erste mal mit der FortiGate verbinden kann, die Interfaces konfiguriert und DHCP- und VLAN-Einstellungen tätigt. Ebenfalls welche Möglichkeiten der Administrierung zur Verfügung stehen bzw. die Einschränken dieser, wie zum Beispiel "trusted Hosts".\ 
Es gibt auch ein Feature um eine Firewall-Instanz in Mehrere aufzuteilen: die einzelnen Virtual-Domains (VDOMs) können (per-default) nicht untereinander komminzieren, sind dementsprechend gut wenn man mehrere Kunden getrennt verwalten möchte (MSSP).
// backups und updates? oder useless weil eh klar

=== Firewall Policies and NAT
Dieser Teil beschäftigt sich hauptsächlich mit Firewall Policies, diese sind Regeln welche den Datenverkehr zwischen den Interfaces der Firewall einschränken. Es gibt verschiedene Werte welche in einer Policy konfiguriert werden können, um möglichst genau zu bestimmen welcher Traffic erlaubt oder blockiert wird. Am Wichtigsten sind Ziel- und Quell Interface, hiermit wird schonmal bestimmt welche Policies für das aktuelle Paket inspiziert werden. Genauer Eingeschränkt wird mithilfe von Ziel- und Quelladresse(n): von wo wohin ist Traffic erlaubt? Welcher User darf ein gewissens Service verwenden, sowie auch um welche Uhrzeiten welcher Datenverkehr erlaubt bzw. verboten wird. Für alle aktuellen Firewalls am Markt gilt ebenfalls das implicit deny: Daten werden grundsätzlich verboten, außer es gibt eine Policy die sie erlaubt. \

Als Beispiel: Wenn man den Zugriff auf einen FTP-Server einschränken möchte würde man folgendes konfigurieren.

In-going Int: LAN \
Out-going Int: DMZ \
Src: LAN1-Adressen \
Dest: FTP-Server-IP \
Service: FTP \
Schedule: Always \
Action: Allow \

Ebenso könnte man Security Profile auf diese Policy anwenden, diese werden aber in einem späteren Kapitel genauer behandelt. \

Um genauere und generische Regeln miteinander zu ermöglichen muss es ein system geben, welche Policy zuerst gewählt wird. Dies wird mit der Reihenfolge der Regeln ermöglicht. Wenn also eine generische Regel vor einer Spezifischeren steht, wird die Spezifische nie erreicht. Dementsprechend ist es wichtig die genaueren Policies in der Reihenfolge nach oben zu verschieben.

Zusätzlich wird in diesem Kapitel "Network Address Translation" (NAT) erklärt. NAT ist hauptsächlich dafür da, um private IP-Adressen auf Öffentliche zu übersetzen. Da es nicht unendlich viele öffentlichen IP-Adressen gibt, ist dieses Verfahren hilfreich um diese zu sparen, da mit Hilfe von "Port Address Translation" (PAT) mehrere Adressen auf eine öffentliche zugewiesen werden und dann auch wieder auf die privaten zurück übersetzt. 

=== Routing
Routing ist zuständig um ein Paket von einem Netzwerk an ein anderes Weiterzuleiten. Die Schwierigkeit besteht darin zu wissen, wohin man es weiterschicken muss. Um das Problem zu lösen gibt es Routing Tabellen, in welchen steht, welches Netzwerk wo angeschlossen ist bzw. wohin man das Paket senden muss wenn es zu einem gewissen Netzwerk will. \
/*
Ziel: beste route -> genaueste
routing lookups --> twice per session erste hin, zweite zurück
2 Routing tabelle: RIB (active only), FIB (Routing from kernel)
statische routen
parameter: distance --> first tiebreaker bei gleichen routen (untersch protokolle), the lower the better, bei cisco: Administrative distance: OSPF 110, RIP 120
Metric: tiebreaker, gleiches protokoll, je nach protokoll berechnet --> ospf: cost, rip: hopcount
Priority: 



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



// Quelle alles Kapitel FortiGate Guide /*