#import "@preview/htl3r-da:2.0.0" as htl3r
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#htl3r.author("Albin Gashi")

= Netzwerküberwachung <fsm>
Für die Implementierung eines #htl3r.full[siem] in die Topologie wird ein FortiSIEM der Firma Fortinet verwendet. Es kann agent-based oder agentless Logs und Events von Geräten abrufen. In den meisten Fällen wird Syslog oder #htl3r.short[snmp] zur Kommunikation der Geräte mit dem #htl3r.short[siem] verwendet. Es gibt aber auch Ausnahmen, wie im Falle von Windows. Windows Server können entweder mittels #htl3r.full[wmi] oder dem FortiSIEM Windows Agent Daten an das #htl3r.short[siem] übermitteln. Der Vorteil an den Agents liegt darin, dass Logs direkt am Gerät geparst und verschickt werden können, statt mehrere Logs in einem bestimmten Intervall durch das FortiSIEM abzurufen @fortisiem.

Des Weiteren kann das FortiSIEM Basismetriken durch das #htl3r.full[pam] abrufen. Dies beinhaltet Daten wie den Zustand einer Applikation, Ressourcenverbrauch eines Geräts und vieles mehr. Dadurch können Anomalien in den Daten erkannt werden und Warnungen im FortiSIEM auslösen.

== FortiSIEM-Zertifizierung <fsm-cert>
Zum Aneignen des Zertifizierungswissens und als Training für die Zertifikatsprüfung wurden die Labor-Übungen vom FortiSIEM Kurs durchgeführt. Diese wurden in elf Kapitel unterteilt, die an die Kapitel aus dem Online-Kurs angelehnt sind:

1. #emph("FortiSIEM Introduction")
2. #emph(htl3r.short[siem] + " and " + htl3r.short[pam] + " Concepts")
3. #emph("Discovery")
4. #emph("FortiSIEM Analytics")
5. #emph("CMDB Lookups and Filters")
6. #emph("Group By and Data Aggregation")
7. #emph("Rules")
8. #emph("Incidents and Notificaiton Policies")
9. #emph("Reports")
10. #emph("Business Services")
11. #emph("Troubleshooting")

== Grundkonfiguration des FortiSIEMs <fsm-cert-conf>

Für den Betrieb eines FortiSIEMs sind Grundkonfigurationen notwendig. Damit das SIEM Benachrichtigungen wie Alerts und Reports verschicken kann, muss ein E-Mail-Gateway eingerichtet werden. Auch #htl3r.short[snmp]-Traps können über eine E-Mail Benachrichtigungen auslösen.

/*
#htl3r.fspace(
  total-width: 100%,
  figure(
    image("assets/fortisiem.jpg"),
    caption: [Konfiguration des E-Mail-Gateways]
  )
)
*/

User und Rollen sind ein wichtiger Bestandteil in der Konfiguration des FortiSIEMs. Dadurch können spezifische Bereiche des FortiSIEMs begrenzt werden. Darunter fallen neben Zugriff auf bestimmte Daten auch Informationen von #htl3r.short[cmdb]-Reports, Begrenzung des #htl3r.short[gui]-Zugriffs und die Verhinderung von verzerrten Rohdaten in der Datenbank. Letzteres ist für eine #htl3r.short[dsgvo]-konforme Speicherung von Daten notwendig @dsgvo.

Beispielsweise kann eine zertifizierte FortiGate-Mitarbeiterin nur die Daten von Firewalls abrufen oder der Administrator einer #htl3r.short[ad] Infrastruktur nur Daten von Windows-Servern einsehen.

Die User können neben lokal angelegten Accounts in der #htl3r.short[cmdb] durch einen externen #htl3r.short[ldap] und #htl3r.short[radius] Server authentifiziert werden. Im Falle der Topologie wurde durch #htl3r.short[ldap] auf die errichtete #htl3r.short[ad] Infrastruktur zugegriffen. Für die genaue Abbildung der User und Gruppen im #htl3r.long[ad] siehe @ad-infra.

=== Geräte lokalisieren <fsm-cert-agents>

