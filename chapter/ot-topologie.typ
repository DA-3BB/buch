#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Marlene Reder")

== Operational Technology Topologie
Um die Operational Technology möglichst Praxisnah darzustellen wurde ein Modelleisenbahnnetz entwickelt. Dabei ist sowohl ein Gleisplan mit Elementen wie Wendeschleifen und Weichen geplant, als auch die Steuerung mit praxisrelevanten Komponenten und dem Protokoll Modbus entwickelt worden. 

#figure(
    image("../assets/topologie/ot-topologie/3BB_Gleisplan.jpg", width: 74%),
    caption: "Gleisplan mit Steuerelementen"
)


Um einer normalen Eisenbahnstrecke recht zu werden ist die Eisenbahn in isolierte Blöcke eingeteilt. Dies verhindernt, dass die ganze Anlage unter Strom steht, damit einerseits kein Kurzschluss durch die Wendeschleifen entsteht und um die Gefahr zu minimieren, dass zwei Züge ineinander krachen. Denn so wird geschaut, dass mindestens ein Block zwischen den Eisenbahnwagons abstand sind. Näheres zum Ansteuern dieser Blöcke ist im Kapitel x.x Blocksteuerung zu finden.

#figure(
    image("../assets/topologie/ot-topologie/3BB_Gleisbloecke.png", width: 75%),
    caption: "Gleisplan in Blöcke unterteilt" 
)


Diese Blöcke, aber auch die Weichen werden durch ein zentrales Steuergerät, genauer gesagt einer #htl3r.long[sps], der 'Siemens LOGO!' gesteuert. Dieses sendet Modbus TCP/IP Frames zu sogenannten #htl3r.long[rtu] um Daten wie die aktuelle Weichenstellung einzuholen.\ \
Dies wurde realisiert, indem es einen OT-Netzwerkschrank gibt der die Zentrale abbildet. In diesem befindet sich einerseits die Stromversorgung, die #htl3r.short[sps], ein OT-Switch, andererseits auch ein Microcontroller, genauer gesagt ein Raspberry PI, der als #htl3r.short[rtu] für die Weichen dient. 

#figure(
    image("../assets/topologie/ot-topologie/ot-steuerzentrale.jpg", width: 45%),
    caption: "OT Netzplan - Physischer Aufbau der OT"
)
\
Dezentral ist bei jeder Weiche ein Servomotor angebracht, der wiederum an einem #htl3r.short[gpio]-Pin am Raspberry PI angeschlossen ist. Servomotoren wurden gewähl, um die Weiche möglichst genau anzusteuern und der Raspberry PI, damit dieser die empfangengen Modbus-Steuerbefehle in #htl3r.long[pwm] ummwantelt.
\ \
Außerdem sind auf der Modell Eisenbahnanlage drei Relais Module angebracht, die die selbe Funktion wie der Raspberry PI für die Weichenblöcke haben. Die Module empfangen über eine Leitung Modbus-Steuerbefehle und aktivieren so die gewünschen Blöcke. \
Weiters erfasst die Steuerung Reflex-Lichtschranken, um den Übergang der Eisenbahn von einem Block in den anderen zu erkennen. Auch diese Information holt sich die #htl3r.short[sps] über die Relais Module.

#figure(
    image("../assets/topologie/ot-topologie/3BB_Netzplan_v1_0.png"),
    caption: "OT Netzplan - Physischer Aufbau der OT"
)

=== Stromversorgung
Bei der Stromversorgung wurde darauf geachtet, dass nirgendwo 230V Geräte im Einsatz sind, um die Sicherheit beim Arbeiten und im späteren Verlauf zu gewährleisten, wenn Schüler die Steuerung als Laborübung nutzen.\
Der Switch braucht dabei als einziges Gerät 24V, der Raspberry PI 5.5V und alle anderen Komponenten - #htl3r.short[sps], Relais Module, Reflexlicht Lichtschranken - werden mit dem 12V Netzteilbetrieben.

#figure(
    image("../assets/topologie/ot-topologie/komponenten/stromversorgung.jpg", width: 50%),
    caption: "Netzteile: 12V, 24V, 5.5V"
)

