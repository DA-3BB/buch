#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Magdalena Feldhofer")

#import "@preview/wordometer:0.1.4": word-count, total-words

#show: word-count

= FCP - Network Security 
Die Zertifizierungsprüfungen des #htl3r.full[fcp]  umfassen die wichtigsten Funktionen der Produkte der Firma Fortinet. Das Zertifikat "#htl3r.short[fcp] - Network Security" besteht aus mehreren Modulen: einem Pflichtmodul, dem FortiGate Administrator und einem optionalen, in meinem Fall, dem FortiManager Administrator. Um das Ziel der Zertifizierungsprüfungen erreichen zu können, wurde der Weg des FAQ#footnote("selbstgeschriebene Frage-Antwort-Paare, um die Inhalte der Zertifizierungsunterlagen zu lernen")-Lernens gewählt. 

== Vorbereitung für den FCP
Von Fortinet wurde dem Team das Training für die Zertifizierung auf der Fortinet-Lernplattform `www.training.fortinet.com` freigeschaltet. Dieses beinhaltet Videos, welche die einzelnen Kapitel genau erklären. Da das Lernen nur anhand von Videos nicht ausreichend ist, wurden anhand der schriftlichen Version der Videos Frage-Antwort-Paare in Excel verfasst. Insgesamt wurden für die Zertifizierung "FortiGate Administrator 7.4" 1255-Fragen verfasst und für "FortiManager Administrator 7.4" 475-Fragen. \
#htl3r.fspace(
    figure(
        image("../assets/fortigate/FAQ_snippet_Excel-3.png", width: 100%),
        caption: "Ausschnitt der Excel-Tabelle mit den FAQs"
    )
)\
Mithilfe von "Anki", einer bekannten App um FAQs zu lernen, wurden die Frage-Antwort-Paare importiert und jeden Tag 20 neue gelernt, sowie die bereits beantworteten Fragen, welche - je nach Schwierigkeitsgrad - früher oder später wiederholt werden sollten. \ 
Ergänzend wurden sogenannte "Labs" durchgeführt, hierfür stellt die Trainingsplattform von Fortinet eine virtuelle Umgebung zur Verfügung, sowie eine Schritt-für-Schritt Anleitung, welche Tasks wie erledigt werden sollen. \
Um die Inhalte des Kurses auch praktisch und intuitiv zu lernen, wurde eine Topologie aufgebaut, in der die wichtigsten Themen implementiert wurden.


=== Training mit FAQs
Jeden Tag wurde eine Anzahl von 20 neuen FAQs gelernt. Man bekommt jeweils eine Frage angezeigt, bei welcher die Antwort noch nicht sichtbar ist. Somit muss man sich zuerst seine eigene Antwort denken, bevor man die korrekte sieht. 
#htl3r.fspace(
    figure(
        image("../assets/fortigate/anki_screenshot_example_faq_closed.png", width: 50%),
        caption: "Beispiel einer verdeckten Karteikarte"
    )
)
Mit dem Drücken einer Taste auf der Tastatur wird die richtige Antwort sichtbar und man hat vier Auswahlmöglichkeiten, um sein eigenes Wissenslevel einzuschätzen: "Again", "Hard", "Good" und "Easy". Je nachdem wie oft man diese Frage schon beantwortet hat, sieht man neben jeder Möglichkeit eine Zeitangabe in Minuten/Tagen/Monaten, wann man diese Frage wieder beantworten muss. Wenn man also eine Frage schon mehrmals beantwortet hat und gerade wieder, würde man die Option "Good" oder "Easy" wählen, neben welcher "1.1 Mo" steht, diese Frage muss man in 1.1 Monaten wieder beantworten, bis dahin erscheint diese Frage nicht mehr. Somit werden jeden Tag zwischen 50 und 150 Fragen wiederholt, sowie 20 neue gelernt, für jede Zertifizierung einzeln. \ \
#htl3r.fspace(
    figure(
        image("../assets/fortigate/anki_screenshot_example_faq_open.png", width: 70%),
        caption: "Beispiel einer offenen Karteikarte"
    )
)

#pagebreak()

