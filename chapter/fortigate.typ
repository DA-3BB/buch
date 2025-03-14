#import "@local/htl3r-da:1.0.0" as htl3r
#htl3r.author("Magdalena Feldhofer")

= FCP - Network Security 
Die Zertifizierungsprüfungen des Fortinet Certified Professional (FCP) umfassen die wichtigsten Funktionen der Produkte der Firma Fortinet. Das Zertifikat "FCP - Network Security" besteht aus mehreren Modulen: einem Pflichtmodul, dem FortiGate Administrator und einem optionalen, in meinem Fall, dem FortiManager Administrator. Um das Ziel der Zertifizierungsprüfungen erreichen zu können, wurde der Weg des FAQ#footnote("selbstgeschriebene Frage-Antwort-Paare, um die Inhalte der Zertifizierungsunterlagen zu lernen")-Lernens gewählt. 

== Vorbereitung für den FCP
Von Fortinet wurde dem Team das Training für die Zertifizierung auf der eigenen Fortinet-Lernplattform www.training.fortinet.com freigeschaltet. Dieses beinhaltet Videos, welche die einzelnen Kapitel genau erklären. Da das Lernen nur anhand von Videos nicht ausreichend ist, wurden anhand der schriftlichen Version der Videos Frage-Antwort-Paare in Excel verfasst. Insgesamt wurden für die Zertifizierung "FortiGate Administrator 7.4" 1255-Fragen verfasst und für "FortiManager Administrator 7.4" 475-Fragen. \
#figure(
    image("../assets/fortigate/FAQ_snippet_Excel-3.png", width: 100%),
    caption: "Ausschnitt der Excel-Tabelle mit den FAQs"
)\
Mithilfe von "Anki", einer bekannten App um FAQs zu lernen, wurden die Frage-Antwort-Paare importiert und jeden Tag 20 neue gelernt, sowie die bereits beantworteten Fragen, welche - je nach Schwierigkeitsgrad - früher oder später wiederholt werden sollten. \ 
Ergänzend wurden sogenannte "Labs" durchgeführt, hierfür stellt die Trainingsplattform von Fortinet eine virtuelle Umgebung zur Verfügung, sowie eine Schritt-für-Schritt Anleitung, welche Tasks wie erledigt werden sollen. \
Um die Inhalte des Kurses auch praktisch und intuitiv zu lernen, wurde eine Topologie aufgebaut, in der die wichtigsten Themen implementiert wurden.


=== Training mit FAQs
Jeden Tag wurde eine Anzahl von 20 neuen FAQs gelernt. Man bekommt jeweils eine Frage angezeigt, bei welcher die Antwort noch nicht sichtbar ist. Somit muss man sich zuerst seine eigene Antwort denken, bevor man die korrekte sieht. 
#figure(
    image("../assets/fortigate/anki_screenshot_example_faq_closed.png", width: 50%),
    caption: "Beispiel einer verdeckten Karteikarte"
)
Mit dem Drücken einer Taste auf der Tastatur wird die richtige Antwort sichtbar und man hat vier Auswahlmöglichkeiten, um sein eigenes Wissenslevel einzuschätzen: "Again", "Hard", "Good" und "Easy". Je nachdem wie oft man diese Frage schon beantwortet hat, sieht man neben jeder Möglichkeit eine Zeitangabe in Minuten/Tagen/Monaten, wann man diese Frage wieder beantworten muss. Wenn man also eine Frage schon mehrmals beantwortet hat und gerade wieder, würde man die Option "Good" oder "Easy" wählen, neben welcher "1.1Mo" steht, diese Frage muss man in 1.1 Monaten wieder beantworten, bis dahin erscheint diese Frage nicht mehr. Somit werden jeden Tag zwischen 50 und 80 Fragen wiederholt, sowie 20 neue gelernt, für jede Zertifizierung einzeln. \ \
#figure(
    image("../assets/fortigate/anki_screenshot_example_faq_open.png", width: 70%),
    caption: "Beispiel einer offenen Karteikarte"
)