Im FortiSIEM gibt es zwei Möglichkeiten Daten von Geräten im Netzwerk zu erhalten. Entweder sucht das FortiSIEM durch die Discovery-Funktion nach eingetragenen Geräten, oder die Geräte schicken durch FortiSIEM-Agents selber Daten an das #htl3r.short[siem]. Fortinet stellt für diverse Geräte (z.B. Windows und Linux Server) unterschiedliche Agents bereit, um Logs und Events zu erhalten.

#pagebreak()

Für den Discovery-Prozess sind IP-Adressen der Geräte sowie Zugangsdaten notwendig. Die Zugangsdaten werden in primär und sekundär unterteilt. Primär wird #htl3r.short[snmp] als Zugang verwendet. Zusätzlich werden sekundäre Optionen wie Telnet, #htl3r.short[ssh], #htl3r.short[wmi], #htl3r.short[ldap] oder #htl3r.short[api]-Schnittstellen angeboten. Für die Topologie wird ein Range-Scan in alle #htl3r.shortpl[vlan] durchgeführt, um möglichst viele Geräte zu erkennen.

=== Abfragen der Daten <fsm-cert-querying>

Nachdem das FortiSIEM Logs und Events gespeichert hat, können diese im Analytics-Dashboard abgefragt werden. Das #htl3r.short[siem] unterscheidet basierend auf den Anforderungen des Nutzers zwischen #emph("Real-time") und #emph("Historical Search"). In der #emph("Real-time") Ansicht werden alle Logs und Events in Echtzeit bis zu einem bestimmten Zeitpunkt angezeigt. Im Gegensatz dazu können im #emph("Historical Search") alle zugänglichen Daten in einem bestimmten Zeitraum (relativ oder absolut) abgerufen werden.

Die Events können beim Abrufen nach unterschiedlichen Attributen gefiltert werden. Dabei können Informationen wie Hostname und IP-Adresse direkt aus der #htl3r.long[cmdb] entnommen werden. Die Filter sind miteinander über AND und OR sowie Klammern verknüpfbar, um komplexere Abfragen zu ermöglichen. Die Abfragen können gespeichert und anschließend beliebig oft erneut ausgeführt werden.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortisiem/fsm-analytics2.jpg"),
    caption: [Auszug aus den FortiSIEM-Analytics]
  )
)

=== Regeln und Incidents

Regeln sind im FortiSIEM essenziell für das Generieren von #emph("Incidents") im System. Das Sammeln und Aggregieren von Daten ist nur die halbe Miete, denn diese menschlich zu interpretieren und daraufhin in der aktiven Netzwerkkonfiguration zu implementieren ist bei einer gigantischen Menge von Daten unvorstellbar. Regeln erlauben es, sogenannte #emph("Patterns") mithilfe von Abfragen zu erstellen, um basierend auf den abgefragten Daten Konditionen festzulegen. Falls alle Konditionen einer Regel erfüllt werden, wird ein #emph("Incident") generiert.

Mithilfe der #htl3r.long[pam] Daten können #emph("Performance Rules") eingerichtet werden. Diese können beispielsweise bei Erreichung eines bestimmten Speicherlimits oder bei Überschreitung der #htl3r.short[cpu]-Auslastung ein #emph("Incident") generieren. Im #emph("Analytics Tab") können auch direkt beim Erstellen von Abfragen Regeln konfiguriert werden. FortiSIEM ist auch mit MITREs #htl3r.short[attck]-Datenbank kompatibel, um Regeln mit den neusten globalen Sicherheitslücken zu verbinden.

#emph("Incidents") geben Systemadministratorinnen und Systemadministratoren einen Überblick über die derzeitigen Schwachstellen in einem Netzwerk. Anhand den Daten generiert das FortiSIEM ein #emph("Incident")-Dashboard. Über #emph("Notification Policies") lassen sich automatisierte E-Mails oder #htl3r.short[sms] verschicken, die mit vordefinierten E-Mail-Templates ausgestattet sind und individuelle Nachrichten beinhalten können.

Für die Überwachung von systemkritischen Applikationen stellt das FortiSIEM sogenannte #emph("Business Services") bereit. Dadurch können spezielle #emph("Incidents") für Applikationen wie Oracle und SQL-Datenbanken oder Microsoft-Exchange-Server generiert werden. Diese Daten können in individuellen #emph("Business Service Dashboards") sichtbar gestaltet werden.