== FortiGate Administrator 7.4
In den folgenden Abschnitten werden die Kapitel des Zertifikatskurses zusammengefasst.
=== System und Netzwerk Einstellungen
Im ersten Kapitel des Kurses lernt man die Grundlagen über die FortiGate, die #htl3r.full[ngfw] von Fortinet. Man erfährt, wie man sich das erste Mal mit der FortiGate verbinden kann, die Interfaces konfiguriert und #htl3r.short[dhcp]- und #htl3r.short[vlan]-Einstellungen tätigt. \ 
Im folgenden Bild erkennt man die physischen Ports eins bis drei, welche mit Aliassen versehen sind (bsp.: Port3 --> Inet), für die leichtere Lesbarkeit der Konfiguration. Jedes der angezeigten Interfaces hat eine IP-Adresse zugewiesen, sei es via #htl3r.short[dhcp] oder statisch. Dieser Unterschied kann aus der Grafik allerdings nicht entnommen werden, dafür ist ein tieferer Einblick notwendig. In der letzten Spalte sieht man die Protokolle "Ping", "#htl3r.short[https]", "#htl3r.short[ssh]" und "#htl3r.short[http]", diese Protokolle sind für den administrativen Zugriff auf die FortiGate, auf diesen Interfaces erlaubt.  
#htl3r.fspace(
    figure(
        image("../assets/fortigate/interface-overview.png", width: 100%),
        caption: "Konfigurationsübersicht der Interfaces"
    )
)

Die selbe Konfiguration kann mit den folgenden #htl3r.short[cli]-Befehlen erreicht werden:\
#htl3r.code-file(
  caption: "Interface-Konfiguration-Beispiel",
  filename: ["fortigate/interface-configuration.conf"],
  lang: "",
  text: read("../assets/fortigate/interface-configuration.conf")
)

Das Kapitel umfasst ebenfalls, welche Möglichkeiten der Administrierung zur Verfügung stehen bzw. die Einschränkung dieser, wie zum Beispiel "trusted hosts". Hiermit wird der Zugriff auf bestimmte Administrator-Konten nur von definierten IP-Adressen zugelassen, im folgenden Beispiel ist es der host "172.16.1.4".

#htl3r.fspace(
    figure(
        image("../assets/fortigate/trusted-hosts.png", width: 70%),
        caption: "Beispielkonfiguration eines trusted hosts"
    )
)

Es gibt auch eine Funktion, um eine Firewall-Instanz in mehrere aufzuteilen: Die einzelnen #htl3r.full[vdom] können (per-default) nicht untereinander kommunizieren und sind dementsprechend hilfreich, wenn man mehrere Kunden getrennt verwalten möchte, beispielsweise als Managed Security Service Provider (MSSP).

=== Firewall Policies und NAT
Firewall Policies sind Regeln welche den Datenverkehr zwischen den Interfaces der Firewall einschränken. Es gibt verschiedene Werte welche in einer Policy konfiguriert werden können, um möglichst genau zu bestimmen, welcher Traffic erlaubt oder blockiert wird. Am Wichtigsten sind Quell- und Ziel-Interface, hiermit wird bestimmt welche Policies für das aktuelle Paket angewendet werden. Genauer eingeschränkt wird mithilfe von Quell- und Zieladressen: Von wo wohin ist Traffic erlaubt? Welcher User darf ein gewisses Service verwenden, sowie auch um welche Uhrzeiten welcher Datenverkehr erlaubt bzw. verboten wird. Für alle aktuellen Firewalls am Markt gilt ebenfalls das Prinzip des "implicit deny": Datenweiterleitung wird grundsätzlich verboten - außer es gibt eine Policy - die es erlaubt. \

Als Beispiel: Die folgende Grafik zeigt ein einfaches Netzwerk (linke Seite), mit einer Firewall als Trennung zwischen #htl3r.short[lan] und dem Internet (Wolke der rechten Seite).

