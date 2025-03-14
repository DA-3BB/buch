#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")

= FortiSIEM <fsm>
Für die Implementierung eines #htl3r.shortpl[siem] in die Topologie wird ein FortiSIEM der Firma Fortinet verwendet. Es kann agent-based oder agentless Logs und Events von Geräten abrufen. In den meisten Fällen wird Syslog oder #htl3r.short[snmp] zur Kommunikation der Geräte mit dem #htl3r.short[siem] verwendet. Es gibt aber auch Ausnahmen, wie im Falle von Windows. Windows Server können entweder mittels #htl3r.short[wmi] oder dem FortiSIEM Windows Agent Daten an das #htl3r.short[siem] übermitteln. Der Vorteil an den Agents liegt darin, dass Logs direkt am Gerät geparsed und verschickt werden können, statt mehrere Logs in einem bestimmten Intervall durch das FortiSIEM abzurufen.

Des Weiteren kann das FortiSIEM Basismetriken durch das #htl3r.short[pam] abrufen. Dies beinhaltet Daten wie den Zustand einer Applikation, Ressourcenverbrauch eines Geräts und vieles mehr. Dadurch können Anomalien in den Daten erkannt werden und Warnungen im FortiSIEM auslösen.


== Zertifizierung <fsm-cert>
Als Training für die Zeritifizierungsprüfung wurden die Labor-Übungen vom FortiSIEM Kurs durchgeführt. Diese wurden in elf Kapitel unterteilt, die an die Kapitel aus dem Online-Kurs angelehnt sind:

1. #emph("FortiSIEM Introduction")
2. #emph(htl3r.short[siem] + " and " + htl3r.short[pam] + " Concepts")
3. #emph("Discovery")
4. #emph("FortiSIEM Analytics")
5. #emph(htl3r.short[cmdb] + " Lookups and Filters")
6. #emph("Group By and Data Aggregation")
7. #emph("Rules")
8. #emph("Incidents and Notificaiton Policies")
9. #emph("Reports")
10. #emph("Business Services")
11. #emph("Troubleshooting")

=== Grundkonfiguration des FortiSIEMs <fsm-cert-conf>

Für den Betrieb eines FortiSIEMs sind Grundkonfigrationen notwendig. Damit das SIEM Benachrichtigungen wie Alerts und Reports verschicken kann, muss ein E-Mail-Gateway eingerichtet werden. Auch #htl3r.short[snmp]-Traps können über eine E-Mail Benachrichtigungen auslösen.

/*
#htl3r.fspace(
  total-width: 100%,
  figure(
    image("assets/fortisiem.png"),
    caption: [Konfiguration des E-Mail-Gateways]
  )
)
*/

Benutzer und Rollen sind ein wichtiger Bestandteil in der Konfiguration des FortiSIEMs. Dadurch können spezifische Bereiche des FortiSIEMs begrenzt werden. Darunter fallen neben Zugriff auf bestimmte Daten auch Informationen von #htl3r.short[cmdb]-Reports, Begrenzung des #htl3r.short[gui]-Zugriffs und die Verhinderung von verzerrten Rohdaten in der Datenbank. Letzteres ist für eine #htl3r.short[dsgvo]-konforme Speicherung von Daten notwendig.

Beispielsweise kann eine zertifizierte FortiGate-Mitarbeiterin nur die Daten von Firewalls abrufen, oder die Administratorinnen und Administratoren einer #htl3r.short[ad]-Infrastruktur nur Daten von Windows-Servern einsehen.

Die Benutzer können neben lokal angelegten Accounts in der #htl3r.short[cmdb] durch einen externen #htl3r.short[ldap] und #htl3r.short[radius] Server authentifiziert werden. Im Falle der Topologie wurde durch #htl3r.short[ldap] auf die errichtete #htl3r.short[ad]-Infrastruktur zugegriffen. Für die genaue Abbildung der Benutzer und Gruppen im #htl3r.long[ad] siehe /*@ad-infra*/.

=== Geräte überwachen <fsm-cert-agents>

Im FortiSIEM gibt es zwei Möglichkeiten Daten von Geräten im Netzwerk zu erhalten. Entweder sucht das FortiSIEM durch die #emph("Discovery") Funktion nach eingetragenen Geräten, oder die Geräte schicken durch FortiSIEM-Agents selber Daten an das #htl3r.short[siem]. Fortinet stellt für diverse Geräte (z.B. Windows und Linux Server) unterschiedliche #emph("Agents") bereit, um Logs und Events zu erhalten.

