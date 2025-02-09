#import "@preview/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")

= FortiAnalyzer <faz>

Der FortiAnalyzer dient zur Unterstützung von #htl3r.shortpl[soc] in einem Netzwerk. Mithilfe der Integration in das Fortinet-Ökosystem bietet der FortiAnalyzer eine Übersicht über Probleme von Security-Geräten. Es aggregiert alle Logs von Fortinet-Komponenten um daraus übersichtliche Dashboards und Reports für #htl3r.short[soc]-Teams zu bauen.

Mithilfe von #htl3r.shortpl[adom] kann der Zugriff auf Logs und Funktionen im #htl3r.short[gui] sowie #htl3r.short[cli] eingeschränkt werden. Dies ist besonders für große #htl3r.long[soc] sinnvoll.

== Zertifizierung <faz-cert>

Als Training für die Zeritifizierungsprüfung wurden die Labor-Übungen vom FortiAnalyzer Kurs durchgeführt. Diese wurden in vier Kapitel unterteilt, die an die Kapitel aus dem Online-Kurs angelehnt sind:

1. #emph("Initial Configuration")
2. #emph("Administration and Management")
3. #emph("Device Registration and Communication")
4. #emph("Log and Report Management")

=== Grundkonfiguration des FortiAnalyzers <faz-cert-conf>

FortiAnalyzer basiert im Gegensatz zum FortiSIEM auf FortiOS, dass auch FortiGates verwenden. Dies ermöglicht die Konfiguration über das #htl3r.long[cli]. Für einen #htl3r.short[gui]-Zugriff wird eine Management-IP benötigt, die #htl3r.short[http] beziehungsweise #htl3r.short[https] am Interface erlaubt. Dadurch ist es möglich, den FortiAnalyzer über ein Menü zu administrieren, dass dem der FortiGate ähnelt.

Die Lizensierung basiert auf der in der Lizenz eingetragenen IP-Adresse. Im Portal `support.fortinet.com` wird die IP-Adresse hinterlegt und die Lizenz heruntergeladen. Im FortiAnalyzer-#htl3r.short[gui] wird die Lizenz dann hochgeladen. Es ist eine Internetverbindung notwendig, um die online hinterlegte IP-Adresse der Lizenz zu prüfen.

=== Logs sammeln <faz-cert-logs>

Damit der FortiAnalyzer Logs der Geräte sammeln kann, müssen diese mittels #emph("Fabric Connectors") verbunden werden. Die Konfiguration dafür erfolgt explizit auf jedem Gerät. Anschließend können die Geräte entsprechend den #htl3r.short[adom]s eingeteilt werden und für diese bestimmte Nutzer zu delegieren. Daraufhin kann beispielsweise die Auslastung oder der Speicherbedarf einzelner Komponenten zentral überwacht werden.

Die Konfiguration der Benutzer kann auch mit einem bestehenden #htl3r.short[ldap]-Service verknüpft werden. Dabei greift der FortiAnalyzer auf eine bestimmte Gruppe in der #htl3r.long[ad] Infrastruktur zu, um die User dieser Gruppe automatisch im FortiAnalyzer zu integrieren. Für das Abfragen der Daten von einem #htl3r.short[ldap]-Server sind entsprechende Zugangsdaten erforderlich.

=== Reports und Playbooks <faz-cert-reports>

Basierend auf den gesammelten Daten des FortiAnalyzers können Reports generiert werden. In den Reports

== Implementierung in die Topologie <faz-topo>
