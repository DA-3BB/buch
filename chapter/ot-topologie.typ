#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Marlene Reder")

== Operational Technology Topologie

#htl3r.todo("Grafiken werden noch aktualisiert und vervollständigt (teilweise durch Bilder aus unserer Schaltung)")

=== Überblick
Um die Operational Technology möglichst Praxisnah darzustellen wurde ein Modelleisenbahnnetz entwickelt. Dabei ist sowohl ein Gleisplan mit Elementen wie Wendeschleifen und Weichen geplant, als auch die Steuerung mit praxisrelevanten Komponenten und dem Protokoll Modbus entwickelt worden. 

#figure(
    image("../assets/ot-topologie/3BB_Gleisplan.png", width: 80%),
    caption: "Gleisplan"
)


Um einer normalen Eisenbahnstrecke recht zu werden ist die Eisenbahn in isolierte Blöcke, damit nicht die ganze Anlage unter Strom steht und kein Kurzschluss mit wegen der Wendeschleife entsteht. Die Näheres zum Ansteuern dieser Blöcke ist im Kapitel x.x Blocksteuerung zu finden.
#htl3r.todo("Kapitelnummer hinzufügen")

#figure(
    image("../assets/ot-topologie/3BB_Gleisbloecke.png", width: 90%),
    caption: "Gleisplan in Blöcke unterteilt" 
)


Um sowohl die einzelnen Blöcke als auch die Weichen anzusteuern wurde sich die folgende Topologie überlegt. Diese hat um die Weichen zu steuern jeweils einen Servomotor, der wiederum an einem #htl3r.short[gpio]-Pin am Raspberry PI hängt. Der Raspberry PI wandelt dabei Eingangsignale in Pulsweite Modulation um die Servomotoren möglichst präzise zu Steuern.\ 
Für die Blöcke wird als gleichwertiges Gerät ein Relay Modul verwendet. Beide Geräte sind mithilfe eines des Hirschmann RS20 Switches mit dem Herzstück der Schlatung dem Logikmodul der Siemens LOGO!  zu verwunden und verwenden das Modbus TCP/IP Protokoll Befehle von der Logo zu erhalten. \
Weiters erfasst die Steuerung Reflex-Lichtschranken, um den Übergang der Eisenbahn von einem Block in den anderen zu erkennen.

#figure(
    image("../assets/ot-topologie/3BB_Netzplan_v1_0.png"),
    caption: "OT Netzplan - Physischer Aufbau der OT"
)

#htl3r.todo("Bilder der 'echten' Verkabelung")

==== Stromversorgung
Bei der Stromversorgung wurde darauf geachtet, dass nirgendwo 230V Geräte im Einsatz sind,um die Sicherheit beim Arbeiten und im späteren Verlauf zu gewährleisten, wenn Schüler die Steuerung als Laborübung nutzen.\
Der Switch braucht dabei als einziges Gerät 24V, der Raspberry PI 5V und alle anderen Komponenten - LOGO!, Relay Modul, Reflexlicht Lichtschranke - werden mit dem 12V Netzteilbetrieben.

=== Logikmodul - Siemens LOGO!
Wie schon erwähnt ist das Herzstück der Steuerung die Siemens LOGO! da sie als Modbus Client die Steuerung von dem Raspberry und dem Relay Modul übernimmt. Sie wird dabei mit der Software "LOGO! Soft Comfort" programmiert. In unserem Fall haben wir als Sprache den Funktionsplan (FUP) verwendet, weiters können die Schlatprogramme aber auch mit dem Kontaktplan (KOP) erstellt werden. 

#htl3r.short[fub] ist eine grafische Programmiersprache, die logische Funktionsblöcken funktioniert und so einfach noch am einfachsten für das ungeschulte Auge ist.

#htl3r.fspace(
    figure(
        image("../assets/ot-topologie/komponenten/siemens-logo.png"),
        caption: "Siemens LOGO! - Logikmodul"),
    figure(
        image("../assets/ot-topologie/logo-soft-comfort_programmauschnitt.png"),
        caption: "Auschnitt eines Programms geschrieben mit Funktionsplan")
)


=== Raspberry PI
Wie oben erwähnt hängen die Servomotoren an dem Raspberry PI, welcher als Modbus Server die Weichensteuerung übernimmt. Nachdem der Raspberry PI nur eine limitierte anzahl an #htl3r.short[pwm] Outputpins hat und die Servos jittern würden haben wir uns für den "16 Kanal Servo Driver uHAT (I2C) für Raspberry Pi" entschieden. Dieser löst beide Probleme, wendoch gegen das jittern ein Widerstand am Servo Driver HAT abgezwickt werden musste, damit die Stromversorgung extern und nicht am Raspbery PI hängt. \
Zum Modbus Server wurde der Raspberry PI mithilfe eines Python Programms und der Libary "pyModbusTCP", genaueres dazu im Kapitel X.X.X. 
#figure(
    image("../assets/ot-topologie/komponenten/raspberry-pi.png", width: 50%),
    caption: "Raspberry PI 3B"
)

=== Relay Modul
Um die Blöcke der Eisenbahnstrecke anzusteuern wurde drei Relay Modul mit Modbus Funktion verwendet. Dabei handelt es sich um das Modbus POE ETH Relay (D) der des Unternehmens Waveshare. Es verfügt über 8 Relais Ausgänge, einem RS485 Interface und 8 digitalen Eingängen. Die drei Module sollten dabei die dezentrale Steuerung darstellen, die nur noch mithilfe eines Ethernetkabels an den "Hauptstandort" angebunden ist.

#figure(
    image("../assets/ot-topologie/komponenten/waveshare.jpg"),
    caption: "Waveshare Modbus POE ETH Relay (D) - Relay Modul"
)

=== Reflex Lichtschranken
Die Erkennung des Blockübertritts geschieht mithilfe von Reflex-Lichtschranken, an beiden Seiten der Isolierung um die Richtung der Modelleisenbahn zu erkennen. Die Reflex-Lichtschranken hängen dabei am Input der Relay Module und über diese werden die Signale an die Siemens LOGO! weitergeleitet. \
Genutzt werden dabei die "ZIMO SN1D Reflex-Lichtschranke", diese erfordern keine weitere Manipulation der Gleise oder des Zugs.

#htl3r.fspace(
  figure(image("../assets/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke.png"), caption: "Bauteile Reflex-Lichtschranke"),
  figure(image("../assets/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke~4.png"), caption: "Installationsweise Reflexlichtschranke"),
)


=== Switch
In der #htl3r.short[ot]-Topologie wird zum Verbinden der Geräte ein Hirschmann RS20 Railswitch verwendet. Außerdem werden #htl3r.short[snmp] Daten an die IT Überwachung des Netzwerks weitergeben. Genaueres dazu im Kapitel x.x.x
#figure(
    image("../assets/ot-topologie/komponenten/hirschmann-rs20.jpg", width: 50%),
    caption: "Hirschmann RS20 - Switch"
)

=== Firewall / Router????
--> Work in Progress