#pagebreak()

== FortiGate Administrator 7.4
In den folgenden Abschnitten werden die Kapitel des Zertifikatskurses zusammengefasst.
=== System and Network Settings
Im ersten Kapitel des Kurses lernt man die Grundlagen über die FortiGate, also die Next-Generation Firewall (NGFW) von Fortinet. Man erfährt, wie man sich das erste Mal mit der FortiGate verbinden kann, die Interfaces konfiguriert und DHCP- und VLAN-Einstellungen tätigt. \ 
Im folgenden Bild erkennt man die physischen Ports eins bis drei, welche mit Aliassen versehen sind (bsp.: Port3 --> Inet), für die leichtere Lesbarkeit der Konfiguration. Jedes der angezeigten Interfaces hat eine IP-Adresse zugewiesen, sei es via DHCP oder statisch. Dieser Unterschied kann aus der Grafik allerdings nicht entnommen werden, dafür ist ein tieferer Einblick notwendig. In der letzten Spalte sieht man die Protokolle "Ping", "HTTPS", "SSH" und "HTTP", diese Protokolle sind für den administrativen Zugriff auf die FortiGate, auf diesen Interfaces erlaubt.  
#figure(
    image("../assets/fortigate/interface-overview.png", width: 100%),
    caption: "Konfigurationsübersicht der Interfaces"
)
Die selbe Konfiguration kann mit den folgenden CLI-Befehlen erreicht werden:\
#htl3r.code-file(
  caption: "Interface-Konfiguration-Beispiel",
  filename: ["fortigate/interface-configuration.conf"],
  lang: "",
  //ranges: ((0, 0),),
  //skips: ((0, 0),),
  text: read("../assets/fortigate/interface-configuration.conf")
)

Das Kapitel umfasst ebenfalls, welche Möglichkeiten der Administration zur Verfügung stehen bzw. die Einschränkung dieser, wie zum Beispiel "trusted Hosts".Hiermit wird der Zugriff auf bestimmte Administrator-Konten nur von definierten IP-Adressen zugelassen, im folgenden Beispiel ist es der host "172.16.1.4".

#figure(
    image("../assets/fortigate/trusted-hosts.png", width: 100%),
    caption: "Beispielkonfiguration eines trusted hosts"
)

Es gibt auch eine Funktion, um eine Firewall-Instanz in mehrere aufzuteilen: Die einzelnen Virtual-Domains (VDOMs) können (per-default) nicht untereinander kommunizieren und sind dementsprechend gut wenn man mehrere Kunden getrennt verwalten möchte (MSSP).
// backups und updates? oder useless weil eh klar

=== Firewall Policies and NAT
Dieser Teil beschäftigt sich hauptsächlich mit Firewall Policies, diese sind Regeln welche den Datenverkehr zwischen den Interfaces der Firewall einschränken. Es gibt verschiedene Werte welche in einer Policy konfiguriert werden können, um möglichst genau zu bestimmen, welcher Traffic erlaubt oder blockiert wird. Am Wichtigsten sind Ziel- und Quell Interface, hiermit wird bestimmt welche Policies für das aktuelle Paket angewendet werden. Genauer eingeschränkt wird mithilfe von Ziel- und Quelladresse(n): Von wo wohin ist Traffic erlaubt? Welcher User darf ein gewisses Service verwenden, sowie auch um welche Uhrzeiten welcher Datenverkehr erlaubt bzw. verboten wird. Für alle aktuellen Firewalls am Markt gilt ebenfalls das Prinzip des "implicit deny": Daten werden grundsätzlich verboten - außer es gibt eine Policy - die sie erlaubt. \

Als Beispiel: Wenn man den Zugriff für das lokale LAN ins Internet erlauben möchte, würde man folgende Werte setzen:

// Netzplan!!!!!!!!!!!!!!!!!!