#htl3r.fspace(
    figure(
        image("../assets/fortigate/szenario_policy.png", width: 80%),
        caption: "Netzplan für die folgende Beispielkonfiguration einer Policy"
    )
)
Wenn man den Zugriff für das #htl3r.short[lan] ins Internet erlauben möchte, wobei nur Adressen des #htl3r.short[lan]s sowie die User in der Gruppe "Internet_Access" zugelassen werden, würde man folgende Werte setzen:
#htl3r.fspace(
    figure(
        image("../assets/fortigate/simple_policy.png", width: 80%),
        caption: "Beispielhafte Policy Konfiguration"
    )
)

Die selbe Konfiguration ist auch über die #htl3r.short[cli] möglich:
#htl3r.code-file(
  caption: "Firewall-Policy Konfigurationsbeispiel",
  filename: ["fortigate/firewall-policy.conf"],
  lang: "",
  text: read("../assets/fortigate/firewall_policy.conf")
)


#htl3r.full[nat] ist hauptsächlich dafür zuständig, private IP-Adressen auf öffentliche zu übersetzen, hierbei meist die Quell-Adresse. Da es nicht unendlich viele öffentlichen IP-Adressen gibt, ist dieses Verfahren hilfreich, um diese zu sparen, da mit Hilfe von #htl3r.full[pat] mehrere Adressen auf eine öffentliche zugewiesen werden und dann auch wieder auf die privaten zurück zu übersetzen. NAT übersetzt Adressen entweder anhand der outgoing-IP-Adresse des Interfaces oder anhand eines Pools. Das folgende Bild zeigt die NAT-Konfigurationsoptionen, welche pro Firewall-Policy zur Verfügung stehen:
#htl3r.fspace
    #figure(
        image("../assets/fortigate/policy_NAT.png", width: 80%),
        caption: "Beispielhafte Policy Konfiguration"
    )
)
#htl3r.code-file(
  caption: "Firewall-Policy NAT Konfigurationsbeispiel",
  filename: ["fortigate/firewall-policy-nat.conf"],
  lang: "",
  text: read("../assets/fortigate/firewall_policy_nat.conf")
)

Beim Erstellen von Policies ist die Reihenfolge entscheidend: Eine spezifische Policy sollte vor einer generellen stehen, da sie sonst möglicherweise nie angewandt wird, weil die generelle zuerst greift. \ Angenommen wir haben einen Webserver auf den alle innerhalb des Netzwerkes zugreifen können, ausgenommen von einem User. Dann müsste man zuerst die Policy zum Blockieren dieses Users erstellen und in der Reihenfolge danach die Full-Access Policy. Wenn die Full-Access Policy zuerst wäre, könnte der User auch zugreifen.
 

#htl3r.full[vip] sind eine spezielle Art von #htl3r.short[nat], da die Ziel-Adresse übersetzt wird. Die Konfiguration einer VIP reicht allerdings noch nicht um sie anzuwenden, dafür muss sie mit einer Firewall-Policy erlaubt werden. \ 
Zu den häufigsten Anwendungsfällen zählt ein Admin-Zugriff von Extern: Ein Administrator verbindet sich von außerhalb des Netzwerks auf eine interne Ressource, um die Ressource aber nicht nach außen sichtbar zu machen, wird sie hinter einer #htl3r.long[vip] sozusagen versteckt. Ein weiterer Anwendungsbereich sind Server welche nach Außen unter einer öffentlichen IP-Adresse sichtbar sind, während sie intern eine private verwenden. Die folgende Grafik zeigt eine #htl3r.short[vip] für einen Web-Server:

#htl3r.fspace(
    figure(
        image("../assets/fortigate/VIPs.png", width: 80%),
        caption: "Beispielhafte VIP Konfiguration"
    )
)

#htl3r.code-file(
  caption: "VIP Konfigurationsbeispiel",
  filename: ["fortigate/VIP.conf"],
  lang: "",
  text: read("../assets/fortigate/VIP.conf")
)

