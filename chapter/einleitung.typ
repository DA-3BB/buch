#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("Albin Gashi")
= Einleitung

Durch die Verbreitung digitaler Technologien transformiert sich auch die Industrie in ihrer grundlegenden Form @industrial-transform. Laufbänder und Roboter werden nicht mehr über das interne Netzwerk, sondern von außen über das Internet gesteuert und analysiert. Dies eröffnet ein immenses Angriffskontingent, dass überwunden werden muss.

Zur akuten Bedrohungslage gehören Malware, Würmer, #htl3r.full[dos] Angriffe und technisches sowie menschliches Fehlverhalten @ics-sec. Im Gegensatz zu herkömmlichen #htl3r.short[it]-Netzwerken bedeutet ein Ausfall Kosten in Millionenhöhe, falls Produktionsstätten sabotiert oder Vermögenswerte von Unternehmen zerstört werden. Im Bereich der kritischen Infrastruktur sind auch Menschenleben in Gefahr @cyberattack-deaths.

In diesem Sinne wurden auch in der Legislative neue Richtlinien und Verordnungen verabschiedet, um die Cyberresilienz zu stärken. Im Fokus liegt hierbei die #htl3r.long[nis-2]-Richtlinie, die vom Europäischen Parlament im Dezember 2022 beschlossen wurde und die alte NIS-Regelung außer Kraft gesetzt hat @nis2.

Die Sicherheit in Industrienetzwerken ist somit aktueller denn je und bedarf eine vielseitige Einsetzung diverser Sicherheitskomponenten, um auch vor aktuellsten Bedrohungen geschützt zu sein. Im Rahmen dieser Diplomarbeit wurden Netzwerke realitätsnah modelliert, Angriffsvektoren ausgeforscht und Komponenten zur Härtung des Netzwerks implementiert.

Im folgenden wird die Topologie des #htl3r.short[it]/#htl3r.short[ot]-Netzwerks abgebildet. Auf der linken Seite befindet sich das OT-Netzwerk rundum die Modelleisenbahn und auf der rechten Seite die beiden IT-Standorte des simulierten Unternehmens. Diese werden über das Internet miteinander verbunden.
/*
Im Falle der Diplomarbeit 3BB wird ein Industrienetzwerk auf Basis einer Modelleisenbahn mit einem #htl3r.short[it]-Netzwerk eines Unternehmens verbunden. Dabei wird das #htl3r.short[ot]-Netzwerk durch eine Modelleisenbahn realisiert und durch eine #htl3r.full[sps] verwaltet. Die Steuerbefehle der #htl3r.short[sps] werden dabei an die #htl3r.fullpl[rtu] weitergegeben. Diese steuern zuletzt die Aktoren des OT-Netzwerks. Die Komponenten steuern die Aktoren (wie z. B. Weichen und Züge), um den Bahnverkehr zu gewährleisten. Dabei wurde eine für die Diplomarbeit individuelle Weichen- und Blocksteuerung entwickelt und implementiert.
*/

#pagebreak()

//== Netzplan

#htl3r.fspace(
  total-width: 65%,
  figure(
    image("../assets/topologie/topo-all.png"),
    caption: [Die Topologie der Diplomarbeit 3BB]
  )
)

#pagebreak()

Die Topologie der Diplomarbeit 3BB wird grundsätzlich in einen physischen und virtuellen Bereich eingeteilt. Die Geräte der #htl3r.short[ot], die zur Steuerung der Eisenbahn verwendet werden, sind physisch auf der Modelleisenbahn stationiert: dazu gehört eine #htl3r.full[sps], ein Mikrocontroller und #htl3r.fullpl[rtu]. Der Stromfluss der Schienen und die Servomotoren zum Ansteuern der Weichen bilden die Aktoren ab. Dabei nimmt die #htl3r.short[sps] die Steuerbefehle entgegen und leitet sie zu den #htl3r.longpl[rtu] weiter. Mehr dazu in @blocksteuerung und @chapter-weichensteuerung. Das Eisenbahnnetzwerk wird durch eine physische Firewall von Fortinet am Standort isoliert. Dies soll mögliche Angriffsvektoren auf das Netzwerk begrenzen.

Um die Steuerung auf ihre Integrität hin zu überprüfen, wurden Angriffe auf das Netz durchgeführt. Diese reichen von Denial of Service, Fuzzing und Code-Injection bis zu Replay-Attacken und Port-Scans. Dadurch sollen Schwachstellen in #htl3r.short[ot]-Netzwerken sichtbar werden. Mehr dazu in @angriffe-intro.

Die #htl3r.short[it]-Standorte simulieren ein Unternehmensnetzwerk, das mittels #htl3r.full[ad] realisiert wird. Mitarbeiterinnen und Mitarbeiter sollen durch eine grafische Oberfläche Zugriff auf die Steuerelemente der #htl3r.short[sps] haben. Dieser Zugriff ist über die anderen beiden Firewalls abgesichert. Des Weiteren sind diverse Security-Geräte von Fortinet im Einsatz: Ein #htl3r.full[siem] übernimmt die Netzwerküberwachung im gesamten Unternehmen und soll mithilfe von Dashboards einen guten Überblick über den Zustand des Netzwerks bieten. Diese Komponente wird in @fsm erläutert. Durch ein #htl3r.full[soc] und dessen im #htl3r.long[ad] hinterlegten Benutzer soll ein Cyberdefense-Umfeld innerhalb des Unternehmens realisiert werden. Mehr dazu in @faz.

Die Infrastruktur der #htl3r.short[it] wird virtuell auf einer Cisco #htl3r.full[ucs] realisiert. Die beiden #htl3r.long[ad] Standorte werden dabei über verschlüsselte #htl3r.full[vpn] Verbindungen mit dem physischen Standort des Zugnetzwerks verbunden.