=== #htl3r.long[sps] (SPS)
Wie schon erwähnt ist das Herzstück der Steuerung die #htl3r.long[sps] beziehungsweise die Siemens LOGO! da sie als Modbus Client - genaueres dazu im Kapitel X.X Modbus - die Steuerung vom Raspberry und dem Relais Modulen übernimmt. Sie wird dabei mit der Software "LOGO! Soft Comfort" in der Version 8.4 programmiert. Um so ein Schaltprogramm zu schreiben wird allerdings ein externe Gerät mit der Software benötigt. Sobalt es auf die #htl3r.short[sps] gespielt wird, kann man es dann aber von dort, über den kleinen Display, starten und stoppen.
\ \
Zum programmieren selbst habeen wir als Sprache den #htl3r.long[fub] (FUP) verwendet, weiters können die Schaltpläne aber auch mit dem Kontaktplan (KOP) erstellt werden. \
#htl3r.short[fub] ist eine grafische Programmiersprache, die mithilfe von logischen Funktionsblöcken funktioniert. Diese Blöcke sind einerseits logische Gatter wie 'AND', 'XOR', aber verschiedene andere Bausteine wie Timern oder Counter. Der Vorteil von #htl3r.short[fub], ist, dass sie Sprache einerseit leicht zu lernen ist und noch am einfachsten für das ungeschulte Auge zu verstehen ist. Allerdings kann bei größeren Projekten die Übersicht leicht verloren werden und, Elemente wie Funktionen oder Bedinugen sind nicht vorhanden.

#htl3r.fspace(
    figure(
        image("../assets/topologie/ot-topologie/komponenten/siemens-logo.jpg.", width: 80%),
        caption: "SPS - Siemens LOGO!"),
    figure(
        image("../assets/topologie/ot-topologie/logo-soft-comfort_programmauschnitt.png", width: 85%),
        caption: "Auschnitt eines Programms geschrieben mit Funktionsplan")
)

==== LOGO!Soft Comfort V8.4
Die Oberfläche von 'LOGO!Soft Comfort' ist in zwei große Bereiche eingeteilt, den 'Diagram Mode' und das 'Network Project'. Im Diagram Mode gibt es das Fenster 'Instrutions' aus dem die Funktionsblöcke in die Steuerung gezogen werden können. In die Steuerung heißt dabei in das größte Fenster, den 'Diagram Editor', in welchem die gesammte Steuerung abgebildet ist.
#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_uebersicht_diagram-mode.png", width: 80%),
    caption: "LOGO!Soft Comfort - Übersicht Diagram Mode"
)

Um die Steuerung zu testen ohne dieses immer auf die #htl3r.short[sps] laden zu müssen, befindet sich hier auch der Knopf für den Simulationsmodus. In diesem können die unterschiedliche Inputs an- und ausgeschalten werden um verfolgen zu können, was dies in der Steuerung bewirkt.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_simulation-mode.png", width: 80%),
    caption: "Diagram Editor - Simulationsmodus"
)\

Im 'Network Project' ist auch wieder der Diagram Editor abgebildet, dieser wird hier benutzt um die aktuelle Steuerung der #htl3r.short[sps] abzubilden beziehungsweise, Änderungen vorzunehem die danach wieder auf die #htl3r.short[sps] gespielt werden.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_uebersicht_network-project.png", width: 80%),
    caption: "LOGO!Soft Comfort - Übersicht Network Project"
)\

Aber bevor der Diagram Editor hier benutzt werden kann, muss sich zuerst mit der #htl3r.short[sps] verbunden werden. Dies funktioniert indem man das Tool 'LOGO! -> PC' auswählt.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_sps-tools.png", width: 50%),
    caption: "Network Project - Toolleiste"
)\

Dabei wird man weitergeleitet zum Konnektivitätstest, bei dem die 'richtige' #htl3r.short[sps] auszuwählen ist und das Interface vom PC auszuwählen ist. Der Test funktioniert wenn der Balken grün aufleuchtet, wenn dies nicht passiert, sollte geschaut werden, ob die IP-Adressen stimmen und der PC und die #htl3r.short[sps] im selben Netzwerk hängen.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_test-connection.png", width: 70%),
    caption: "Test der Konnektivität zwischen PC und SPS"
)\

Nach einer Erfogreichen Konnektivität wird nicht nur in dem Diagram Editor das Programm angezeigt, es wird auch in der Network View die #htl3r.short[sps] abgebildet. Auf dieser können nun Einstellungen wie die IP-Adresse oder aber auch das Busprotokoll Modbus aktiviert werden. Weiters ist zu erkennen, dass die #htl3r.short[sps] vier weitere Verbindungen hat zusätzlich zu der zum lokalen PC hat. Diese weisen darauf hin, dass wir in unserem Programm auf externe Inputs beziehungsweise Outputs verweisen. In unserem Fall ist das der Raspberry PI und die drei Waveshare Module. 

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_network-view.png", width: 70%),
    caption: "Network view"
)\

