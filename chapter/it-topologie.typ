#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")

#pagebreak()

== IT-Topologie

Für die IT-Topologie wurde ein #htl3r.long[ad] mit zwei Standorten konfiguriert. Die Standorte werden mit jeweils einer FortiGate abgesichert und gemeinsam mit einem Site-to-Site #htl3r.short[vpn] verbunden.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/topologie/it-topologie/topo-it.png"),
    caption: [logischer Netzplan der IT-Topolgie]
  )
)

#figure(
  image("../assets/topologie/3BB_FCP_Topologie.jpg"),
  caption: "IT-Topologie"
)

Der Standort Wien ist in vier #htl3r.shortpl[vlan] mikrosegmentiert. Zwischen den einzelnen #htl3r.short[vlan] routet die FortiGate mittels Inter-#htl3r.short[vlan]-Routing die Subnetze. Dabei wird auch der Traffic auf das nötigste limitiert, um das Angriffspotenzial einzuschränken. Der Standort Eisenstadt trennt nur zwischen Mitarbeiter-PCs und restlichen Servern. Hier übernimmt ebenfalls die FortiGate die Kommunikation zwischen den #htl3r.shortpl[vlan]. Die #htl3r.shortpl[vlan] werden virtuell am vSphere mittels Distributed Portgroups konfiguriert.

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (0.5fr, 0.9fr, 0.75fr, 2fr),
      align: (center, center, center, center),
      table.header[*VLAN ID*][*Name*][*Subnetz*][*Geräte*],
      [370], [WIEN-DC], [10.1.18.0/24], [Domain Controller und Jump-Server],
      [371], [WIEN-SERVERS], [10.2.18.0/24], [FTP-Server und Elasticsearch-Node],
      [372], [WIEN-SOC], [10.3.18.0/24], [FortiSIEM-Supervisor, -Worker, -Collector, FortiAnalyzer, FortiManager],
      [373], [WIEN-CLIENTS], [10.4.18.0/24], [Alle Mitarbeiter PCs],
    ),
    caption: [Die Mikrosegmentierung von Standort Wien]
  )
)

=== FTP-Server

Der #htl3r.short[ftp]-Server wurde in die Topologie implementiert, um das Speichern von Konfigurationen zu erleichtern. Komponenten wie Windows oder Linux-Server können so ihre Powershell-Scripts herunterladen und ausführen. Das erleichtert die Provisionierung, falls Komponenten einen Ausfall erleiden. Manche Geräte von Fortinet, wie z.B. der FortiAnalyzer, können ihre Konfigurationen auch automatisch auf einen FTP-Server hochladen. Für das FortiSIEM wurden die Windows- und Linux-Agents abgelegt, um diese auf die einzelnen Komponenten zu verteilen.

#htl3r.author("Magdalena Feldhofer")
=== FortiGate
Die physische 60E FortiGate wird mittels LAN-Kabel mit dem Switch der OT verbunden, als auch mit dem Switch der UCS. Die UCS ist ein Unified Computing System von Cisco, auf dem System laufen eine vielzahl an Virtuellen Maschinen (VMs), welche gemeinsam die IT-Seite des Netzwerkes bilden. Auf der UCS sind die VMs in unterschiedliche Vlans aufgeteilt und sehen sich so untereinander nur eingeschränkt. \

#figure(
  image("../assets/topologie/3BB_FCP_Topologie.jpg"),
  caption: "IT-Topologie"
)

Um die Standorte Wien, Eisenstadt und das Zugnetzwerk zu verbinden, sind drei Firewalls im einsatz. Die eine Physische 60E und zwei virtuelle FortiGates in der Version 7.6. Alle drei haben ein Interface in einem Vlan, in welchem nur sie kommunizieren können, es simuliert das Internet. Dadurch, dass man Daten zwischen Standorten nicht unverschlüsselt übertragen möchte, werden IPSec VPN Tunnel zwischen den Standorten gespannt mit dem Full-Mesh Modell (jede Firewall ist mit jeder anderen verbunden).
