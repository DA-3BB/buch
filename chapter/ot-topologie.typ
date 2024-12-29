#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Marlene Reder")

== OT Topologie
=== Überblick
Mithilfe der OT soll ein Bahnnetz mithilfe einer Modelleisenbahn verwirklicht werden. Dabei wurde Beachtet, 
Wendeschleife,
Weiche,
Welche Hersteller haben gleise? Ist das wichtig?

#htl3r.todo("Grafiken werden noch aktualisiert und vervollständigt (teilweise durch Bilder aus unserer Schaltung)")

#figure(
    image("../assets/ot-topologie/3BB_Gleisplan.png", width: 60%),
    caption: "Gleisplan"
)


Um einer Normalen eisenbahn recht zu werden ist die Eisenbahn in blöcke. Näheres dazu im kapitel x.x Blocksteuerung.

#figure(
    image("../assets/ot-topologie/3BB_Gleisbloecke.png", width: 70%),
    caption: "Gleisplan in Blöcke Unterteilt" 
)


Um jetzt sowohl die weichen als auch die einzählnen blöcke ansteuerun zu können wurde sich folgene Topologie überlegt, 
Diese hat um die Weichen zu Steuerun jeweils einen Servomotor. Und 

#figure(
    image("../assets/ot-topologie/3BB_Netzplan_v1_0.png"),
    caption: "OT Netzplan - Physischer Aufbau der OT"
)

==== Stromversorung???
Dabei wurde beim Strom drauf geachtet, dass niergwo 230V geräte im einsatz sind um die sicherheit beim arbeiten und wenn schüler später daran "forschen" die sicherheit auch gewährt ist, das meise hat 24V und das ist der Switch, der ist allerdings im schrank und kommt nicht raus meiste strom raus 12 V

=== SPS
Wie schon erwähnt ist das Herzstück die Siemens logo die als Modbus master diehnt und mithilfe dessen unsere geräte gesteuert werden

=== Raspberry PI
=== Reflex Lichtschranken

ZIMO SN1D Reflex-Lichtschranke

#htl3r.fspace(
  figure(image("../assets/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke.png"), caption: "Bauteile Reflex-Lichtschranke"),
  figure(image("../assets/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke~4.png"), caption: "Installationsweise Reflexlichtschranke"),
)

=== Relay Module
3 insgesammt und war 
Industrial Modbus RTU 8-ch Relay Module (D) With Digital Input and RS485 Interface, Multi Isolation Protection Circuits, 7\~36V Power Supply


=== Switch
=== Firewall / Router????
--> Work in Progress