#htl3r.fspace(
  total-width: 86%,
  figure(
    image("../assets/fortisiem/fsm-dashboard2.jpg"),
    caption: [Auszug aus dem FortiSIEM-Dashboard]
  )
)

=== Troubleshooting <fsm-cert-troubleshooting>

FortiSIEM Version 7.2.4 basiert auf Rocky Linux Version 8.10. Troubleshooting erfolgt dadurch hauptsächlich am #htl3r.long[cli]. Die zentrale Log-Datei des FortiSIEM-Backends befindet sich in `/opt/phoenix/log/phoenix.log`. Im folgenden Abbild sind zwei Logs zu erkennen: `phMonitorSupervisor` mit der Einstufung `PHL_WARNING` und `phRuleWorker` mit der Einstufung `PHL_INFO`. Ersteres meldet einen Fehler im Bezug auf den Systemprozess `Node.js-charting.pid`, dass auf einen Fehler der FortiSIEM-Web-Dashboards schließen lässt.

#let text = read("../assets/fortisiem/FSM-phoenix.log")
#codly-range(1, 3)
#codly(skips: ((4, 0), ))
#raw(text, block: true, lang: "log")
/*
  caption: "Auszug aus der Datei phoenix.log",
  filename: [fortisiem/FSM-phoenix.log],
  lang: "log",
  ranges: ((2, 4),),
  skips: ((5, 0),),
  text: read("../assets/fortisiem/FSM-phoenix.log")
*/

Das #htl3r.short[siem] arbeitet mit mehreren Prozessen, die Funktionen wie #emph("Parsing"), #emph("Discovering") und #emph("Reporting") bereitstellen. Im Notfall können bestimmte Prozesse durch Fehler abgeschaltet werden. Um sich die Prozesse und deren Auslastung anzusehen, kann in der #htl3r.short[cli] mit dem Shortcut `phstatus` ein Python-Script ausgeführt werden.

Prozesse können mit `phtools --stop <process name>` gestoppt und `phtools --start <process name>` gestartet werden.

#let text = read("../assets/fortisiem/FSM-phstatus")
#codly-range(0, end: 7)
#codly(skips: ((21, 0), ))
#raw(text, block: true)

#pagebreak()

#let text = read("../assets/fortisiem/FSM-phstatus")
#codly-range(10, end: 15)
#codly(skips: ((9, 0), (16, 0) ))
#raw(text, block: true)
/*
#htl3r.code-file(
  caption: "Ausgabe des Befehls phstatus",
  filename: [fortisiem/FSM-phstatus],
  lang: "",
  ranges: ((0, 20),),
  skips: ((21, 0),),
  text: read("../assets/fortisiem/FSM-phstatus")
)
*/
Mit `/opt/phoenix/bin/checkWMIMonitorability` kann das Abfragen von Metriken auf Windows-Servern geprüft werden. Für die Überprüfung der #htl3r.short[wmi]-Zugangsdaten kann \ `/opt/phoenix/bin/wmic` verwendet werden.

// Auszug aus checkWMIMonitorability

Systeminformationen des #htl3r.shortpl[siem] können mit dem Bash-Script `/opt/phoenix/bin/phshowVersion.sh` angezeigt werden. Neben Version des FortiSIEMs und Lizenz zeigt es Netzwerkinformationen, Speicherverbrauch und Informationen zu #emph("Worker-") sowie #emph("Collector-Nodes") an.

#let text = read("../assets/fortisiem/FSM-phshowVersion")
#codly-range(0, end: 15)
#codly(skips: ((21, 0), ))
#raw(text, block: true)
/*
#htl3r.code-file(
  caption: "Ausgabe des Scripts phshowVersion.sh",
  filename: [fortisiem/FSM-phshowVersion],
  lang: "",
  ranges: ((3, 15), (20, 24), (39, 42)),
  skips: ((0, 0), (16, 0), (25, 0), (43, 0)),
  text: read("../assets/fortisiem/FSM-phshowVersion")
)
*/

#pagebreak()

== Implementierung in die Topologie <fsm-topo>