=== Raspberry PI
Wie oben erwähnt hängen die Servomotoren an dem Raspberry PI, welcher als Modbus Server die Weichensteuerung übernimmt. Nachdem der Raspberry PI nur eine limitierte anzahl an #htl3r.short[pwm] Outputpins hat und die Servos jittern würden haben wir uns für den "16 Kanal Servo Driver uHAT (I2C) für Raspberry Pi" entschieden. Dieser löst beide Probleme, wendoch gegen das jittern ein Widerstand am Servo Driver HAT abgezwickt werden musste, damit die Stromversorgung extern und nicht am Raspbery PI hängt. \
Zum Modbus Server wurde der Raspberry PI mithilfe eines Python Programms und der Libary "pyModbusTCP", genaueres dazu im Kapitel X.X.X. 

#figure(
    image("../assets/topologie/ot-topologie/komponenten/raspberry-pi_grafik.png", width: 50%),
    caption: "Raspberry PI 3B"
)



=== Relais Modul
Um die Blöcke der Eisenbahnstrecke anzusteuern wurde drei Relais Modul mit Modbus Funktion verwendet. Dabei handelt es sich um das Modbus POE ETH Relay (B) des Unternehmens Waveshare. Es verfügt über 8 Relais Ausgänge, einem RS485 Interface und 8 digitalen Eingängen. Die drei Module sollten dabei die dezentrale Steuerung darstellen, die nur noch mithilfe eines Ethernetkabels an den Hauptstandort, die Zentrale angebunden ist.

#figure(
    image("../assets/topologie/ot-topologie/komponenten/waveshare.jpg", width: 50%),
    caption: "Waveshare Modbus POE ETH Relay (B) - Relais Modul"
)

Das besondere an dem Waveshare Relais ist, dabei wie der Name schon sagt, dass es über Power over Ethernet und Modbus funktionen verfügt. Weiters könnne die Inputs sowohl für passive als auch active Kontakte verwendet werden. Der Unterschied ist dabei wo die Masse hängt.
\ \
Um die Grundkonfiguration der Waveshare Relais vorzunehmen. Kann die Softwave 'VirCom' eingesetzt werden. Diese findet alle Waveshare Module, die im Netzwerk hängen ohne die IP-Adresse oder sonstiges über das Gerät zu wissen. Sobald die IP-Adresse der Geräte bekannt ist, können alle anderen Einstellungen auch mit dieser über einem Webbrowser getätigt werden.
\ \
Um die Relais bestmöglich nach Anwendungsfall einzusetzten sollten sich zuerste die Control Modes angeschaut werden. Dabei ist zu beachten, dass beim linkage Modus die Relais nicht speerat angesprochen werden können.
- 0x0000 normaler Modus: Relais werden direkt mit Befehlen angesprochen
- 0x0001 linkage Modus: Relais status ist mit den Inputs verknüft
- _0x0002 toggle Modus: a pulse in the input channel toggles the relay state once_
- _0x0003 edge Modus: an edge change in the input channel toggles the relay state once_

=== Reflex Lichtschranken
Um den Blockübertritt zu erkennen werden Reflex-Lichtschranken , an beiden Seiten der Isolierung eingesetzt, um die Richtung der Modelleisenbahn zu erkennen. Die Reflex-Lichtschranken hängen dabei am Input der Relais Module und die #htl3r.short[sps] kann sie über diese abfragen. \
Genutzt werden dabei die "ZIMO SN1D Reflex-Lichtschranke", diese erfordern keine weitere Manipulation der Gleise oder des Zugs.

#htl3r.fspace(
  figure(image("../assets/topologie/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke.png"), caption: "Bauteile Reflex-Lichtschranke"),
  figure(image("../assets/topologie/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke~4.png"), caption: "Installationsweise Reflexlichtschranke"),
)


=== Switch
In der #htl3r.short[ot]-Topologie wird zum Verbinden der Geräte ein Hirschmann RS20 Railswitch verwendet. Außerdem werden #htl3r.short[snmp] Daten an die IT Überwachung des Netzwerks weitergeben. Genaueres dazu im Kapitel x.x.x
#figure(
    image("../assets/topologie/ot-topologie/komponenten/hirschmann-rs20.jpg", width: 60%),
    caption: "Hirschmann RS20 - Switch"
)

=== Firewall
Um die IT-Welt mit der #htl3r.short[ot]-Welt zu verknüpfen wird eine Firewall, genauer gesagt eine FortiGate 60E benutzt. Diese ist mit den FortiGates der Standorte Eisenstadt und Wien mittels #htl3r.short[sd-wan]. Genauers dazu im Kaptiel X.X.

#figure(
    image("../assets/topologie/ot-topologie/komponenten/fortigate-60e-grafik.png", width: 60%),
    caption: "FortiGate 60E - Firewall"
)
