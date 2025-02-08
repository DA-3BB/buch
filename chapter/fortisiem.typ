#import "@preview/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")

= FortiSIEM <foritsiem>
Für die Implementierung eines #htl3r.shortpl[siem] in die Topologie wird ein FortiSIEM der Firma Fortinet verwendet. Es kann agent-based oder agentless Logs und Events von Geräten abrufen. In den meisten Fällen wird Syslog oder #htl3r.short[snmp] zur Kommunikation der Geräte mit dem #htl3r.short[siem] verwendet. Es gibt aber auch Ausnahmen, wie im Falle von Windows. Windows Server können entweder mittels #htl3r.short[wmi] oder dem FortiSIEM Windows Agent Daten an das #htl3r.short[siem] übermitteln. Der Vorteil an den Agents liegt darin, dass Logs direkt am Gerät geparsed und verschickt werden können, statt mehrere Logs in einem bestimmten Intervall durch das FortiSIEM abzurufen.
\
Des Weiteren kann das FortiSIEM Basismetriken durch das #htl3r.short[pam] abrufen. Dies beinhaltet Daten wie den Zustand einer Applikation, Ressourcenverbrauch eines Geräts und vieles mehr. Dadurch können Anomalien in den Daten erkannt werden und Warnungen im FortiSIEM auslösen.
\

== Zertifizierung <fortisiem-cert>
Als Training für die Zeritifizierungsprüfung wurden die Labor-Übungen vom FortiSIEM Kurs durchgeführt. Diese wurden in elf Kapitel unterteilt, die an die Kapitel aus dem Online-Kurs angelehnt sind:
\

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

\

=== Grundkonfiguration des FortiSIEMs <fortisiem-cert-conf>

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

Die Benutzer können neben lokal angelegten Accounts in der #htl3r.short[cmdb] durch einen externen #htl3r.short[ldap] und #htl3r.short[radius] Server authentifiziert werden. Im Falle der Topologie wurde durch #htl3r.short[ldap] auf die errichtete #htl3r.short[ad]-Infrastruktur zugegriffen. Für die genaue Abbildung der Benutzer und Gruppen im #htl3r.long[ad] siehe @ad-infra.

=== Geräte überwachen

Im FortiSIEM gibt es zwei Möglichkeiten Daten von Geräten im Netzwerk zu erhalten. Entweder sucht das FortiSIEM durch die #emph("Discovery") Funktion nach eingetragenen Geräten, oder die Geräte schicken durch FortiSIEM-Agents selber Daten an das #htl3r.short[siem]. Fortinet stellt für diverse Geräte (z.B. Windows und Linux Server) unterschiedliche #emph("Agents") bereit, um Logs und Events zu erhalten.

Für den #emph("Discovery") Prozess sind IP-Adressen der Geräte sowie Zugangsdaten notwendig. Die Zugangsdaten werden in primär und sekundär unterteilt. Primär wird #htl3r.short[snmp] als Zugang verwendet. Zusätzlich werden sekundäre Optionen wie Telnet, #htl3r.short[ssh], #htl3r.short[wmi], #htl3r.short[ldap], oder Cisco- und Fortinet-Zugangsdaten angeboten.

=== Abfragen der Daten

Nachdem das FortiSIEM Logs und Events gespeichert hat, können diese im #emph("Analytics") Dashboard abgefragt werden. Das #htl3r.short[siem] unterscheidet basierend auf den Anforderungen des Nutzers zwischen #emph("Real-time") und #emph("Historical Search"). In der #emph("Real-time") Ansicht werden alle Logs und Events in Echtzeit bis zu einem bestimmten Zeitpunkt angezeigt. Im Gegensatz dazu können im #emph("Historical Search") alle zugänglichen Daten in einem bestimmten Zeitraum (relativ oder absolut) abgerufen werden.

Die Events können beim Abrufen nach unterschiedlichen Attributen gefiltert werden. Dabei können Informationen wie Hostname und IP-Adresse direkt aus der #htl3r.long[cmdb] entnommen werden. Die Filter sind miteinander über AND und OR sowie Klammern verknüpfbar, um komplexere Abfragen zu ermöglichen. Die Abfragen können gespeichert und anschließend beliebig oft erneut ausgeführt werden.

// Auszug aus dem Analytics Dashboard

=== Regeln und #emph("Incidents")

Regeln sind im FortiSIEM essentiell für das Generieren von #emph("Incidents") im System. Das Sammeln und Aggregieren von Daten ist nur die halbe Miete, denn diese menschlich zu Interpretieren und daraufhin in der aktiven Netzwerkkonfiguration zu implementieren ist bei einer gigantischen Menge von Daten unvorstellbar. Regeln erlauben es, sogenannte #emph("Patterns") mithilfe von Abfragen zu erstellen, um basierend auf den abgefragten Daten Konditionen festzulegen. Falls alle Konditionen einer Regeln erfüllt werden, wird ein #emph("Incident") generiert.

Mithilfe der #htl3r.long[pam] Daten können #emph("Performance Rules") aufgestellt werden. Diese können beispielsweise bei Erreichung eines bestimmten Speicherlimits oder bei Überschreitung der #htl3r.short[cpu]-Auslastung ein #emph("Incident") generieren. Im #emph("Analytics Tab") können auch direkt beim Erstellen von Abfragen Regeln konfiguriert werden. FortiSIEM ist auch mit MITREs #htl3r.short[attck]-Datenbank kompatibel, um Regeln mit den neusten globalen Sicherheitslücken zu verbinden.

// Auszug aus Regel-Config

#emph("Incidents") geben Systemadministratoren einen Überblick über die derzeitigen Schwachstellen in einem Netzwerk. Anhand den Daten generiert das FortiSIEM ein #emph("Incident")-Dashboard. Über #emph("Notification Policies") lassen sich automatisierte E-Mails oder #htl3r.short[sms] verschicken, die mit vordefinierten E-Mail-Templates ausgestattet sind und individuelle Nachrichten beinhalten können.

Für die Überwachung von systemkritischen Appilkationen stellt das FortiSIEM sogenannte #emph("Business Services") bereit. Dadurch können spezielle #emph("Incidents") für Applikationen wie Oracle und SQL-Datenbanken oder Microsoft-Exchange-Server generiert werden. Diese Daten können in individuellen #emph("Business Service Dashboards") sichtbar gestaltet werden.

== Supervisor-Node <fsm-supervisor>
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

Elasticsearch bietet im Gegensatz zu anderen Optionen bessere Performance und Skalierbarkeit @elastic-vs-sql. In der Topologie wird nur eine Elasticsearch-Data-Node für das FortiSIEM verwendet. Die gesamte Konfiguration wird im @elastic-config im Detail aufgelistet.

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