In der Topolgie bestehen zwei #htl3r.long[ad] Standorte, die über einen VPN zwischen zwei FortiGates miteinander verbunden sind. Wien bildet dabei den Hauptstandort und Eisenstadt einen Zweig im Unternehmen. Mehr zur #htl3r.long[ad] Infrastruktur wird in @ad-infra erläutert. Das FortiSIEM wird zentral von einer Supervisor-Node gesteuert, die am Hauptstandort Wien lokalisiert ist. Dieser Standort besitzt zusätzlich eine Worker- und Collector-Node. Die Worker-Node dient zum Load-Balancing beim Sammeln und Abfragen der Daten mit der Supervisor-Node. Auf der Site Eisenstadt befindet sich eine Collector-Node, um die Geräte dieses Standortes zu überwachen und der Worker-Node am Standort Wien weiterzuleiten. Die Daten werden in einem Elasticsearch gespeichert, mehr dazu im @elastic-config. Das gesamte Deployment wird als FortiSIEM-Cluster bezeichnet.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortisiem/fsm-topo.png"),
    caption: [logische Topolgie des FortiSIEM-Clusters]
  )
)

#pagebreak()

=== Supervisor-Node <fsm-supervisor>

In der Event Database im Elasticsearch speichert das FortiSIEM alle Events und Logs. Hier dient die Supervisor-Node als zentraler Knotenpunkt, der von den anderen Collector- oder Worker-Nodes die Daten erhält und aggregiert. Für die Event Database des FortiSIEM können unterschiedliche Datenbanken gewählt werden. Fortinet bietet hier folgende Optionen an:

- #emph("ClickHouse")
- #emph("NFS Share")
- #emph("Local Disk")
- #emph("Elasticsearch")

// Auf die Datenbanken eingehen??

Die Installationsanforderungen für die Supervisor-Node des FortiSIEM (Version 7.2.4) belaufen sich auf:
- 12 virtuelle #htl3r.shortpl[cpu]
- 24 GB RAM
- OS Drive: 25GB
- OPT Drive: 100GB
- #htl3r.short[cmdb] Drive: 60GB
- SVN Drive: 60GB
- Event Database: Elasticsearch

Elasticsearch bietet im Gegensatz zu anderen Optionen bessere Performance und Skalierbarkeit @elastic-vs-sql. In der Topologie wird nur eine Elasticsearch-Data-Node für das FortiSIEM verwendet. Die gesamte Konfiguration wird im @elastic-config im Detail aufgelistet.

Die Lizenzierung muss nur für die Supervisor-Node durchgeführt werden. Alle weiteren Worker- und Collector-Nodes sowie Agents werden mit der Verknüpfung des Supervisors aktiviert. Das FortiSIEM generiert bei jedem neuen Deployment eine zufällig generierte Hardware-ID. Diese Hardware-ID muss im `support.fortinet.com` Portal eingetragen und die Lizenz anschließend heruntergeladen werden.

=== Worker-Node <fsm-worker>

Gemeinsam mit der Supervisor-Node verarbeitet die Worker-Node Daten des #htl3r.shortpl[siem]. Zu den Aufgaben gehören das Indexieren, Speichern, Suchen, Korrelieren und Erweitern von Daten, die von den Collector-Nodes erhalten werden. Zusätzlich wird eine Baseline im Netzwerk ermittelt, um Anomalien zu erkennen.

Die Installationsanforderungen für die Worker-Node des FortiSIEM (Version 7.2.4) belaufen sich auf:
- 8 virtuelle #htl3r.shortpl[cpu]
- 16 GB RAM
- OS Drive: 25GB
- OPT Drive: 100GB

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/fortisiem/fsm-wk.jpg"),
    caption: [Status der Supervisor- und Worker-Nodes im FortiSIEM]
  )
)

=== Collector-Node <fsm-collector>

Die Namensgebung dieser Komponente entspricht dessen Aufgabe: das Sammeln von Daten. Dies ist ein wichtiger Bestandteil in der Nutzung von Agents, denn jedes Gerät, das ein Agent installiert hat, muss einer Collector-Node zugeordnet werden. Die Agent-Templates, welches die zu sammelnden Daten der Geräte bestimmt, werden an den Collector-Nodes gespeichert und an die installierten Agents weitergegeben. Dies wird besonders für geografisch entfernte Standorte implementiert, um das Limit der Bandbreite auf Weitverkehrsnetzen zu umgehen.

Die Installationsanforderungen für die Worker-Node des FortiSIEM (Version 7.2.4) belaufen sich auf:
- 4 virtuelle #htl3r.shortpl[cpu]
- 4 GB RAM
- OS Drive: 25GB
- OPT Drive: 100GB