#figure(
    image("../assets/fortigate/provisiorisches_Policy_Bild.png", width: 60%),
    caption: "Provisorisches Bild einer Policy Konfiguration, wird noch ausgebessert"
)\



// Achtung leere Referenzen bzw fehlende referenzen
Ebenso könnte man Security Profiles auf diese Policy anwenden. Security Profiles sind erweitenderne Funktionen um das Netzwerk bestmöglich abzusichern, die folgenden sind die relevantesten:
- *AntiVirus:* Pakete werden mit einer Datenbank an Viren und Malware verglichen und anhand des Resultats verworfen oder erlaubt. Weiteres dazu siehe /*#ref(<antivirus>)*/ Kapitel Antivirus
- *Web Filter:* Schränkt Web-Site Zugriff anhand von Kategorien ein. Näheres dazu siehe 
- *Application Control:* Der Traffic wird auf Applikations-Signaturen untersucht. Mehr dazu siehe
- *IPS:* Analysiert den Traffic anhand von Sessions und vergleicht die Erkenntnisse mit Signaturen aus der IPS-Datenbank. Genaueres siehe 
- *SSL Inspection:* Web-Traffic wird auf Angriffe untersucht. Weiteres dazu siehe 


Wenn man Policies erstellt, muss man darauf achten, dass man sie richtig reiht. Wenn man zwei Policies hat, wobei die eine spezifische Situationen abdeckt und die zweite nur generelle, sollte die spezifischere an erste Stelle in der Reihung kommen, da es sonst sein kann, dass sie nie angewandt wird, weil die generische ebenfalls zutrifft. 
 
Zusätzlich wird in diesem Kapitel "Network Address Translation" (NAT) erklärt. NAT ist hauptsächlich dafür da, um private IP-Adressen auf öffentliche zu übersetzen, hierbei meist die Quell-Adresse. Da es nicht unendlich viele öffentlichen IP-Adressen gibt, ist dieses Verfahren hilfreich, um diese zu sparen, da mit Hilfe von "Port Address Translation" (PAT) mehrere Adressen auf eine öffentliche zugewiesen werden und dann auch wieder auf die privaten zurück übersetzt. 

* Virtual IPs (VIPs)*
Sind eine eher untypische Art von NAT, da die Ziel-Adresse übersetzt wird. Zu den häufigsten Anwendungsfällen zählt ein Admin-Zugriff von Extern: Ein Administrator verbindet sich von außerhalb des Netzwerks auf eine interne Ressource, um die Ressource aber nicht nach außen sichtbar zu machen, wird sie hinter einer Virtual IP sozusagen versteckt.

* Inspection Modes *
- *Flow-based:* Analysiert den Traffic in Real-time und benötigt weniger Ressourcen als Proxy-based Inspection. Der Fokus liegt auf Performance.
- *Proxy-based:* Speichert den Traffic temporär ab und analysiert ihn in der gesamten länge. Benötigt mehr Ressourcen bietet allerdings mehr Sicherheit. Manche Security Profiles wie Data-leak-prevention sind nur in diesem Modus verfügbar.

=== Routing
Routing ist dafür zuständig, ein Paket von einem Netzwerk an ein anderes weiterzuleiten. Die Schwierigkeit besteht darin, zu wissen, welcher Port mit dem richtigen Netz verbunden ist. Um das Problem zu lösen gibt es Routing Tabellen, in welchen steht, welches Netzwerk über welches Interface erreichbar ist bzw. wohin das Paket gesendet werden muss. \
Bei der FortiGate gibt es zwei Routing-Tabellen: Die Routing Information Database (RIB) und die Forwarding Information Database (FIB). In der RIB stehen nur aktive Routen während die FIB die Routing Tabelle aus der Sicht des Kernels darstellt.\ 

*Equal-Cost-Multipath (ECMP):* Routen des selben Protokolls mit selber Ziel-Adresse, Distance, Metrik und Priority. Alle ECMP Routen stehen in der RIB und es wird automatisch geloadbalanced.
\ 

