#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")l

= FortiAnalyzer <faz>

Der FortiAnalyzer dient zur Unterstützung von #htl3r.shortpl[soc] in einem Netzwerk. Mithilfe der Integration in das Fortinet-Ökosystem bietet der FortiAnalyzer eine Übersicht über Risiken und Schwachstellen von Security-Geräten wie Firewalls. Es aggregiert alle Logs von Fortinet-Komponenten um daraus übersichtliche Dashboards und Reports für #htl3r.short[soc]-Teams zu bauen.

Mithilfe von #htl3r.shortpl[adom] kann der Zugriff auf Logs und Funktionen im #htl3r.short[gui] sowie #htl3r.short[cli] eingeschränkt werden. Dies ist besonders für große #htl3r.long[soc] sinnvoll. Ds Weiteren können für Mitarbeiter des #htl3r.short[soc]-Teams automatische Reports als PDF per

== Zertifizierung <faz-cert>

Als Training für die Zeritifizierungsprüfung wurden die Labor-Übungen vom FortiAnalyzer Kurs durchgeführt. Diese wurden in vier Kapitel unterteilt, die an die Kapitel aus dem Online-Kurs angelehnt sind:

1. #emph("Initial Configuration")
2. #emph("Administration and Management")
3. #emph("Device Registration and Communication")
4. #emph("Log and Report Management")

=== Grundkonfiguration des FortiAnalyzers <faz-cert-conf>

Die FortiAnalyzer-#htl3r.short[vm] ist mit 8 GB RAM und 4 v#htl3r.short[cpu] ausgestattet. FortiAnalyzer basiert im Gegensatz zum FortiSIEM auf FortiOS, dass auch FortiGates verwenden. Dies ermöglicht die Konfiguration über das #htl3r.long[cli]. Für einen #htl3r.short[gui]-Zugriff wird eine Management-IP benötigt, die #htl3r.short[http] beziehungsweise #htl3r.short[https] am Interface erlaubt. Dadurch ist es möglich, den FortiAnalyzer über ein Menü zu administrieren, dass dem der FortiGate ähnelt. Um den FortiAnalyzer über ein #htl3r.short[gui] zu bedienen, konfigurieren wir über das #htl3r.long[cli] die IP-Adresse zum #htl3r.short[soc]-#htl3r.short[vlan] vom Standort Wien.

#htl3r.code-file(
  caption: "Interface-Konfiguration des FortiAnalyzer",
  filename: [fortianalyzer/WIEN-3BB-FAZ],
  ranges: ((1, 7), (14, 14)),
  skips: ((8, 0), ),
  lang: "fortios",
  text: read("../assets/fortianalyzer/WIEN-3BB-FAZ")
)

Die Lizensierung basiert auf der in der Lizenz eingetragenen IP-Adresse. Im Portal `support.fortinet.com` wird die IP-Adresse hinterlegt und die Lizenz heruntergeladen. Im FortiAnalyzer-#htl3r.short[gui] wird die Lizenz dann hochgeladen. Es ist eine Internetverbindung notwendig, um die online hinterlegte IP-Adresse der Lizenz zu überprüfen.

=== Logs aggregieren <faz-cert-logs>

Damit der FortiAnalyzer Logs der Geräte sammeln kann, müssen diese mittels #emph("Fabric Connectors") verbunden werden. Die Konfiguration dafür erfolgt explizit auf jedem Gerät. Anschließend können die Geräte entsprechend den #htl3r.short[adom]s zugeteilt werden um diese für bestimmte Nutzer zugänglich zu machen. Daraufhin kann beispielsweise die Auslastung oder der Speicherbedarf einzelner Komponenten zentral überwacht werden.

Die Konfiguration der Benutzer kann auch mit einem bestehenden #htl3r.short[ldap]-Service verknüpft werden. Dabei greift der FortiAnalyzer auf eine bestimmte Gruppe in der #htl3r.long[ad] Infrastruktur zu, um die User dieser Gruppe automatisch im FortiAnalyzer zu integrieren. Für das Abfragen der Daten von einem #htl3r.short[ldap]-Server sind entsprechende Zugangsdaten erforderlich.

=== Reports <faz-cert-reports>

Um laufend über das Geschehen im Netzwerk informiert zu werden, können im FortiAnalyzer Reports angelegt werden. Diese geben einen guten Überblick der vergangenen Tage und Wochen. Mithilfe von Report-Templates können für verschiedene #htl3r.shortpl[adom] und Geräte anhand einer einheitlichen Vorlage Reports generieren. Diese können dann über unterschiedlichste Formate über E-Mail verschickt werden.

Im folgenden Beispiel wurde ein Report am Standort Wien generiert. Die Daten von der FortiGate der letzten sieben Tage wurden dabei aggregiert und in Grafiken zusammengefasst. Nicht nur die Durchschnittswerte, sondern auch die Höchswerte von #htl3r.short[cpu]- und Speicherauslastung werden angezeigt. Darunter befindet sich der genaue Verlauf der letzten Woche.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/fortianalyzer/faz-report.png"),
    caption: [Auszug aus einem FortiAnalyzer Report]
  )
)

== Konfiguration des Fabric Connectors <faz-fg>

Um die FortiGate mit dem FortiAnalyzer zu verbinden, muss die Konfiguration an der FortiGate durchgeführt werden. Im Falle des Standorts Wien wurde am Interface Richtung #htl3r.short[soc]-#htl3r.short[vlan] der Zugang für eine Security Fabric Connection erlaubt. Dies beinhaltet die Protokolle #htl3r.short[capwap] und FortiTelemetry. Im Anschluss kann die IP des FortiAnalyzers in Kombination mit der Seriennummer angegeben werden. Im FortiAnalyzer sollte nun die FortiGate zu sehen sein.

#htl3r.code-file(
  caption: "Fabric Connector Konfiguration an der FortiGate",
  filename: [fortianalyzer/WIEN-3BB-FG],
  lang: "fortios",
  text: read("../assets/fortianalyzer/WIEN-3BB-FG"),
)
