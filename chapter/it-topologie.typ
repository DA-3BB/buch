#import "@preview/htl3r-da:2.0.0" as htl3r
#import "@preview/treet:0.1.1": *
#htl3r.author("Albin Gashi")

== IT-Topologie

Für die IT-Topologie wurde ein #htl3r.long[ad] mit zwei Standorten konfiguriert. Die Standorte werden mit jeweils einer FortiGate abgesichert und gemeinsam mit einem Site-to-Site #htl3r.short[vpn] verbunden.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/it-topologie/topo-it.png"),
    caption: [logischer Netzplan der IT-Topologie]
  )
)

Der Standort Wien ist in vier #htl3r.shortpl[vlan] mikrosegmentiert. Zwischen den einzelnen #htl3r.shortpl[vlan] routet die FortiGate mittels Inter-#htl3r.short[vlan]-Routing die Subnetze. Dabei wird mittels Firewall-Policies der Zugriff zwischen den VLANs begrenzt. Der Standort Eisenstadt trennt nur zwischen PCs des Personals und Servern. Hier übernimmt ebenfalls die FortiGate die Kommunikation zwischen den #htl3r.shortpl[vlan]. Die #htl3r.shortpl[vlan] werden virtuell am vSphere mittels Distributed Virtual Switch konfiguriert.

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
      [373], [WIEN-CLIENTS], [10.4.18.0/24], [Alle PCs des Personals],
    ),
    caption: [Die Mikrosegmentierung von Standort Wien]
  )
)

Für die Limitierung des Traffics werden auf der FortiGate Policies konfiguriert. Dabei werden nur die benötigten Services zur Weiterleitung erlaubt. Beispielsweise benötigt der Übergang vom #htl3r.short[soc]-#htl3r.short[vlan] in das Domain Controller #htl3r.short[vlan] die Protokolle #htl3r.short[http], #htl3r.short[https] und #htl3r.short[ldap], um die Verbindung von Domain Controllern und dem #htl3r.short[siem] sicher zu stellen. Für die PCs des Personals wird zur Kommunikation mit den Domain Controllern Kerberos, #htl3r.short[ldap] und #htl3r.short[dns] benötigt.

=== Speichern von Konfigurationen

Der #htl3r.short[ftp]-Server wurde in die Topologie implementiert, um das Speichern von Konfigurationen zu erleichtern. Komponenten wie Windows oder Linux-Server können so ihre Powershell und Bash-Scripts herunterladen und ausführen. Das erleichtert die Provisionierung, falls Komponenten einen Ausfall erleiden. Manche Geräte von Fortinet, wie z.B. der FortiAnalyzer, können ihre Konfigurationen auch automatisch auf einen FTP-Server hochladen. Für das FortiSIEM wurden die Windows- und Linux-Agents abgelegt, um diese auf die einzelnen Komponenten zu verteilen.

Der #htl3r.short[ftp]-Server wurde mit dem Package `vsftpd` realisiert. Ein User mit zugehörigem Home-Ordner, auf dem die Ablage der Scripts durchgeführt wird, wurde erstellt. Die Begrenzung des Zugriffs auf die Verzeichnisse wurde durch `chroot_local_user=YES` in \ `/etc/vsftpd.conf` durchgeführt.

#pagebreak()

=== Active Directory Infrastruktur <ad-infra>

Für die Implementierung der #htl3r.short[it]-Infrastruktur wurde eine #htl3r.long[ad] Domäne umgesetzt. Diese besteht aus zwei Standorten namens #emph("Wien") und #emph("Eisenstadt"). Beide Standorte werden durch zwei unterschiedliche Child-Domains betrieben (`wien.3bb-testlab.at` und `eisenstadt.3bb-testlab.at`). Der Standort Wien simuliert die Zentrale eines Unternehmens, auf dieser auch diverse Security-Geräte angesiedelt sind, die in @fsm und @faz näher erläutert werden. Die beiden Standorte bilden sich durch jeweils zwei Domain Controller und einem Jump-Server ab. Die beiden Standorte sind durch einen Site-Link zur notwendigen #htl3r.short[ldap]-Replikation verbunden.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/active-directory/ad-topo.png"),
    caption: [logische Topologie der AD-Infrastruktur]
  )
)

#pagebreak()

In jedem Unternehmen gibt es auch Abteilungen, die mittels #htl3r.shortpl[ou] realisiert wurden. Dabei wird auch zwischen den Servern und Computern im #htl3r.long[ad] unterschieden. Die Abteilungen #htl3r.short[it] und #htl3r.short[soc] sind auf dem Standort Eisenstadt nicht zu finden.