Für den #emph("Discovery") Prozess sind IP-Adressen der Geräte sowie Zugangsdaten notwendig. Die Zugangsdaten werden in primär und sekundär unterteilt. Primär wird #htl3r.short[snmp] als Zugang verwendet. Zusätzlich werden sekundäre Optionen wie Telnet, #htl3r.short[ssh], #htl3r.short[wmi], #htl3r.short[ldap], oder Cisco- und Fortinet-Zugangsdaten angeboten.

=== Abfragen der Daten <fsm-cert-querying>

Nachdem das FortiSIEM Logs und Events gespeichert hat, können diese im #emph("Analytics") Dashboard abgefragt werden. Das #htl3r.short[siem] unterscheidet basierend auf den Anforderungen des Nutzers zwischen #emph("Real-time") und #emph("Historical Search"). In der #emph("Real-time") Ansicht werden alle Logs und Events in Echtzeit bis zu einem bestimmten Zeitpunkt angezeigt. Im Gegensatz dazu können im #emph("Historical Search") alle zugänglichen Daten in einem bestimmten Zeitraum (relativ oder absolut) abgerufen werden.

Die Events können beim Abrufen nach unterschiedlichen Attributen gefiltert werden. Dabei können Informationen wie Hostname und IP-Adresse direkt aus der #htl3r.long[cmdb] entnommen werden. Die Filter sind miteinander über AND und OR sowie Klammern verknüpfbar, um komplexere Abfragen zu ermöglichen. Die Abfragen können gespeichert und anschließend beliebig oft erneut ausgeführt werden.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/fortisiem/fsm-analytics.png"),
    caption: [Auszug aus den FortiSIEM-Analytics]
  )
)

=== Regeln und #emph("Incidents")

Regeln sind im FortiSIEM essentiell für das Generieren von #emph("Incidents") im System. Das Sammeln und Aggregieren von Daten ist nur die halbe Miete, denn diese menschlich zu Interpretieren und daraufhin in der aktiven Netzwerkkonfiguration zu implementieren ist bei einer gigantischen Menge von Daten unvorstellbar. Regeln erlauben es, sogenannte #emph("Patterns") mithilfe von Abfragen zu erstellen, um basierend auf den abgefragten Daten Konditionen festzulegen. Falls alle Konditionen einer Regeln erfüllt werden, wird ein #emph("Incident") generiert.

Mithilfe der #htl3r.long[pam] Daten können #emph("Performance Rules") aufgestellt werden. Diese können beispielsweise bei Erreichung eines bestimmten Speicherlimits oder bei Überschreitung der #htl3r.short[cpu]-Auslastung ein #emph("Incident") generieren. Im #emph("Analytics Tab") können auch direkt beim Erstellen von Abfragen Regeln konfiguriert werden. FortiSIEM ist auch mit MITREs #htl3r.short[attck]-Datenbank kompatibel, um Regeln mit den neusten globalen Sicherheitslücken zu verbinden.

// Auszug aus Regel-Config

#emph("Incidents") geben Systemadministratoren einen Überblick über die derzeitigen Schwachstellen in einem Netzwerk. Anhand den Daten generiert das FortiSIEM ein #emph("Incident")-Dashboard. Über #emph("Notification Policies") lassen sich automatisierte E-Mails oder #htl3r.short[sms] verschicken, die mit vordefinierten E-Mail-Templates ausgestattet sind und individuelle Nachrichten beinhalten können.

Für die Überwachung von systemkritischen Appilkationen stellt das FortiSIEM sogenannte #emph("Business Services") bereit. Dadurch können spezielle #emph("Incidents") für Applikationen wie Oracle und SQL-Datenbanken oder Microsoft-Exchange-Server generiert werden. Diese Daten können in individuellen #emph("Business Service Dashboards") sichtbar gestaltet werden.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/fortisiem/fsm-dashboard.png"),
    caption: [Auszug aus dem FortiSIEM-Dashboard]
  )
)

=== Troubleshooting <fsm-cert-troubleshooting>

FortiSIEM Version 7.2.4 basiert auf Rocky Linux Version 8.10. Troubleshooting erfolgt dadurch hauptsächlich am #htl3r.long[cli]. Die zentrale Log-Datei des FortiSIEM-Backends befindet sich in `/opt/phoenix/log/phoenix.log`.

#htl3r.code-file(
  caption: "Auszug aus der Datei phoenix.log",
  filename: [fortisiem/FSM-phoenix.log],
  lang: "log",
  ranges: ((2, 4),),
  skips: ((5, 0),),
  text: read("../assets/fortisiem/FSM-phoenix.log")
)