#htl3r.fspace(
  total-width: 91%,
  figure(
    image("../assets/fortisiem/fsm-cl.jpg"),
    caption: [Status der Collector-Nodes im FortiSIEM]
  )
)

=== Elasticsearch-Konfiguration <elastic-config>

Für das Elasticsearch wurde ein Ubuntu-Server verwendet. Hierbei wird nicht der gesamte Elastic Stack, sondern nur Elasticsearch selbst installiert. Zur besseren Übersicht von Elasticsearch wurde noch Kibana für einen direkten Zugriff über ein Web-#htl3r.short[gui] konfiguriert. Zu Beginn werden die #htl3r.short[gpg] Schlüssel von Elasticsearch am lokalen System hinterlegt, um die Pakete anschließend von den offiziellen Quellen herunterzuladen.

#htl3r.code-file(
  caption: "Elasticsearch-Installation",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((9, 17),),
  skips: ((8,0),(18,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

Für das Betreiben eines Elasticsearch auf einem Linux-Server müssen systemweite Konfigurationen in der Datei `/etc/security/limits.conf` übernommen werden. Dabei muss für den User `ubuntu` die Anzahl an Threads auf 4096 und die Anzahl an File Descriptors auf 65535 gesetzt werden. Ebenfalls ist empfohlen, Memory-Swapping zu deaktivieren. Um dies auch nach einem Neustart beizubehalten, sind auch alle Swap-Partitionen in `/etc/fstab` auszukommentieren.

#htl3r.code-file(
  caption: "Ubuntu-Server-Konfiguration für Elasticsearch",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((34, 41),),
  skips: ((33,0), (42,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

Damit das Elasticsearch die volle Performance des Servers ausnutzen kann, muss das globale Limit von Virtual Memory in `/etc/sysctl.conf` angehoben werden. Zusätzlich soll auch im Systemd Service von Ubuntu das Speicherlimit aufgehoben werden.

#htl3r.code-file(
  caption: "Ubuntu-Server-Konfiguration für Elasticsearch",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((44, 49),),
  skips: ((43,0), (50,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

#pagebreak()

Elasticsearch arbeitet mit Nodes. Für ein Multi-Tenant-Deployment eines FortiSIEM werden unterschiedliche Data-Nodes in Kombination mit Coordinating-Nodes verwendet. Die Coordinating-Nodes übernehmen dabei das Abfragen der Daten. Jede Data-Node kann einen bestimmten Zustand annehmen (Hot, Warm, oder Cold). Der Zustand definiert, welchen Anteil an Daten die einzelnen Nodes erhalten. Hot-Nodes benötigen schnellere #htl3r.short[io] und mehr Prozessorleistung, da sie den Schreibprozess der aktuellsten Daten übernehmen und diese langsam an Warm- und Cold-Nodes weitergeben. Weil die Datenmengen von Logs und Events in der Topologie kein großes Ausmaß besitzen, ist das Elasticsearch nur mit einer Hot-Node konfiguriert. Diese bildet aufgrund der geringeren Komplexität eine All-in-one Node, in der nicht zwischen Data- und Coordinating-Node unterschieden wird.

#htl3r.code-file(
  caption: "Elasticsearch-Konfiguration",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((53, 53), (76, 76), (96, 96), (109, 109), (114, 114), (136, 139)),
  skips: ((52,0), (75,0), (95,0), (108,0), (113,0), (135,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

#pagebreak()

== Konfiguration der Agents

Für die Nutzung von Agents sind im FortiSIEM Agent-User zu konfigurieren. Durch diese verifizieren sich die Agents bei der Supervisor-Node. Die Konfiguration erfolgt in der #htl3r.long[cmdb]. Daraufhin müssen sogenannte Agent Monitor Templates angelegt werden. Diese definieren die abzurufenden Daten von den Geräten. Dazu gehört das Monitoring von #htl3r.short[cpu]-, Speicher- und Netzwerkauslastung oder spezifischen Applikationen wie #htl3r.short[dns], #htl3r.short[dhcp] und #htl3r.long[ad]. Zusätzlich können bestimmte Windows Event Types oder Zertifikate im #htl3r.long[ad] überwacht werden. Die Templates werden anschließend den Geräten zugeordnet.

Die Windows-Server am Standort Wien werden auf ihre Ressourcen und Applikationen überwacht. Zusätzlich werden die Security, System und Application Logs unter Windows abgerufen. Die Installation erfolgt über das verteilen der Agents mittels #htl3r.short[ftp]-Server. Nach der Installation des Windows-Agents müssen im #htl3r.long[ad] Security Audit Policies konfiguriert werden. Windows-Server erzeugen nativ Logs, die im Event-Viewer zu sehen sind. Diese reichen aber nicht aus und müssen mittels #htl3r.shortpl[gpo] erweitert werden. Hierfür wird die Security Audit #htl3r.short[gpo] mit der #htl3r.long[ou] für die Domain Controller verknüpft. Anschließend können die Events im FortiSIEM abgerufen werden.

Neben Metriken und Logs können auch Dateien und Verzeichnisse auf ihre Änderungen überprüft werden. Im Falle des Domain-Controllers wird das Verzeichnis des lokalen sowie Enterprise Administrators und der SYSVOL Ordner im #htl3r.long[ad] überwacht. Falls zum Beispiel eine Angreiferin oder ein Angreifer im Policies Ordner von SYSVOL ein Powershell-Script hinterlässt, wird dieses durch ein Alert im Dashboard bekannt gegeben. Eine weitere Maßnahme zur Abhärtung von Windows-Server sind die Überwachung von Registry-Einträgen. FortiSIEM bietet hier die Option nach bestimmten Schlüsseln in den Stammverzeichnissen der Windows-Registry zu suchen. Die gesamte Konfiguration bildet ein Agent-Template, das auf die Windows-Server im #htl3r.long[ad] zugewiesen wird.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortisiem/fsm-agent-template.jpg"),
    caption: [Auszug aus der Agent-Template-Konfiguration innerhalb des FortiSIEM]
  )
)

Nach Abschluss der Konfiguration können im Dashboard schon die ersten Incidents beobachtet werden. Sortiert nach der Dringlichkeit werden die Geräte und User angezeigt, welche die meisten Incidents hervorrufen. Nach näherer Betrachtung eines Geräts kann die Zeitspanne der aufgetretenen Incidents beobachtet werden. Dadurch berechnet das FortiSIEM auch einen Incident-Score, der durch die Anzahl an aufgetrenenen Ereignissen steigt. Auf Basis der Incidents können für die Mitarbeiterinnen und Mitarbeiter des Unternehmens Cases erstellt werden, um den Überblick über Sicherheitsmaßnahmen zu behalten.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortisiem/fsm-incident-jump.jpg"),
    caption: [Incidents des Jump-Servers am Standort Wien]
  )
)

Die Konfiguration des Agents für Linux-Server basiert auf den gleichen vorher genannten Prinzipien. Nach der Installation ist der Agent im Ordner `/opt/fortinet/fortisiem/linux-agent` zu finden und über dem Systemd-Service `fortisiem-linux-agent` abrufbar. Für die Topologie wurde der #htl3r.short[ftp]-Server, die Elasticsearch All-in-One Node sowie eine Metasploitable-#htl3r.short[vm] mit Linux-Agents ausgestattet. Anhand der Elasticsearch-Node betrachten wir nun einen Beispiel-Incident. Das FortiSIEM hat bei der Eingabe des Befehls `uname -r` einen #emph("Enumeration of System Information Incident") ausgelöst.

#htl3r.fspace(
  total-width: 80%,
  figure(
    image("../assets/fortisiem/fsm-investigate.jpg"),
    caption: [Der Enumeration of System Information Incident]
  )
)

Die FortiGate wird zusätzlich zum FortiAnalyzer durch das FortiSIEM über die #htl3r.short[api] überwacht. Dies ermöglicht die detaillierte Anzeige des Datenverkehrs innerhalb des Netzwerks. In Kombination mit einem Google-#htl3r.short[api]-Key können die Daten auf einer Karte veranschaulicht werden.

#htl3r.fspace(
  total-width: 80%,
  figure(
    image("../assets/fortisiem/fsm-fg.jpg"),
    caption: [Die Dashboard-Widgets für die FortiGate]
  )
)

#pagebreak()

Um die User des #htl3r.short[ad] in das FortiSIEM einzubinden, kann auch hier ein externer #htl3r.short[ldap]-Server zur Authentifizierung implementiert werden. Als Base Distinguished Name wird `CN=%s,CN=Users,DC=wien,DC=3bb-testlab,DC=at` definiert. Die Variable `%s` wird zum Einfügen des Usernamen beim Login verwendet. Nach erfolgreicher Authentifizierung mit dem Domain-Controller kann nun in der #htl3r.long[cmdb] ein User erstellt und dem #htl3r.short[ldap]-Server zugewiesen werden.

#htl3r.fspace(
  //total-width: 55%,
  figure(
    image("../assets/fortisiem/fsm-ldap.jpg", width: 65%),
    caption: [Login am FortiSIEM durch den SOC-User]
  )
)

== Abbildung der OT-Topologie im FortiSIEM

Um die #htl3r.short[ot]-Topologie mit der Modelleisenbahn im FortiSIEM sichtbar zu machen, werden Daten vom Hirschmann RS20 #htl3r.short[ot]-Switch erhoben. Dieser verbindet die wichtigsten Komponenten für die Steuerung des Zugnetzwerks und ist daher äußerst kritisch für die Infrastruktur. Für die Konfiguration ist ein Hirschmann V.24 Konsolenkabel notwendig. Dieses basiert auf einem #htl3r.short[rj]11 Anschluss mit sechs Pins. Da das Gerät im Vorhinein bereits konfiguriert war, wurde eine Passwort-Recovery durchgeführt. Für die Password-Recovery wurde das RS20-Image mit einem Flash-Speicher per USB neu installiert. Zur besseren Administrierbarkeit ist am Switch ein #htl3r.short[svi] konfiguriert und der Zugang über #htl3r.short[ssh], #htl3r.short[http] und der HiDiscovery-Software von Hirschmann erlaubt.

#htl3r.code-file(
  caption: "Hirschmann RS20 Grundkonfiguration",
  filename: [fortisiem/3bb-ot-switch.txt],
  ranges: ((1, 7), ),
  skips: ((8, 0), ),
  text: read("../assets/fortisiem/3bb-ot-switch.txt")
)