#htl3r.fspace(
  total-width: 100%,
  figure(
    align(center, box(align(left, text[
      #text(blue, tree-list(
        marker: text(gray)[├── ],
        last-marker: text(gray)[└── ],
        indent: text(teal)[│#h(1.5em)],
        empty-indent: h(2em),
      )[
        - Wien (wien.3bb-testlab.at)
          - Servers
          - Computers
          - Users
            - Management
            - Finance
            - Office
            - Marketing
            - #htl3r.short[it]
            - #htl3r.short[soc]
            - Protected Users
        - Eisenstadt (eisenstadt.3bb-testlab.at)
          - Servers
          - Computers
          - Users
            - Management
            - Office
            - Marketing
            - Protected Users
      ])
    ]))),
    caption: [Die OU-Struktur von 3bb-testlab.at]
  )
)

#pagebreak()

Die User und Gruppen sollen so realitätsnah wie möglich ein Unternehmen widerspiegeln. Dabei wurde primär auf den Aspekt eines #htl3r.long[soc] Rücksicht genommen, die mithilfe des FortiAnalyzer und des FortiSIEM die simulierten Mitarbeiterinnen und Mitarbeiter in die Netzwerküberwachung einbinden soll. Mehr dazu in @faz und @fsm. Jeweils ein Nutzer pro Abteilung wird als Protected User ausgeführt.

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (10em, auto, 8em),
      align: (left, left, center),
      table.header[*Benutzername*][*Name*][*Gruppe*],
      [mmustermann], [Max Mustermann], [Management],
      [abecker], [Anna Becker], [Management],
      [bschmidt], [Bernd Schmidt], [Management],
      [npfeffer], [Nick Pfeffer], [Finance],
      [lfischer], [Lukas Fischer], [Finance],
      [twagner], [Tina Wagner], [Finance],
      [pmeier], [Peter Meier], [Office],
      [cschmidt], [Clara Schmidt], [Office],
      [nhoffmann], [Nina Hoffmann], [Office],
      [vpuschner], [Victoria Puschner], [Marketing],
      [vkreuzer], [Viktor Kreuzer], [Marketing],
      [erichter], [Eva Richter], [Marketing],
      [jring], [Julian Ring], [#htl3r.short[it]],
      [sweber], [Sandra Weber], [#htl3r.short[it]],
      [cbauer], [Christian Bauer], [#htl3r.short[it]],
      [lefischer], [Lena Fischer], [#htl3r.short[soc]],
      [jklein], [Jonas Klein], [#htl3r.short[soc]],
      [fweber], [Franziska Weber], [#htl3r.short[soc]],
    ),
    caption: [Die Benutzer der Domäne 3bb-testlab.at]
  )
)

Um die Rechteverwaltung zu vereinfachen, wurde das #htl3r.short[agdlp]-Prinzip angewendet. Dadurch befinden sich die globalen Gruppen in Domain-Local Gruppen, die den Zugriff auf Ressourcen bestimmen. Die User befinden sich in den globalen Gruppen. Für jede Berechtigung (z.b. Lesen oder Schreiben) wird eine eigene Domain-Local Gruppe angelegt.
/*
#htl3r.fspace(
  total-width: 100%,W
  figure(
    table(
      columns: (10em, auto, 8em),
      align: (left, left, center),
      table.header[*Ordner*][*Domain-Local Gruppe*][*Rechte*],
      [Management], [DL-Management-R], [Lesen],
      [], [DL-Management-W], [Schreiben],
      [], [DL-Finance-R], [Lesen],
      [], [DL-IT-R], [Lesen],
      [], [DL-IT-W], [Schreiben],


      [Finance], [DL-Finance-R], [Lesen],
      [], [DL-Finance-W], [Schreiben],
      [], [DL-Management-R], [Lesen],
      [], [DL-Marketing-R], [Lesen],
      [], [DL-IT-R], [Lesen],
      [], [DL-IT-W], [Schreiben],

      [Office], [DL-Office-R], [Lesen],
      [], [DL-Office-W], [Schreiben],
      [], [DL-Management-R], [Lesen],
      [], [DL-Marketing-R], [Lesen],
      [], [DL-IT-R], [Lesen],
      [], [DL-IT-W], [Schreiben],

      [Marketing], [DL-Marketing-R], [Lesen],
      [], [DL-Marketing-W], [Schreiben],
      [], [DL-Management-R], [Lesen],
      [], [DL-IT-R], [Lesen],
      [], [DL-IT-W], [Schreiben],

      [IT], [DL-IT-R], [Lesen],
      [], [DL-IT-W], [Schreiben],
      [], [DL-SOC-R], [Lesen],
      [], [DL-SOC-W], [Schreiben],


      [SOC], [DL-SOC-R], [Lesen],
      [], [DL-SOC-W], [Schreiben],
    ),
    caption: [Einschränkung der Zugriffsrechte nach dem AGDLP-Prinzip]
  )
)
*/
#pagebreak()

Die Konfiguration der Domain Controller wurde mittels Powershell-Scripts durchgeführt. Im folgenden Script ist die Grundkonfiguration eines Windows-Servers zu sehen. Neben dem Hostname und der IP-Adresse für das Interface werden auch #htl3r.short[dns]- und #htl3r.short[ntp]-Server gesetzt. Der DNS-Server ist für den Fall des Domain-Controllers auf sich selber gesetzt, um die Funktionsfähigkeit des #htl3r.long[ad] zu garantieren. Dieser Abschnitt ist zu Beginn jedes Powershell-Scripts zu finden.
// Die Scripts wurden über einen #htl3r.short[ftp]-Server zentral verwaltet und am Domain Controller heruntergeladen und ausgeführt.

#htl3r.code-file(
  caption: "Grundkonfiguration eines Domain Controllers",
  filename: [active-directory/wien-3bb-dc1.ps1],
  lang: "PowerShell",
  ranges: ((8, 17),),
  skips: ((7,0),(18,0)),
  text: read("../assets/active-directory/wien-3bb-dc1.ps1")
)

Nach dem Neustart wird die #htl3r.short[adds]-Rolle für die Domain #emph("wien.3bb-testlab.at") installiert und der Server als Domain Controller hochgestuft. Anschließend werden die Standorte Wien und Eisenstadt eingerichtet und mit einem Site-Link verbunden.

#htl3r.code-file(
  caption: "Installieren der ADDS-Rolle",
  filename: [active-directory/wien-3bb-dc1.ps1],
  lang: "PowerShell",
  ranges: ((23, 24), (30, 31), (33, 36)),
  skips: ((22,0), (25,0), (32, 0), (37, 0)),
  text: read("../assets/active-directory/wien-3bb-dc1.ps1")
)

Am Standort Wien wird ein redundanter #htl3r.short[dhcp]-Server betrieben. Die beiden Domain Controller teilen sich einen gemeinsamen Adressbereich mittels #htl3r.short[dhcp]-Failover auf. Hiefür werden neben der #htl3r.short[dhcp] Rolle im #htl3r.long[ad] die Adressbereiche mit ihren zugehörigen Default-Gateways und DNS-Servern konfiguriert. Zum Schluss wird der zweite Domain Controller als Partner-Server für den #htl3r.short[dhcp]-Failover angegeben.

#htl3r.code-file(
  caption: "Einrichten eines DHCP-Failovers",
  filename: [active-directory/wien-3bb-dc1.ps1],
  lang: "PowerShell",
  ranges: ((98, 104), ),
  skips: ((97, 0), (105, 0)),
  text: read("../assets/active-directory/wien-3bb-dc1.ps1")
)

