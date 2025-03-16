#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")
#import "@preview/treet:0.1.1": *

= #htl3r.long[ad] Infrastruktur <ad-infra>

Für die Implementierung der #htl3r.short[it]-Infrastruktur wurde eine #htl3r.long[ad] Domäne umgesetzt. Diese besteht aus zwei Standorten namens #emph("Wien") und #emph("Eisenstadt"). Beide Standorte werden durch zwei unterschiedliche Child-Domains betrieben (wien.3bb-testlab.at und eisenstadt.3bb-testlab.at). Der Standort Wien simuliert die Zentrale eines Unternehmens, auf dieser auch diverse Security-Geräte angesiedelt sind, die in /*@fsm*/ und /*@faz*/ näher erläutert werden. Zwei Domain-Controller bilden den Standort Wien mit einem Jump-Server ab. Der Standort Eisenstadt besitzt nur einen Domain-Controller und erhält ein RDS-Gateway. Die beiden Standorte sind durch einen Site-Link zur notwendigen #htl3r.short[ldap]-Replikation verbunden.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/active-directory/ad-topology.png"),
    caption: [logische Topologie der #htl3r.short[ad]-Infrastruktur]
  )
)


Ein Unternehmen schafft auch Abteilungen, die mittels #htl3r.shortpl[ou] realisiert wurden. Dabei wird auch zwischen den Servern und Computern im #htl3r.long[ad] unterschieden. Die Abteilungen #htl3r.short[it] und #htl3r.short[soc] sind auf dem Standort Eisenstadt nicht zu finden.

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
    caption: [Die #htl3r.short[ou]-Struktur von 3bb-testlab.at]
  )
)

== Benutzer und Gruppen <ad-ug>

Die Benutzer und Gruppen sollen so realitätsnah wie möglich ein Unternehmen widerspiegeln. Dabei wurde primär auf den Aspekt eines #htl3r.long[soc] Rücksicht genommen, die mithilfe des FortiAnalyzer die simulierten Mitarbeiterinnen und Mitarbeiter in die Netzwerküberwachung einbinden soll. Jeweils ein Nutzer pro Abteilung wird mittels Protected Users abgesichert.

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
      [sklein], [Sophie Klein], [Finance],
      [lfischer], [Lukas Fischer], [Finance],
      [twagner], [Tina Wagner], [Finance],
      [pmeier], [Peter Meier], [Office],
      [cschmidt], [Clara Schmidt], [Office],
      [nhoffmann], [Nina Hoffmann], [Office],
      [jschwarz], [Julia Schwarz], [Marketing],
      [dmueller], [David Müller], [Marketing],
      [erichter], [Eva Richter], [Marketing],
      [mbauer], [Maximilian Bauer], [#htl3r.short[it]],
      [sweber], [Sandra Weber], [#htl3r.short[it]],
      [cbauer], [Christian Bauer], [#htl3r.short[it]],
      [lefischer], [Lena Fischer], [#htl3r.short[soc]],
      [jklein], [Jonas Klein], [#htl3r.short[soc]],
      [fweber], [Franziska Weber], [#htl3r.short[soc]],
    ),
    caption: [Die Benutzer der Domäne 3bb-testlab.at]
  )
)

Um die Rechteverwaltung zu vereinfachen wurde das #htl3r.short[agdlp]-Prinzip angewendet. Dadurch befinden sich die globalen Gruppen in Domain-Local Gruppen, die den Zugriff auf Ressourcen bestimmen. Die User befinden sich in den globalen Gruppen. Für jede Berechtigung (z.b. Lesen oder Schreiben) wird eine eigene Domain-Local Gruppe angelegt.

#htl3r.fspace(
  total-width: 100%,
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
    caption: [Einschränkung der Zugriffsrechte nach dem #htl3r.short[agdlp]-Prinzip]
  )
)

== Konfiguration <ad-conf>

Die Konfiguration der Domain Controller wurde mittels Powershell-Scripts durchgeführt. Die Scripts wurden über einen #htl3r.short[ftp]-Server zentral verwaltet und von den Domain Controllern heruntergeladen und ausgeführt.

#htl3r.code-file(
  caption: "Grundkonfiguration eines Domain Controllers",
  filename: [active-directory/WIEN-3BB-DC1.ps1],
  lang: "PowerShell",
  ranges: ((8, 17),),
  skips: ((7,0),(18,0)),
  text: read("../assets/active-directory/wien-3bb-dc1.ps1")
)

Nach dem Neustart wird die #htl3r.short[adds]-Rolle für die Domain #emph("wien.3bb-testlab.at") installiert und der Server als Domain Controller hochgestuft. Anschließend werden die Standorte Wien und Eisenstadt eingerichtet und mit einem Site-Link verbunden.

#htl3r.code-file(
  caption: "Installieren der " + htl3r.short[adds] + "-Rolle",
  filename: [active-directory/WIEN-3BB-DC1.ps1],
  lang: "PowerShell",
  ranges: ((23, 24), (30, 36)),
  skips: ((22,0), (25,0), (29, 0), (37, 0)),
  text: read("../assets/active-directory/wien-3bb-dc1.ps1")
)

Am Standort Wien wird ein redundanter #htl3r.short[dhcp]-Server betrieben. Die beiden Domain Controllern teilen sich einen gemeinsamen Adressbereich mittels #htl3r.short[dhcp]-Failover auf.

#htl3r.code-file(
  caption: "Einrichten eines " + htl3r.short[dhcp] + "-Failovers",
  filename: [active-directory/WIEN-3BB-DC1.ps1],
  lang: "PowerShell",
  ranges: ((98, 104), ),
  skips: ((97, 0), (105, 0)),
  text: read("../assets/active-directory/wien-3bb-dc1.ps1")
)