Als Schnittstelle zur Überwachung wird #htl3r.short[snmp]v3 genutzt. Über einen eigens erstellen User und #htl3r.short[snmp]v3-Traps erfolgt die Übermittlung der Daten an das #htl3r.short[siem]. Der FortiSIEM-Collector nutzt die Zugangsdaten in der #htl3r.long[cmdb], um über den #htl3r.short[vpn] eine Verbindung zum Switch aufzubauen.

#htl3r.code-file(
  caption: "Hirschmann RS20 SNMPv3-Konfiguration",
  filename: [fortisiem/3bb-ot-switch.txt],
  ranges: ((9, 99), ),
  skips: ((9, 0), ),
  text: read("../assets/fortisiem/3bb-ot-switch.txt")
)

#pagebreak()

== Fazit

Die Security-Komponenten am #htl3r.short[it]-Standort wurden hauptsächlich als Übung für die Zertifizierungsprüfung des Fortinet Certified Professional durchgeführt. Die #htl3r.long[ad] Infrastruktur bot eine gute Basis für die Implementierung eines #htl3r.shortpl[siem], um Daten über ein Netzwerk zu sammeln. Die simultane Verwendung des FortiAnalyzer stellte sich als überflüssige Redundanz heraus, da das FortiSIEM die Daten der FortiGates bereits in vollem Umfang erhalten hat. Die individuelle Konfiguration des FortiSIEM ist im Vergleich zu anderen Herrsteller nur begrenzt möglich. Auch Dokumentationen im Internet sind nur limitiert abrufbar.

Die Verwendung eines Elasticsearch warf die Frage auf, ob die Implementierung des FortiSIEM überhaupt notwendig war. Durch die eingeschränkte Konfiguration wäre ein vollständiges Elasticsearch-Deployment inklusive Kibana und Logstash ein besserer Nutzen gewesen. Lediglich die Agents des FortiSIEM erwiesen sich als simple und schnelle Konfiguration, um Daten von Windows- oder Linux-Servern abzurufen. Im Endeffekt diente das FortiSIEM nur als Oberfläche für die im Elasticsearch enthaltenen Daten.
