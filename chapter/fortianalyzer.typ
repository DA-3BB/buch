#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Albin Gashi")

= Security Operations Center <faz>

Um eine realitätsnahe #htl3r.short[soc]-Umgebung zu schaffen, wird der FortiAnalyzer in die Topologie implementiert. Mithilfe der Integration in das Fortinet-Ökosystem bietet der FortiAnalyzer eine Übersicht über Risiken und Schwachstellen von Security-Geräten wie Firewalls. Es aggregiert alle Logs von Fortinet-Komponenten, um daraus übersichtliche Dashboards und Reports für #htl3r.short[soc]-Teams zu bauen @fortianalyzer.

Mithilfe von #htl3r.shortpl[adom] kann der Zugriff auf Logs und Funktionen im #htl3r.short[gui] sowie #htl3r.short[cli] eingeschränkt werden. Dies ist besonders für große #htl3r.long[soc] sinnvoll. Des Weiteren können für Mitarbeiterinnen und Mitarbeiter des #htl3r.short[soc]-Teams automatische Reports als HTML, PDF, XML, CSV oder JSON generiert werden.

== FortiAnalyzer-Zertifizierung <faz-cert>

Zum Aneignen des Zertifizierungswissens und als Training für die Zertifikatsprüfung wurden die Labor-Übungen vom FortiAnalyzer Kurs durchgeführt. Diese wurden in vier Kapitel unterteilt, die an die Kapitel aus dem Online-Kurs angelehnt sind:

1. #emph("Initial Configuration")
2. #emph("Administration and Management")
3. #emph("Device Registration and Communication")
4. #emph("Log and Report Management")

#pagebreak()

== Konfiguration des FortiAnalyzers <faz-cert-conf>

Die FortiAnalyzer-#htl3r.short[vm] ist mit 8 GB RAM und 4 v#htl3r.short[cpu] ausgestattet. FortiAnalyzer basiert im Gegensatz zum FortiSIEM auf FortiOS, dass auch FortiGates verwenden. Dies ermöglicht die Konfiguration über das #htl3r.long[cli]. Für einen #htl3r.short[gui]-Zugriff wird eine Management-IP benötigt, die #htl3r.short[http] beziehungsweise #htl3r.short[https] am Interface erlaubt. Dadurch ist es möglich, den FortiAnalyzer über ein Menü zu administrieren, dass dem der FortiGate ähnelt. Um den FortiAnalyzer über ein #htl3r.short[gui] zu bedienen, konfigurieren wir über das #htl3r.long[cli] die IP-Adresse zum #htl3r.short[soc]-#htl3r.short[vlan] vom Standort Wien.

#htl3r.code-file(
  caption: "Interface-Konfiguration des FortiAnalyzer",
  filename: [fortianalyzer/WIEN-3BB-FAZ],
  ranges: ((1, 7), (14, 14)),
  skips: ((8, 0), ),
  lang: "fortios",
  text: read("../assets/fortianalyzer/WIEN-3BB-FAZ")
)

Die Lizenzierung basiert auf der in der Lizenz eingetragenen IP-Adresse. Im Portal `support.fortinet.com` wird die IP-Adresse hinterlegt und die Lizenz heruntergeladen. Im FortiAnalyzer-#htl3r.short[gui] wird die Lizenz dann hochgeladen. Es ist eine Internetverbindung notwendig, um die online hinterlegte IP-Adresse der Lizenz zu überprüfen.

Um die FortiGate mit dem FortiAnalyzer zu verbinden, muss die Konfiguration an der FortiGate durchgeführt werden. Im Falle des Standorts Wien wurde am Interface Richtung #htl3r.short[soc]-#htl3r.short[vlan] der Zugang für eine Security Fabric Connection erlaubt. Dies beinhaltet die Protokolle #htl3r.short[capwap] und FortiTelemetry. Im Anschluss kann die IP des FortiAnalyzers in Kombination mit der Seriennummer angegeben werden. Im FortiAnalyzer sollte nun die FortiGate zu sehen sein.

