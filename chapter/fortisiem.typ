#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")

= FortiSIEM
Für die Implementierung eines #htl3r.short[siem] in die Topologie wird ein FortiSIEM der Firma Fortinet verwendet. Es kann agent-based oder agentless Logs und Events von Geräten abrufen. In den meisten Fällen wird Syslog oder #htl3r.short[snmp] zur Kommunikation der Geräte mit dem SIEM verwendet. Es gibt aber auch Ausnahmen, wie im Falle von Windows. Windows Server können entweder mittels #htl3r.short[wmi] oder dem FortiSIEM Windows Agent Daten an das SIEM übermitteln. Der Vorteil an den Agents liegt darin, dass Logs direkt am Gerät geparsed und verschickt werden können, statt mehrere Logs in einem bestimmten Intervall durch das FortiSIEM abzurufen. 
\
Des Weiteren kann das FortiSIEM Basismetriken durch das #htl3r.short[pam] abrufen. Dies beinhaltet Daten wie den Zustand einer Applikation, Ressourcenverbrauch eines Geräts und vieles mehr. Dadurch können Anomalien in den Daten erkannt werden und Warnungen im FortiSIEM auslösen. 



== Supervisor-Node
In der Event Database speichert das FortiSIEM alle Events und Logs. Hier dient die Supervisor-Node als zentraler Knotenpunkt, der von den anderen Collector- oder Worker-Nodes die Daten erhält und aggregiert. Für die Event Database des FortiSIEM können unterschiedliche Datenbanken gewählt werden. Fortinet bietet hier folgende Optionen an:
- ClickHouse
- NFS Share
- Local Disk
- ElasticSearch
\ \ \ \ \ \ \ \ 
Elasticsearch bietet im Gegensatz zu anderen Optionen bessere Performance und Skalierbarkeit. Die Installationsanforderungen für die Supervisor-Node des FortiSIEM (Version 7.2.4) belaufen sich auf:
- 12 vCPU
- 24 GB RAM
- OS Drive: 25GB
- OPT Drive: 100GB
- CMDB Drive: 60GB
- SVN Drive: 60GB
- Event Database: Elasticsearch

=== Elasticsearch-Konfiguration
Für das Elasticsearch wurde ein Ubuntu-Server verwendet. Hierbei wird nicht der gesamte ELK-Stack, sondern nur Elasticsearch selbst installiert. Zur besseren Übersicht wurde noch Kibana für einen direkten Zugriff über ein #htl3r.short[gui] auf das Elasticsearch konfiguriert.
\ \
#htl3r.code-file(
  caption: "Installationsscript von Elasticsearch",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((8, 17), (80, 80),),
  skips: ((19,0),),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)

Für das Betreiben eines Elasticsearch auf einem Linux-Server müssen systemweite Konfigurationen übernommen werden. Dabei muss für bestmögliche Performance die Anzahl an Threads auf 4096 und die Anzahl an 

#htl3r.code-file(
  caption: "systemweite Konfiguration",
  filename: [fortisiem/elasticsearch_script1.sh],
  lang: "sh",
  ranges: ((30, 51),),
  skips: ((19,0),),
  text: read("../assets/fortisiem/elasticsearch_script1.sh")
)