=== Routing
Routing ist dafür zuständig, ein Paket von einem Netzwerk an ein anderes weiterzuleiten. Die Schwierigkeit besteht darin, zu wissen, welcher Port mit dem richtigen Netz verbunden ist. Um das Problem zu lösen gibt es Routing Tabellen, in welchen steht, welches Netzwerk über welches Interface erreichbar ist bzw. wohin das Paket gesendet werden muss. \
Bei der FortiGate gibt es zwei Routing-Tabellen: Die #htl3r.full[rib] und die #htl3r.full[fib]. In der #htl3r.short[rib] stehen nur aktive Routen während die #htl3r.short[fib] die Routing Tabelle aus der Sicht des Kernels darstellt.\ 

#htl3r.full[ecmp]: Routen des selben Protokolls mit selber Ziel-Adresse, Distance, Metrik und Priority. Alle #htl3r.short[ecmp] Routen stehen in der #htl3r.short[rib] und es wird automatisch geloadbalanced.
\ 

Nachdem es mehrere Routen zum selben Ziel geben kann, werden Parameter benötigt, mit denen die beste Route bestimmt wird. Die beste Route ist somit abhängig von den folgenden Werten:
- Distance: Erster relevante Parameter bei gleichen Routen, welche von unterschiedlichen Protokollen gelernt wurden. Je niedriger dieser Wert desto besser, mit Ciscos Administrativer Distanz vergleichbar, bsp: #htl3r.short[ospf]: 110, #htl3r.short[rip]: 120.
- Metric: Relevant bei gleichen Routen welche von dem selben Protokoll gelernt wurden. Abhängig vom verwendeten Protokoll sieht die Metric und die Metric-berechnung unterschiedlich aus. Bei #htl3r.full[ospf] wären es die Kosten und bei #htl3r.full[rip] der Hopcount.\  
- Priority: Entscheidend bei statische Routen mit der selben Distance.

#htl3r.full[rpf] ist ein Mechanismus um IP-Spoofing zu verhindern. Hierfür wird die Source-IP auf eine Retour-Route geprüft mittels einer von zwei Optionen:
- Feasible Path: Die Retour-Route muss nicht die beste Route sein.
- Strict: Die Retour-Route muss die beste Route sein.
Die generelle Funktion wird wie folgt pro Interface angewandt, während die Art des #htl3r.short[rpf] systemweit gilt. Man kann dementsprechend pro Interface entscheiden, ob das Paket auf eine Retour-Route überprüft werden soll, jedoch nicht ob Feasible Path oder Strict RPF verwendet werden soll, da dies Systemweit eingestellt wird.

#htl3r.code-file(
  caption: "RPF Konfigurationsbeispiel",
  filename: ["fortigate/RPF.conf"],
  lang: "",
  text: read("../assets/fortigate/rpf.conf")
)


=== Firewall Authentication
Bei der FortiGate werden nicht nur Geräte und IP-Adressen authentifiziert sondern auch Benutzer und Gruppen, dies wird durch das Zuordnen von Benutzern zu Firewall Policy Sources ermöglicht. In einer Policy wählt man zusätzlich zu Quell-Adresse User-Objekte aus, erst wenn beide Parameter übereinstimmen wird die Policy angewandt.  \ 
Es gibt zwei Methoden um Benutzer zu authentifizieren:
- Active: Benutzer bekommen einen login prompt angezeigt, unterscheidung in:
    - local password authentification: Zugangsdaten werden direkt auf der Firewall gespeichert. Diese Methode wird nicht für Unternehmen mit mehr als einer Firewall empfohlen.
    - Server-bases password authentification: auch "remote password authentification" genannt, hier werden Zugangsdaten auf POP3, RADIUS, LDAP oder TACACS+ Servern gespeichert.
    - two-factor authentification: Nur als Erweiterung zu den oben genannten Methoden verfügbar. Erweiternd zu traditionellem Username und Passwort wird ein Token oder Zertifikat benötigt. \
- Passive: Zugangsberechtigung wird passiv durch #htl3r.full[sso] determiniert, User bekommt Authentifizierung nicht mit, unterstützt werden FSSO, RSSO und NTLM. \


Bei aktiver Authentifizierung müssen die Protokolle #htl3r.short[dns], #htl3r.short[http], #htl3r.short[https], #htl3r.short[ftp] und Telnet in einer "generellen" Policy erlaubt werden, um das Anzeigen eines Prompts überhaupt möglich zu machen. 

