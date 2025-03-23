#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("Albin Gashi")
= Einleitung

Die Topologie der Diplomarbeit 3BB wird grundsätzlich in einen physischen und virtuellen Bereich eingeteilt. Die Geräte der #htl3r.short[ot], die zur Steuerung der Eisenbahn verwendet werden, sind physisch auf der Modelleisenbahn angesiedelt. Dazu gehört eine #htl3r.short[sps], ein Raspberry Pi, und #htl3r.shortpl[rtu]. Der Stromfluss der Schienen, Lichtsignale und die Servomotoren zum Ansteuern der Weichen bilden dabei die Aktoren. Dabei nimmt die #htl3r.short[sps] die Steuerbefehle entgegen und leitet sie zu den #htl3r.longpl[rtu] weiter. Das Eisenbahnnetzwerk wird durch eine physische Firewall von Fortinet am Standort isoliert. Dies soll mögliche Angriffsvektoren auf das Netzwerk begrenzen.

Um die Modelleisenbahn auf ihre Integrität zu überprüfen wurden Angriffe auf das Netz durchgeführt. Diese reichen von Deinal of Service, Fuzzing und Code-Injection bis zu Replay-Attacken und Port-Scans. Dadurch sollen Schwachstellen in #htl3r.short[ot]-Netzwerken sichtbar werden.

Die #htl3r.short[it]-Standorte simulieren ein Unternehmensnetzwerk, dass mittels #htl3r.short[ad] realisiert wird. Mitarbeiter sollen durch ein Human Machine Interface Zugriff auf die Steuerelemente der #htl3r.short[sps] besitzen. Dieser Zugriff ist über die anderen beiden Firewalls abgesichert. Des Weiteren sind diverse Security-Geräte von Fortinet im Einsatz. Ein #htl3r.short[siem] übernimmt die Netzwerküberwachung im gesamten Unternehmen und soll mithilfe von Dashboards einen guten Überblick über den Zustand des Netzwerks bieten. Durch ein #htl3r.short[soc] und dessen im #htl3r.long[ad] hinterlegten Benutzer soll ein Cyberdefense-Umfeld innerhalb des Unternehmens realisiert werden.

Die Infrastruktur der #htl3r.short[it] wird virtuell auf einer Cisco #htl3r.short[ucs] realisiert. Die beiden #htl3r.long[ad] Standorte werden dabei über ein #htl3r.short[sd-wan] mit dem physischen Standort des Zugnetzwerks verbunden.

#pagebreak()

#htl3r.fspace(
  total-width: 60%,
  figure(
    image("../assets/topologie/topo-all.png"),
    caption: [Die Topologie der Diplomarbeit 3BB]
  )
)