#pagebreak()

Um die beiden Domain-Controller besser zu administrieren wurde ein Jump-Server eingerichtet. Dieser erhält durch Windows Remote Management Zugriffsberechtigungen auf die beiden Domain-Controller. Der Server-Manager bietet dabei einen Überblick über die Domain-Controller und deren Status. Durch die #htl3r.longpl[rsat] kann der Jump-Server vollständig die Konfiguration der Server übernehmen.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/active-directory/ad-jump.jpg"),
    caption: [logischer Netzplan der IT-Topologie]
  )
)

Auf Basis dieser Topologie wird nun das #htl3r.short[siem] das Netzwerk überwachen und das #htl3r.long[soc] durch #htl3r.short[ldap] angebunden. Die Mitarbeiterinnen und Mitarbeiter der #htl3r.long[ad] Infrastruktur sollen dabei Zugriff auf die Geräte besitzen. Näheres zur Umsetzung wird in @faz und @fsm erläutert.











#htl3r.author("Magdalena Feldhofer")
=== FortiGate

Die physische 60E FortiGate wird mittels LAN-Kabel mit dem Switch der OT verbunden, als auch mit dem Switch der UCS.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/it-topologie/it-ot-verbindung.jpg"),
    caption: [Physische Verbindung der IT mit der OT]
  )
)

Um die Standorte Wien, Eisenstadt und das Zugnetzwerk zu verbinden, sind drei Firewalls im einsatz. Die eine Physische 60E und zwei virtuelle FortiGates in der Version 7.6. Alle drei haben ein Interface in einem Vlan, in welchem nur sie kommunizieren können, es simuliert das Internet. Dadurch, dass man Daten zwischen Standorten nicht unverschlüsselt übertragen möchte, werden IPSec VPN Tunnel zwischen den Standorten gespannt mit dem Full-Mesh Modell (jede Firewall ist mit jeder anderen verbunden).
