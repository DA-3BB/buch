= Zertifizierungsprüfungen 
Um das Ziel der Zertifizierungsprüfung erreichen zu können, wurde der Weg des FAQ#footnote("selbstgeschriebene Frage-Antwort-Paare, um die Inhalte der Zertifizierungsunterlagen zu lernen")-Lernens gewählt. Die Zertifizierungsprüfung umfassen die wichtigsten Themen über die Produkte FortiGate und FortiManager der Firma Fortinet.

== Ablauf des Vorbereitung für die Zertifizierungsprüfungen
Von Fortinet wurde dem Team das Training für die Zertifizierung auf der eigenen Fortinet-Lernplattform www.training.fortinet.com freigeschaltet. Dieses beinhaltet Videos, welche die einzelnen Kapitel genau erklären. Da das Lernen nur anhand von Videos nicht ausreichend ist, wurden anhand der schriftlichen Version der Videos Frage-Antwort-Paare in Excel verfasst. Insgesamt wurden für die Zertifizierung "FortiGate Administrator 7.4" 1255-Fragen verfasst und für "FortiManager Administrator 7.4" 475-Fragen. \
#figure(
    image("../assets/fortigate/FAQ_snippet_Excel-3.png", width: 100%),
    caption: "Ausschnitt der Excel-Tabelle mit den FAQs"
)\
Mithilfe von "Anki", einer bekannten App um FAQs zu lernen, wurden die FAQs importiert und jeden Tag 20 neue gelernt, sowie die bereits beantworteten Fragen, welche - je nach Schwierigkeitsgrad - früher oder später wiederholt werden sollten. \ 
Ergänzend wurden sogenannte "Labs" durchgeführt, hierfür stellt die Trainingsplattform von Fortinet eine virtuelle Umgebung zur Verfügung, sowie eine Schritt-für-Schritt Anleitung, welche Tasks wie erledigt werden sollen. \
Um die Inhalte des Kurses auch praktisch und intuitiv zu lernen, wurde eine Topologie aufgebaut, in der die wichtigsten Themen implementiert wurden.


=== Training mit FAQs
Jeden Tag wurde eine Anzahl von 20 neuen FAQs gelernt. Man bekommt jeweils eine Frage angezeigt, bei welcher die Antwort noch nicht sichtbar ist. Somit muss man sich zuerst seine eigene Antwort denken, bevor man die korrekte sieht. 
#figure(
    image("../assets/fortigate/anki_screenshot_example_faq_closed.png", width: 50%),
    caption: "Beispiel einer verdeckten Karteikarte"
)
Mit dem Drücken einer Taste auf der Tastatur wird die richtige Antwort sichtbar und man hat vier Auswahlmöglichkeiten um sein eigenes Wissenslevel einzuschätzen: "Again", "Hard", "Good" und "Easy". Je nachdem wie oft man diese Frage schon beantwortet hat, sieht man neben jeder Möglichkeit eine Nummer an Minuten/Tagen/Monaten, wann man diese Frage wieder beantworten muss. Wenn man also eine Frage schon mehrmals beantwortet hat und gerade wieder, würde man die Option "Good" oder "Easy" wählen, neben welcher "1.1Mo" steht, diese Frage muss man in 1.1 Monaten wieder beantworten, bis dahin erscheint diese Frage nicht mehr. Somit werden jeden Tag zwischen 50 und 80 Fragen wiederholt, sowie 20 neue gelernt, für jede Zertifizierung einzeln. \ \
#figure(
    image("../assets/fortigate/anki_screenshot_example_faq_open.png", width: 70%),
    caption: "Beispiel einer offenen Karteikarte"
)

== FortiGate Administrator 7.4
In den folgenden Abschnitten werden die einzelnen Kapitel des Zertifikatskurses zusammengefasst.
=== System and Network Settings
Im ersten Kapitel des Kurses lernt man die Grundlagen über die FortiGate, also die Next-Generation Firewall (NGFW) von Fortinet. Man erfährt, wie man sich das erste Mal mit der FortiGate verbinden kann, die Interfaces konfiguriert und DHCP- und VLAN-Einstellungen tätigt. Ebenfalls welche Möglichkeiten der Administration zur Verfügung stehen bzw. die Einschränkung dieser, wie zum Beispiel "trusted Hosts".\ 
Es gibt auch ein Feature um eine Firewall-Instanz in mehrere aufzuteilen: Die einzelnen Virtual-Domains (VDOMs) können (per-default) nicht untereinander kommunizieren und sind dementsprechend gut wenn man mehrere Kunden getrennt verwalten möchte (MSSP).
// backups und updates? oder useless weil eh klar

