#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("Albin Gashi")
= Einleitung

Die Topologie der Diplomarbeit 3BB wird grundsätzlich in einen physischen und virtuellen Bereich eingeteilt. Die Geräte der #htl3r.short[ot], die zur Steuerung der Eisenbahn verwendet werden, sind physisch auf der Modelleisenbahn angesiedelt. Dieses Netzwerk wird durch eine physische Firewall von Fortinet am Standort isoliert. Die Infrastruktur der #htl3r.short[it] wird virtuell auf einer Cisco #htl3r.short[ucs] realisiert. Dabei werden zwei Active Directory Standorte über ein #htl3r.short[sd-wan] mit dem physischen Standort des Zugnetzwerks verbunden.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/topologie/topo-all.png"),
    caption: [Die Topologie der Diplomarbeit 3BB]
  )
)