#pagebreak()

#htl3r.code-file(
  caption: "Fabric Connector Konfiguration an der FortiGate",
  filename: [fortianalyzer/WIEN-3BB-FG],
  lang: "fortios",
  text: read("../assets/fortianalyzer/WIEN-3BB-FG"),
)

=== Logs aggregieren <faz-cert-logs>

Damit der FortiAnalyzer Logs der Geräte sammeln kann, müssen diese mittels #emph("Fabric Connectors") verbunden werden. Die Konfiguration dafür erfolgt explizit auf jedem Gerät. Anschließend können die Geräte entsprechend den #htl3r.short[adom]s zugeteilt werden, um diese für bestimmte Nutzer zugänglich zu machen. Daraufhin kann beispielsweise die Auslastung oder der Speicherbedarf einzelner Komponenten zentral überwacht werden.

Die Konfiguration der User kann auch mit einem bestehenden #htl3r.short[ldap]-Service verknüpft werden. Dabei greift der FortiAnalyzer auf eine bestimmte Gruppe in der #htl3r.long[ad] Infrastruktur zu, um die User dieser Gruppe automatisch im FortiAnalyzer zu integrieren. Für das Abfragen der Daten von einem #htl3r.short[ldap]-Server sind entsprechende Zugangsdaten erforderlich.

#pagebreak()

=== Reports <faz-cert-reports>

Um laufend über das Geschehen im Netzwerk informiert zu werden, können im FortiAnalyzer Reports angelegt werden. Diese geben einen guten Überblick der vergangenen Tage und Wochen. Mithilfe von Report-Templates können für verschiedene #htl3r.shortpl[adom] und Geräte anhand einer einheitlichen Vorlage Reports generieren. Diese können dann über unterschiedlichste Formate über E-Mail verschickt werden.

Im folgenden Beispiel wurde ein Report am Standort Wien generiert. Die Daten von der FortiGate der letzten sieben Tage wurden dabei aggregiert und in Grafiken zusammengefasst. Nicht nur die Durchschnittswerte, sondern auch die Höchstwerte von #htl3r.short[cpu]- und Speicherauslastung werden angezeigt. Darunter befindet sich der genaue Verlauf der zum Zeitpunkt des Reports festgehaltenen Woche.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortianalyzer/faz-report.jpg"),
    caption: [Auszug aus einem FortiAnalyzer Report]
  )
)

=== Dashboards

Im #htl3r.long[soc] spielt auch die Inspizierung des Traffics eine wichtige Rolle. Durch die FortiAnalyzer-Dashboard kann schnell ein Überblick über die Geschehnisse im Netzwerk gewonnen werden. Neben aktiven Sessions kann auch ermittelt werden, welche Geräte am meisten Bandbreite verbrauchen und in welche Länder die Sessions terminieren. Am Beispiel der #htl3r.short[ad] Infrastruktur konsumieren die Windows-Clients und der Jump-Server am meisten Bandbreite. Die Länder mit dem größten Datenaufkommen sind Österreich, Großbritannien und die USA.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortianalyzer/faz-traffic.jpg"),
    caption: [SOC-Dashboard des FortiAnalyzers]
  )
)

Durch die Einbindung des #htl3r.short[ldap]-Servers bekommen die Mitarbeiterinnen und Mitarbeiter des unternehmensinternen #htl3r.long[soc] die Möglichkeit, jederzeit einen Blick auf die Dashboards zu werfen. In diesem Fall ist die Mitarbeiterin Lena Fischer die Vorsitzende des #htl3r.long[soc] und erhält dadurch auch den Zugang auf den FortiAnalyzer. Im folgenden Abbild werden die zu konfigurierenden Parameter für eine #htl3r.short[ldap]-Authentifizierung aufgelistet.

#htl3r.fspace(
  //total-width: 70%,
  figure(
    image("../assets/fortianalyzer/faz-ldap.jpg", width: 100%),
    caption: [Konfiguration des LDAP-Servers im FortiAnalyzer]
  )
)