Nachdem es mehrere Routen zum selben Ziel geben kann, werden Parameter benötigt, mit denen die beste Route bestimmt wird. Die beste Route ist somit abhängig von den folgenden Werten:
- Distance: Erster relevante Parameter bei gleichen Routen, welche von unterschiedlichen Protokollen gelernt wurden. Je niedriger dieser Wert desto besser, mit Ciscos Administrativer Distanz vergleichbar, bsp: OSPF: 110, RIP: 120.
- Metric: Relevant bei gleichen Routen welche von dem selben Protokoll gelernt wurden. Abhängig vom verwendeten Protokoll sieht die Metric und die Metric-berechnung unterschiedlich aus. Bei OSPF wären es die Kosten und bei RIP der Hopcount.\  
- Priority: entscheidend bei statische Routen mit der selben Distance

Reverse Path Forwarding (RPF) ist ein Mechanismus um IP-Spoofing zu verhindern. Hierfür wird die Source-IP auf eine Retour-Route geprüft mittels einer von zwei Optionen:
- *Feasible Path:* Die Retour-Route muss nicht die beste Route sein.
- *Strict:* Die Retour-Route muss die beste Route sein.




=== Firewall Authentication
Bei der FortiGate werden nicht nur Geräte und IP-Adressen authentifiziert sondern auch Benutzer und Gruppen, dies wird durch das Zuordnen von Benutzern zu Firewall Policy Sources ermöglicht. In einer Policy wählt man zusätzlich zu Quell-Adresse User-Objekte aus, erst wenn beide Parameter übereinstimmen wird die Policy angewandt.  \ 
Es gibt zwei Methoden um Benutzer zu authentifizieren:
- *Active:* Benutzer bekommen einen login prompt angezeigt, unterscheidung in:
    - *local password authentification:* Zugangsdaten werden direkt auf der Firewall gespeichert. Diese Methode wird nicht für Unternehmen mit mehr als einer Firewall empfohlen.
    - *Server-bases password authentification:* auch "remote password authentification" genannt, hier werden Zugangsdaten auf POP3, RADIUS, LDAP oder TACACS+ Servern gespeichert.
    - *two-factor authentification:* Nur als Erweiterung zu den oben genannten Methoden verfügbar. Erweiternd zu traditionellem Username und Passwort wird ein Token oder Zertifikat benötigt. \
- *Passive:* Zugabgsberechtigung wird passiv durch Single-Sign-On (SSO) determiniert, User bekommt Authentifizierung nicht mit, unterstützt werden FSSO, RSSO und NTLM. \
Bei aktiver Authentifizierung müssen die Protokolle DNS, HTTP, HTTPS, FTP und Telnet in einer "generellen" Policy erlaubt werden, um das Anzeigen eines Prompts überhaupt möglich zu machen. 

Erwähnenswert ist ebenso, dass nur weil Authentifizierung in einer Policy aktiviert wird, der User nicht automatisch einen Prompt angezeigt bekommt. Es gibt drei Optionen das zu versichern:
- Authentifizierung in jeder Policy aktivieren.
- Über die CLI Authentifizierung erzwingen.
- Captive Portal auf dem Source-Port zu aktivieren.



=== Fortinet Single Sign-On (FSSO)
Single-Sign-On (SSO) ist ein Prozess bei welchem die Identität der Benutzer nur einmal bestätigt werden muss und alle anderen Anwendungen sich die Informationen im Hintergrund von einem SSO Agent organisieren, ohne dass der Benutzer es mitbekommt. Meistens wird SSO in Zusammenhang mit Active Directory oder Novell eDirectory eingesetzt.