Erwähnenswert ist ebenso, dass nur weil Authentifizierung in einer Policy aktiviert wird, der User nicht automatisch einen Prompt angezeigt bekommt. Wenn es eine "Fall-Through Policy" gibt, eine Policy welche zutrifft wenn alles andere nicht matched wird diese genommen, anstatt dem User einen Login-Screen anzuzeigen. Um  Es gibt drei Optionen um die User-Authentifizierung zu versichern:
- Authentifizierung in jeder Policy aktivieren.
- Über die #htl3r.short[cli] Authentifizierung erzwingen.
- Captive Portal auf dem Source-Port zu aktivieren.
#pagebreak()
Folgende Bilder zeigen die Erstellung eines lokalen Benutzers auf der FortiGate:\ 


1. Art des Kontos bestimmen:
#htl3r.fspace(
    figure(
        image("../assets/fortigate/user-create1.png", width: 40%),
        caption: "Benutzer erstellen Schritt 1"
    )
)
2. Benutzername und Passwort setzen:
#htl3r.fspace(
    figure(
        image("../assets/fortigate/user-create2.png", width: 70%),
        caption: "Benutzer erstellen Schritt 2"
    )
)
3. Falls gewollt Zwei-Faktor Authentifizierung aktivieren:
#htl3r.fspace(
    figure(
        image("../assets/fortigate/user-create3.png", width: 80%),
        caption: "Benutzer erstellen Schritt 3"
    )
)
4. Benutzerkonto aktivieren und wenn gewollt zu Gruppen hinzufügen:
#htl3r.fspace(    
    figure(
        image("../assets/fortigate/user-create4.png", width: 80%),
        caption: "Benutzer erstellen Schritt 4"
    )
)


=== Fortinet Single Sign-On
#htl3r.full[sso] ist ein Prozess bei welchem die Identität der Benutzer nur einmal bestätigt werden muss und alle anderen Anwendungen sich die Informationen im Hintergrund von einem #htl3r.short[sso]-Agent organisieren, ohne dass der Benutzer es mitbekommt. Meistens wird #htl3r.short[sso] in Zusammenhang mit Active Directory oder Novell eDirectory eingesetzt.

Für Active Directory Umgebungen gibt es zwei Methoden des #htl3r.long[sso] Prozesses:
- #htl3r.short[dc]-Agent Mode: die empfohlene Variante, benötigt einen #htl3r.short[dc]-agent auf jedem #htl3r.long[dc] und einen oder mehrere collector-agents auf Windows-Servern. Der Benutzer meldet sich am  #htl3r.long[dc] an, der  #htl3r.short[dc]-agent sieht das Event und leitet es an den collector-agent weiter, welcher es an die FortiGate weiterleitet.
- Polling Mode:
    - Collector agent-based: ein collector-agent muss auf jedem Windows Sever installiert werden, es wird jedoch kein  #htl3r.short[dc]-agent benötigt. Alle paar Sekunden ruft der agent den  #htl3r.long[dc] auf User Events ab und leitet diese an die FortiGate weiter. Es gibt drei Optionen des abrufen eines  #htl3r.short[dc]:
        - #htl3r.short[wmi]:  #htl3r.long[wmi] eine Windows API mit welcher der collector-agent Queries an den  #htl3r.short[dc] schickt. Dadurch, dass der collector-agent nicht nach logon-Events suchen muss, wird die Netzwerkauslastung verringert.
        - WinSecLog: ruft die Security-Logs des  #htl3r.short[dc]s ab, muss diese aber nach den Anmelde-Logs durchsuchen, was Zeit kostet.
        - NetAPI: ruft temporäre Sessions ab, welche geöffnet werden, wenn sich ein User an-/abmeldet. Schneller als die anderen Optionen, es kann allerdings passieren, dass Login-Events verpasst werden.
    - Agentless: es wird kein zusätzlicher agent benötigt, FortiGate übernimmt das Abfragen der  #htl3r.short[dc]s auf Login-Events mittles  #htl3r.short[ldap]. Es entsteht ein höherer Ressourcenaufwand für die FortiGate und es sind weniger Funktionen verfügbar.