=== Firewall Policies and NAT
Dieser Teil beschäftigt sich hauptsächlich mit Firewall Policies, diese sind Regeln welche den Datenverkehr zwischen den Interfaces der Firewall einschränken. Es gibt verschiedene Werte welche in einer Policy konfiguriert werden können, um möglichst genau zu bestimmen, welcher Traffic erlaubt oder blockiert wird. Am Wichtigsten sind Ziel- und Quell Interface, hiermit wird bestimmt welche Policies für das aktuelle Paket angewendet werden. Genauer eingeschränkt wird mithilfe von Ziel- und Quelladresse(n): Von wo wohin ist Traffic erlaubt? Welcher User darf ein gewisses Service verwenden, sowie auch um welche Uhrzeiten welcher Datenverkehr erlaubt bzw. verboten wird. Für alle aktuellen Firewalls am Markt gilt ebenfalls das implicit deny: Daten werden grundsätzlich verboten - außer es gibt eine Policy - die sie erlaubt. \

Als Beispiel: Wenn man den Zugriff auf einen FTP-Server einschränken möchte würde man folgendes konfigurieren.

// ACHTUNG !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

In-going Int: LAN \
Out-going Int: DMZ \
Src: LAN1-Adressen \
Dest: FTP-Server-IP \
Service: FTP \
Schedule: Always \
Action: Allow \

Ebenso könnte man Security Profiles auf diese Policy anwenden, darunter fallen zum Beispiel Web Filtering, IPS und Application Control. \


// ACHTUNG !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 Wenn man eine generische Regel sowie eine spezifi vor einer spezifischeren steht, wird die spezifische nie erreicht. Dementsprechend ist es wichtig die genaueren Policies in der Reihenfolge nach oben zu verschieben.
Dies wird mit der Reihenfolge der Regeln ermöglicht.

Zusätzlich wird in diesem Kapitel "Network Address Translation" (NAT) erklärt. NAT ist hauptsächlich dafür da, um private IP-Adressen auf öffentliche zu übersetzen. Da es nicht unendlich viele öffentlichen IP-Adressen gibt, ist dieses Verfahren hilfreich, um diese zu sparen, da mit Hilfe von "Port Address Translation" (PAT) mehrere Adressen auf eine öffentliche zugewiesen werden und dann auch wieder auf die privaten zurück übersetzt. 

=== Routing
Routing ist dafür zuständig, ein Paket von einem Netzwerk an ein anderes weiterzuleiten. Die Schwierigkeit besteht darin, zu wissen, welcher Port mit dem richtigen Netz verbunden ist. Um das Problem zu lösen gibt es Routing Tabellen, in welchen steht, welches Netzwerk über welches Interface erreichbar ist bzw. wohin das Paket gesendet werden muss. \
Bei der FortiGate gibt es zwei Routing Tabellen: Die Routing Information Database (RIB) und die Forwarding Information Database (FIB). In der RIB stehen nur aktive Routen während die FIB die Routing Tabelle aus der Sicht des Kernels darstellt.\
Nachdem es mehrere Routen zum selben Ziel geben kann, werden Parameter benötigt, mit denen die beste Route bestimmt wird. Die beste Route ist somit abhängig von den folgenden Werten:
- Distance: Erster relevante Parameter bei gleichen Routen, welche von unterschiedlichen Protokollen gelernt wurden. Je niedriger dieser Wert desto besser, mit Ciscos Administrativer Distanz vergleichbar, bsp: OSPF: 110, RIP: 120.
- Metric: Relevant bei gleichen Routen welche von dem selben Protokoll gelernt wurden. Abhängig vom verwendeten Protokoll sieht die Metric und die Metric-berechnung unterschiedlich aus. Bei OSPF wären es die Kosten und bei RIP der Hopcount.\
// ACHTUNG !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//hier fehlt noch was, Seite 81

/*Pro Session werden zwei Route-lookups durchgeführt: Beim ersten Paket Richtung Ziel und beim ersten Antwort-Paket.

statische routen
weiter im Routing*/



=== Firewall Authentication
Bei der FortiGate werden nicht nur Geräte und IP-Adressen authentifiziert sondern auch Benutzer und Gruppen. \ // FW Policy 
Es gibt mehrere Methoden um Benutzer zu authentifizieren:
- *local password authentification:* Zugangsdaten werden direkt auf der Firewall gespeichert. Diese Methode wird nicht für Unternehmen mit mehr als einer Firewall empfohlen.
- *Server-bases password authentification:* auch "remote password authentification" genannt, hier werden Zugangsdaten auf POP3, RADIUS, LDAP oder TACACS+ Servern gespeichert.
- *two-factor authentification:* Nur als Erweiterung zu den oben genannten Methoden verfügbar. Zusätzlich zu traditionellem Username und Passwort wird ein Token oder Zertifikat benötigt.

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