Das #htl3r.short[siem] arbeitet mit mehreren Prozessen, die Funktionen wie #emph("Parsing"), #emph("Discovering") und #emph("Reporting") bereitstellen. Im Notfall können bestimmte Prozesse durch Fehler abgeschalten werden. Um sich die Prozesse und deren Auslastung anzusehen, kann in der #htl3r.short[cli] mit dem Shortcut `phstatus` ein Python-Script ausgeführt werden. Prozesse können mit `phtools --stop <process name>` gestoppt und `phtools --start <process name>` gestartet werden.

#htl3r.code-file(
  caption: "Ausgabe des Befehls phstatus",
  filename: [fortisiem/FSM-phstatus],
  lang: "",
  ranges: ((0, 20),),
  skips: ((21, 0),),
  text: read("../assets/fortisiem/FSM-phstatus")
)

Mit `/opt/phoenix/bin/checkWMIMonitorability` kann das Abfragen von Metriken auf Windows-Servern geprüft werden. Für die Überprüfung der #htl3r.short[wmi]-Zugangsdaten kann `/opt/phoenix/bin/wmic` verwendet werden.

// Auszug aus checkWMIMonitorability

Systeminformationen des #htl3r.shortpl[siem] können mit dem Bash-Script `/opt/phoenix/bin/phshowVersion.sh` angezeigt werden. Neben Version des FortiSIEMs und Lizenz zeigt es Netzwerkinformationen, Speicherverbrauch und Informationen zu #emph("Worker-") sowie #emph("Collector-Nodes") an.

#htl3r.code-file(
  caption: "Ausgabe des Scripts phshowVersion.sh",
  filename: [fortisiem/FSM-phshowVersion],
  lang: "",
  ranges: ((3, 15), (20, 24), (39, 42)),
  skips: ((0, 0), (16, 0), (25, 0), (43, 0)),
  text: read("../assets/fortisiem/FSM-phshowVersion")
)
== Implementierung in die Topologie <fsm-topo>

In der Topolgie bestehen zwei #htl3r.long[ad] Standorte, die über einen VPN zwischen zwei FortiGates miteinander verbunden sind. Wien bildet dabei den Hauptstandort und Eisenstadt einen Zweig im Unternehmen. Mehr zur #htl3r.long[ad] Infrastruktur wird in /*@ad-infra*/ erläutert. Das FortiSIEM wird zentral von einer Supervisor-Node gesteuert, die am Hauptstandort Wien lokalisiert ist. Dieser Standort besitzt zusätzlich eine Worker- und Collector-Node. Die Worker-Node dient zum Load-Balancing beim Sammeln und Abfragen der Daten mit der Supervisor-Node. Auf der Site Eisenstadt befindet sich eine Collector-Node, um die Geräte dieses Standortes zu überwachen und der Worker-Node am Standort Wien weiterzuleiten. Die Daten werden in einem Elasticsearch gespeichert, mehr dazu im @elastic-config. Das gesamte Deployment wird als FortiSIEM-Cluster bezeichnet.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/fortisiem/fortisiem-topology.png"),
    caption: [logische Topolgie des FortiSIEM-Clusters]
  )
)

=== Supervisor-Node <fsm-supervisor>

In der Event Database speichert das FortiSIEM alle Events und Logs. Hier dient die Supervisor-Node als zentraler Knotenpunkt, der von den anderen Collector- oder Worker-Nodes die Daten erhält und aggregiert. Für die Event Database des FortiSIEM können unterschiedliche Datenbanken gewählt werden. Fortinet bietet hier folgende Optionen an:

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

Elasticsearch bietet im Gegensatz zu anderen Optionen bessere Performance und Skalierbarkeit /*@elastic-vs-sql*/. In der Topologie wird nur eine Elasticsearch-Data-Node für das FortiSIEM verwendet. Die gesamte Konfiguration wird im @elastic-config im Detail aufgelistet.

Die Lizensierung muss nur für die Supervisor-Node durchgeführt werden. Alle weiteren Worker- und Collector-Nodes sowie Agents werden mit der Verknüpfung des Supervisors aktiviert. Das FortiSIEM generiert bei jedem neuen Deployment eine zufällig generierte Hardware-ID. Diese Hardware-ID muss im `support.fortinet.com` Portal eingetragen und die Lizenz anschließend heruntergeladen werden.

=== Worker-Node <fsm-worker>

Gemeinsam mit der Supervisor-Node verarbeitet die Worker-Node Daten des #htl3r.shortpl[siem]. Zu den Aufgaben gehören das indexieren, speichern, suchen, korrelieren, und erweitern von Daten, die von den Collector-Nodes erhalten werden. Zusätzlich wird eine Baseline im Netzwerk ermittelt, um Anomalien zu erkennen.

