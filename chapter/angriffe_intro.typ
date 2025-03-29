#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Esther Lina Mayer")

= Angriffe auf das OT-Netzwerk <angriffe-intro>

Im folgenden Kapitel werden die Angriffe, welche auf das OT-Netzwerk durchgeführt wurden, beschrieben. Diese Angriffe sind dazu gedacht, mögliche Schwachstellen im Netzwerk aufzudecken.

Die folgenden beiden Attacken können als Vorbereitung der Angriffe gesehen werden:
1. *Port-Scanning* - Es werden offene Ports und laufende Dienste auf der SPS identifiziert.
2. *Man-in-the-Middle* - Der Netzwerkverkehr der Kommunikation zwischen der SPS und den Steuergeräten wird abgefangen, aufgezeichnet und manipuliert.


Basierend auf den gewonnenen Informationen der vorbereitenden Angriffe werden nun die folgenden Attacken durchgeführt, um den Versuch zu starten, Schaden im Netzwerk anzurichten.
1. *Denial of Service* -  Die Durchführung eines DoS-Angriffs prüft die Reaktion der SPS auf Überlastungen.
2. *Fuzzing* - Durch Senden zufälliger Daten an die Eingabeschnittstelle der RTUs wird geprüft, ob es zu unerwünschtem Verhalten kommt.
3. *Replay* - Es wird legitimer Netzwerkverkehr aufgezeichnet und später erneut abgesendet.
4. *Code Injections* - Unerwünschter Code wird in die Modbuskommunikation injiziert, um die Steuerung zu manipulieren.

Die genannten Angriffe können bei der kritischen Infrastruktur des Netzwekes dramatische Auswirkungen haben, die bis hin zu einem totalen Systemausfall führen können. Sie sollen verdeutlichen, wie wichtig es ist, die richtigen Sicherheitsmaßnahmen zu treffen.
