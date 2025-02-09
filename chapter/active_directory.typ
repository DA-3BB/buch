#import "@preview/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")
#import "@preview/treet:0.1.1": *

= #htl3r.long[ad] Infrastruktur <ad-infra>

Für die Implementierung der #htl3r.short[it]-Infrastruktur wurde eine #htl3r.long[ad] Domäne umgesetzt. Diese besteht aus zwei Standorten namens #emph("Wien") und #emph("Eisenstadt"). Beide Standorte werden durch zwei unterschiedliche Child-Domains betrieben (wien.3bb-testlab.at und eisenstadt.3bb-testlab.at). Der Standort Wien simuliert die Zentrale eines Unternehmens, auf dieser auch diverse Security-Geräte angesiedelt sind, die in @fsm und @faz näher erläutert werden. Zwei Domain-Controller bilden den Standort Wien mit einem Jump-Server ab. Der Standort Eisenstadt besitzt nur einen Domain-Controller und erhält ein RDS-Gateway. Die beiden Standorte sind durch einen Site-Link zur notwendigen #htl3r.short[ldap]-Replikation verbunden.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/active-directory/ad-topology.png"),
    caption: [logische Topologie der #htl3r.short[ad]-Infrastruktur]
  )
)