Beispiel: #htl3r.short[dc]-agent mode, nachdem die #htl3r.short[dc]-agents und collector-agent in der Domäne installiert wurden, wird auf der FortiGate folgendes entweder über die #htl3r.short[gui] oder #htl3r.short[cli] Konfiguriert:
#htl3r.fspace(
    figure(
        image("../assets/fortigate/collector-agent-config.png", width: 80%),
        caption: "Collector-agent Einbindung"
    )
)

#htl3r.code-file(
  caption: "Einbindung des collector-agents",
  filename: ["fortigate/collector-agent.conf"],
  lang: "",
  text: read("../assets/fortigate/collector_agent.conf")
)


// maybe seite 164



=== Certificate Operations <SSL-Inspection>
Zertifikate werden einerseits natürlich für User-Authentifizierung verwendet, allerdings auch für Traffic-Inspizierungen. Wenn ein Benutzer eine Website über HTTPS aufruft, überprüft die Firewall mithilfe von Zertifikaten, dass die Website vertrauenswürdig ist. \  Revocation- und Validation-Checks stellen sicher, dass das Zertifikat nicht von der Zertifikatsstelle zurückgezogen wurde oder das Gültigkeitsdatum abgelaufen ist.

=== SSL Inspection 
Es gibt zwei Arten der Inspizierung, eine entschlüsselt den Datenverkehr und eine nicht:
- Certificate-Inspection: Entschlüsselt keinen Traffic sondern analysiert nur den FQDN der Website, somit kann man in den Policies nur Web-Filtering und Application Control von den vielzahl der sonst möglichen Security Profiles anwenden.
- Full-Inspection: Hierbei agiert die FortiGate als eine Art Man-in-the-Middle proxy. Es werden von der FortiGate zwei Sessions aufgebaut: eine zum Client und eine zu dem vom Client gewünschten Web-Server. Client und Server sind allerdings aus ihrer Sicht direkt verbunden. Somit wird nicht wirklich eine Verschlüsselung geknackt sondern einfach nur entschlüsselt. Der Sinn hinter dieser Art von Inspection ist es Angriffe zu erkennen, welche sonst versteckt wären. 

Bei der Full-SSL-Inspection kann es allerdings zu Zertifikat-Warnungen kommen. Diese werden am Client angezeigt, wenn das FortiGate-eigene-Zertifikat nicht am Client hinterlegt ist, oder die FortiGate kein Zertifikat der CA ausgestellt bekommen hat.

Es sind default Profile vorhanden, das Sperrsymbol zeigt, dass diese Profile nicht bearbeitet werden können. Zusätzlich zu dem anpassbaren "custom-deep-inspection profile" können auch eigene Profile erstellt werden.
#htl3r.fspace(
    figure(
        image("../assets/fortigate/ssl-inspection-profiles.png", width: 80%),
        caption: "Default SLL-Profile"
    )
)

Beim Konfigurieren der  SSL-Optionen kann man wählen welche Richtung inspiziert wird (Ingoing/Outgoing). "Multiple Clients Connecting to Multiple Servers" ist Outgoing und ist gedacht um den Webtraffic der eigenen Mitarbeiter einzuschränken. 
#htl3r.fspace(
    figure(
        image("../assets/fortigate/SSL-inspection_options.png", width: 80%),
        caption: "SSL-Profile Optionen"
    )
)

Die Konfiguration des Profiles reicht allerdings noch nicht aus, um den Traffic zu filtern. Dafür muss das Profile in einer Firewall Policy angewandt werden und mit einem anderen Security Profile eingesetzt werden, da SSL-Inspection noch nicht das Abfangen bzw Inspizieren der Daten auslöst. 
Zusätzlich dazu, wenn man im Profile "Deep Inspection" auswählt muss man darauf achten, dass in der Firewall Policy der Mode Proxy-based-Inspection ist.





=== Security Profiles <sec_prof>
Security Profiles sind erweiternde Funktionen, welche das Netzwerk bestmöglich gegen Angriffe schützen, sie werden pro Firewall Policy konfiguriert. 