Für Active Directory Umgebungen gibt es zwei Methoden des Signle-Sign-On Prozesses:
- *DC agent Mode:* die meistempfohlene Variante, benötigt einen DC-agent auf jedem Domain Controller und einen oder mehrere collector-agents auf Windows Servern. Der Benutzer meldet sich am Domain-Controller an, der DC-agent sieht das Event und leitet es an den collector-agent weiter, welcher es an die FortiGate weiterleitet.
- *Polling Mode: * 
    - *Collector agent-based:* ein collector-agent muss auf jedem Windows Sever installiert werden, es wird jedoch kein DC-agent benötigt. Alle paar Sekunden ruft der agent den DC auf User Events ab und leitet diese an die FortiGate weiter. Es gibt drei Optionen des abrufen eines Domain-Controllers:
        - WMI: eine Windows API mit welcher der collector-agent Queries an den DC schickt. Dadurch, dass der collector-agent nicht nach logon-Events suchen muss, wird die Netzwerkauslastung verringert.
        - WinSecLog: ruft die Security-Logs des DCs ab, muss diese aber nach den Anmelde-Logs durchsuchen, was Zeit kostet.
        - NetAPI: ruft temporäre Sessions ab, welche geöffnet werden, wenn sich ein User an-/abmeldet. Schneller als die anderen Optionen, es kann allerdings passieren, dass Login-Events verpasst werden.
    - *Agentless:* es wird kein zusätzlicher agent benötigt, FortiGate übernimmt das Abfragen der DCs auf Login-Events mittles LDAP. Es entsteht ein höherer Ressourcenaufwand für die FortiGate und es sind weniger Funktionen verfügbar.
// womöglich AD Access Mode erklären (standard & Advanced)

=== Certificate Operations <SSL-Inspection>
// Seite 160
Zertifikate werden einerseits natürlich für User-Authentifizierung verwendet, allerdings auch für Traffic-Inspizierungen. Diese sind Datenverkehr über die FortiGate als auch zu und von ihr, wenn ein Benutzer eine Website über HTTPS aufruft, überprüft die Firewall mithilfe von Zertifikaten, dass die Website vertrauenswürdig ist. \  Revocation- und Validation-Checks stellen sicher, dass das Zertifikat nicht von der Zertifikatsstelle zurückgezogen wurde oder das Gültigkeitsdatum abgelaufen ist.

* SSL Inspection *
Es gibt zwei Arten der Inspizierung, eine entschlüsselt den Datenverkehr und eine nicht:
- *Certificate-Inspection:* Entschlüsselt keinen Traffic sondern analysiert nur den FQDN der Website, somit kann man in den Policies nur Web-Filtering und Application Control von den vielzahl der sonst möglichen Security Profiles anwenden.
- *Full-Inspection:* Hierbei agiert die FortiGate als eine Art Man-in-the-Middle proxy. Es werden von der FortiGate zwei Sessions aufgebaut: eine zum Client und eine zu dem vom Client gewünschten Web-Server. Client und Server sind allerdings aus ihrer Sicht direkt verbunden. Somit wird nicht wirklich eine Verschlüsselung geknackt sondern einfach nur entschlüsselt. Der Sinn hinter dieser Art von Inspection ist es Angriffe zu erkennen, welche sonst versteckt wären. 

Bei der Full-SSL-Inspection kann es allerdings zu *Certificate Warnungen* kommen. Diese werden am Client angezeigt, wenn das FortiGate-eigene-Zertifikat nicht am Client hinterlegt ist.


// maybe seite 164

=== Antivirus <antivirus>
// Seite 194
Die Antivirus-Engine verwendet eine Antivirus-Datenbank mit welcher die Pakete verglichen werden, um Viren und Malware zu erkennen. Es gibt wieder zwei Modi:
- *Flow-based-Inspection:* Dieser Modus ist ein Hybrid aus zwei anderen Modi:
    - *default-scanning:*
    - *legacy-scanning:*
- *Proxy-based-Inspection:*

=== Web Filtering #heading("Web Filtering")
=== Intrusion Prevention and Application Control <IPS_App-control>
=== SSL VPN


// till here



=== IPsec VPN
=== SD-WAN Configuration and Monitoring
=== Security Fabric
=== High Availability
=== Diagnostics and Troubleshooting 



// Quelle alles Kapitel FortiGate Guide 