Die Installationsanforderungen für die Worker-Node des FortiSIEM (Version 7.2.4) belaufen sich auf:
- 8 virtuelle #htl3r.shortpl[cpu]
- 16 GB RAM
- OS Drive: 25GB
- OPT Drive: 100GB

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/fortisiem/fsm-wk.png"),
    caption: [Status der Supervisor- und Worker-Nodes im FortiSIEM]
  )
)

=== Collector-Node <fsm-collector>

Die Namensgebung dieser Komponente entspricht dessen Aufgabe: das Sammeln von Daten. Dies ist ein wichtiger Bestandteil in der Nutzung von Agents, denn jedes Gerät, dass ein Agent installiert hat, muss einer Collector-Node zugeordnet werden. Die Agent-Templates, welches die zu sammelnden Daten der Geräte bestimmt, werden an den Collector-Nodes gespeichert und an die installierten Agents weitergegeben. Dies wird besonders für geografisch entfernte Standorte implementiert, um das Limit der Bandbreite auf Weitverkehrsnetzen zu umgehen.

Die Installationsanforderungen für die Worker-Node des FortiSIEM (Version 7.2.4) belaufen sich auf:
- 4 virtuelle #htl3r.shortpl[cpu]
- 4 GB RAM
- OS Drive: 25GB
- OPT Drive: 100GB

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/fortisiem/fsm-cl.png"),
    caption: [Status der Collector-Nodes im FortiSIEM]
  )
)

=== Elasticsearch-Konfiguration <elastic-config>
Für das Elasticsearch wurde ein Ubuntu-Server verwendet. Hierbei wird nicht der gesamte Elastic Stack, sondern nur Elasticsearch selbst installiert. Zur besseren Übersicht von Elasticsearch wurde noch Kibana für einen direkten Zugriff über ein #htl3r.short[gui] konfiguriert.
\ \
#htl3r.code-file(
  caption: "Elasticsearch-Installation",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((9, 17),),
  skips: ((8,0),(18,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

Für das Betreiben eines Elasticsearch auf einem Linux-Server müssen systemweite Konfigurationen übernommen werden. Dabei muss für bestmögliche Performance die Anzahl an Threads auf 4096 und die Anzahl an File Descriptors  auf 65535 gesetzt werden. Ebenfalls ist empfohlen Memory-Swapping zu deaktivieren. Um dies auch nach einem Neustart beizubehalten, sind auch alle Swap-Partitionen in ```/etc/fstab``` auszukommentieren.

#htl3r.code-file(
  caption: "Ubuntu-Server-Konfiguration für Elasticsearch",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((34, 41),),
  skips: ((33,0), (41,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

Damit das Elasticsearch die volle Performance des Servers ausnutzen kann, muss das globale Limit von Virtual Memory angehoben werden. Zusätzlich soll auch im Systemd Service von Ubuntu das Speicherlimit aufgehoben werden.

#htl3r.code-file(
  caption: "Ubuntu-Server-Konfiguration für Elasticsearch",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((44, 49),),
  skips: ((43,0), (50,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

Elasticsearch arbeitet mit Nodes. Jede Node kann einen bestimmten Zustand annehmen (Hot, Warm, oder Cold). Der Zustand definiert, welchen Anteil an Daten die einzelnen Nodes erhalten. Hot-Nodes benötigen schnellere #htl3r.short[io] und mehr Prozessorleistung, da sie den Schreibprozess der aktuellsten Daten übernehmen und diese langsam an Warm- und Cold-Nodes weitergeben. Weil die Datenmengen von Logs und Events in der Topologie kein großes Ausmaß besitzen, ist das Elasticsearch nur mit einer Hot-Node konfiguriert.

#htl3r.code-file(
  caption: "Elasticsearch-Konfiguration",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((53, 53), (76, 76), (96, 96), (109, 109), (114, 114), (136, 139)),
  skips: ((52,0), (75,0), (95,0), (108,0), (113,0), (135,0)),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

=== Konfiguration der Agents

Um die Domain Controller der #htl3r.short[ad]-Infrastruktur zu überwachen, werden auf jedem Server die Windows-Agents von Fortinet installiert. Die Installationsdatei kann man sich bei der `support.fortinet.com` Website herunterladen.

Die Dateien werden auf einem #htl3r.short[ftp]-Server bereitgestellt und von den Windows-Servern heruntergeladen. Daraufhin kann der Installationsvorgang gestartet werden.

#htl3r.fspace(
  total-width: 50%,
  figure(
    image("../assets/fortisiem/fsm-windows-agent.png"),
    caption: [Installationsmenü des Windows-Agents]
  )
)

#emph("Installation der Linux-Agents folgt!")

=== Auswirkungen der Implementierung