==== Inspection Modes 
Auf jeder Firewall Policy kann der Modus ausgewählt werden, mit welchem die zutreffenden Daten inspiziert werden, sie unterscheiden sich hauptsächlich in Sicherheit und Performance.

- Flow-based: Analysiert den Traffic in Real-time und benötigt weniger Ressourcen als Proxy-based Inspection. Der Fokus liegt auf Performance.
- Proxy-based: Speichert den Traffic temporär ab und analysiert ihn in der gesamten Länge. Benötigt mehr Ressourcen bietet allerdings mehr Sicherheit. Manche Security Profiles wie #htl3r.full[dlp] sind nur in diesem Modus verfügbar.

Beide Modi sind für die meisten Security Profiles verfügbar, es gibt Ausnahmen wie zum Beispiel DLP, welches nur im proxy-mode verfügbar ist. \ 
Achtung: Der Modus des Security Profiles muss mit dem Modus der Firewall-Policy übereinstimmen! Wenn zum Beispiel bei einem Antivirus Profil der Modus Proxy-based-Inspection ist, muss die Firewall-Policy ebenfalls diesen Modus haben.

==== Antivirus <antivirus>
// Seite 194 
Eines der Security Profiles ist Antivirus (AV). Es gibt eine Antivirus-Engine welche verwendet wird, um anhand einer Antivirus-Datenbank, Viren und Malware zu erkennen. Für das Paket wird anhand gewisser Parameter eine Signatur erstellt, welche mit den Einträgen der AV-Datenbank verglichen wird. In der Datenbank stehen eine Vielzahl an Signaturen welche aus bereits bekannten Angriffen generiert wurden. \ 
Es gibt zwei Modi:
- Flow-based-Inspection: Dieser Modus ist ein Hybrid aus zwei anderen Modi:
    - Default-scanning: Macht es möglich verschachtelte Ordner zu inspizieren, ohne das ganze Container-file im Buffer zu speichern.
    - Legacy-scanning: Speichert den ganzen Container und inspiziert ihn anschließend.
    Anhand des folgenden Bildes lässt sich das System am besten erklären. Alle Pakete, bis auf das letzte, werden an die Antivirus-Engine geschickt und zusätzlich auch an den Client. Das letzte Paket wird nur an die Engine geschickt, dort werden die Pakete zusammengefügt und es wird eine Signatur generiert, wenn diese in der AV-Datenbank befindet, ist es ein Virus. Falls ein Virus erkannt wird, wird das letzte Paket nicht an den Client weitergeleitet. Auch wenn der Großteil des Viruses schon am Client angekommen ist, ist es ungefährlich, da der Virus alle Pakete benötigt. Wenn die Pakete als ungefährlich eingestuft werden, wird das letzte Paket auch an den Client weitergeleitet.
    #htl3r.fspace(
        figure(
            image("../assets/fortigate/AV_flow.jpg", width: 100%),
            caption: "AV flow-based-inspection Visualisierung Quelle:https://community.fortinet.com/t5/Support-Forum/What-flow-based-inspection-do-with-packets/m-p/70425"
        )
    )

    Normalerweise wäre Flow-based-Inspection weniger Ressourcenintensiv, da aber die Pakete sowohl an die Engine als auch Client geschickt werden, wird mehr CPU-Aufwand benötigt.

    
- Proxy-based-Inspection:
    #htl3r.fspace(
        figure(
            image("../assets/fortigate/AV_proxy.jpg", width: 100%),
            caption: "AV proxy-based-inspection Visualisierung Quelle: https://networkinterview.com/fortigate-utm-unified-threat-management/"
        )
    )
    Alle Pakete werden nur an die Antivirus-Engine geschickt und nicht an den Client. In der Engine werden die Pakete zusammengefügt und es wird eine Signatur generiert, wenn sich diese in der AV-Datenbank befindet, ist es ein Virus. Falls ein Virus erkannt wird, werden keine Daten an den Client weitergeleitet. Wenn die Pakete als ungefährlich eingestuft werden, werden alle Pakete an den Client weitergeleitet.
    \
    Da während des Scannings noch keine Daten am Client ankamen, kann es zu timeouts kommen. Um diese zu vermeiden kann man "Client comforting" aktivieren, hierbei werden ganz langsam Pakete weitergeleitet, um ein Session-timeout zu vermeiden.

Falls ein Virus erkannt wird, wird dem Client eine Block-Webpage angezeigt.

#htl3r.fspace(
        figure(
            image("../assets/fortigate/av-block-page.png", width: 80%),
            caption: "Block-Page des Eicar-Testfiles"
        )
    )
// image von profile config + config file
#htl3r.fspace(
        figure(
            image("../assets/fortigate/AV-profile.png", width: 80%),
            caption: "GUI-Konfiguration eines Antivirus-Profiles"
        )
    )

#htl3r.code-file(
  caption: "CLI-Konfiguration eines Antivirus-Profiles",
  filename: ["fortigate/av-config.conf"],
  lang: "",
  text: read("../assets/fortigate/av-config.conf")
)
Bei dem Profil wählt man hauptsächlich das Feature-Set und die Protokolle, welche inspiziert werden sollen. Die Protokolle mit einem roten "P" sind nur im Proxy-based-Mode verfügbar. Es gibt ebenfalls die Option gefundene Malware nicht zu Blockieren sonder nur zu Monitoren, also Zulassen und Loggen.


   // Seite 197

=== Web Filtering
Filtert Websites anhand bestimmter Parameter, sobald eine Session aufgebaut ist. Hierbei gibt es wieder die bereits bekannten Inspection Modi:
- Flow-based-Inspection: Traffic wird inspiziert, während er ebenfalls an den Client geschickt wird. Die Daten werden allerdings nicht verändert, dementsprechend sind einige Funktionen nicht verfügbar.
- Proxy-based-Inspection: Traffic wird von der Firewall abgefangen, ohne der Adressat zu sein, deswegen ist der Mode auch "Transparent" genannt. 

// Anhand der SSL-Inspection in @SSL-Inspection und der Form dieser





=== Intrusion Prevention and Application Control <IPS_App-control>


// till here



=== IPsec VPN
=== SD-WAN Configuration and Monitoring
#htl3r.full[sdwan] ein Teil von #htl3r.full[sdn], dabei dreht sich alles um einen dynamisches effizienten und Applikations-basierten Weiterleitungsprozess. Die #htl3r.short[sdwan] Lösung von Fortinet nennt sich Secure #htl3r.short[sdwan], da mithilfe der FOrtiOS-Funktionen Sicherheit automatisch implementiert wird. Dafür werden Features wie IPsec, Link Überwachung, fortgeschrittenes Routing, traffic Shaping und UTM-Inspection verwendet. Anhand von Protokoll, Service oder Applikation werden die Daten weitergeleitet. Allerdings funktioniert #htl3r.short[sdwan] nur für Outgoing-Traffic, das Retour-Paket könnte also einen anderen Pfad nehmen. \

Der häufigste Anwendungsfall von #htl3r.short[sdwan], laut Fortinet, ist DIA - Direct Internet Access. Hierbei gibt es mehrere Uplinks, welche sich in Kosten und Performance unterscheiden. Kritischer Traffic wird über die Links mit der besten Performance weitergeleitet, während non-critical Traffic nach einem best-effort System übertragen wird. Die teuersten Links werden entweder nur als Backup oder nur für den kritischen Traffic verwendet.

Ein weiterer Anwendungsfall ist Site-to-Site Traffic, also die Verbindung von Standorten. Als Underlay werden typischerweise physische Links verwendet oder auch LTE-Verbindungen, MPLS, DSL und ATM. Über diese teils unsicheren Links werden sichere Verbindungen aufgebaut, wie zum Beispiel IPsec-Verbindungen. 

#htl3r.short[sdwan] besteht aus mehreren Teilen:
- Members: Logische oder physische Interfaces 
- Zones: Gruppieren Members für eine optimierte Konfiguration
- Performance SLAs: Führen 

=== High Availability

// Quelle alles Kapitel FortiGate Guide 




#total-words Words insgesamt