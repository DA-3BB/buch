#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Marlene Reder")

== OT Topologie <piverkabelung>
Um die Operational Technology möglichst praxisnah darzustellen, wurde ein Modelleisenbahnnetz entwickelt. Dabei ist sowohl ein Gleisplan mit Elementen wie Wendeschleifen und Weichen geplant, als auch die Steuerung mit praxisrelevanten Komponenten und dem Protokoll "Modbus TCP" entwickelt worden.

#figure(
    image("../assets/topologie/ot-topologie/3BB_Gleisplan.jpg", width: 74%),
    caption: "Gleisplan mit Steuerelementen"
)


Um einer realitätsnahen Eisenbahnstrecke gerecht zu werden, ist die Eisenbahn in isolierte Blöcke eingeteilt. Dies verhindert, dass auf allen Gleisen Strom anliegt, somit entsteht einerseits kein Kurzschluss durch die Wendeschleifen und andererseits ist die Gefahr minimiert, dass zwei Züge aufeinander auffahren. Denn so wird ermöglicht, dass mindestens ein Block Abstand zwischen den Zügen vorhanden ist.


#figure(
    image("../assets/ot-topologie/gleisplan/3BB_Gleisplan_bloecke-mit-beschriftung.png", width: 74%),
    caption: "Gleisplan mit Blöcken"
)

Diese Blöcke, aber auch die Weichen, werden durch ein zentrales Steuergerät, genauer gesagt durch eine #htl3r.long[sps] (#htl3r.short[sps]), der 'Siemens LOGO!' gesteuert. Dieses sendet Modbus TCP/IP Frames zu sogenannten #htl3r.longpl[rtu] um Daten wie die aktuelle Weichenstellung abzufragen.
\ \
Um die Komponenten in der Nähe der Modelleisenbahnanlage zu plazieren, wurde ein #htl3r.short[ot]-Netzwerkschrank gebaut, der die Zentrale abbildet. In diesem befindet sich einerseits die Stromversorgung, die #htl3r.short[sps], ein #htl3r.short[ot]-Switch, andererseits auch ein Microcontroller, genauer gesagt ein Raspberry PI, der als #htl3r.short[rtu] für die Weichen dient.

#figure(
    image("../assets/topologie/ot-topologie/ot-steuerzentrale.jpg", width: 45%),
    caption: "OT Steuerzentrale"
)

#figure(
    image("../assets/topologie/ot-topologie/3BB_Netzplan_v2_1.png"),
    caption: "OT Netzplan - Physischer Aufbau der OT"
)

\
Dezentral ist bei jeder Weiche ein Servomotor angebracht, der wiederum an einem #htl3r.short[gpio]-Pin am Raspberry PI angeschlossen ist. Servomotoren wurden gewählt, um die Weiche möglichst genau anzusteuern, während der Raspberry PI die empfangengen Modbus-Steuerbefehle in #htl3r.long[pwm] für die Servomotoren ummwantelt.
\ \
Außerdem sind auf der Modelleisenbahnanlage drei Relaismodule angebracht, die die selbe Funktion wie der Raspberry PI für die Weichenblöcke haben. Die Module empfangen über eine Leitung Modbus-Steuerbefehle und aktivieren so die gewünschen Blöcke.
\ \
Weiters erfasst die Steuerung Reflex-Lichtschranken, um den Übergang der Eisenbahn von einem Block in den anderen zu erkennen. Auch diese Information werden von der #htl3r.short[sps] über die Relaismodule abgefragt.

=== Stromversorgung
Bei der Stromversorgung wurde darauf geachtet, dass keine 230V Geräte im Einsatz sind, um die Sicherheit beim Arbeiten und im späteren Verlauf, wenn Schüler*innen die Steuerung als Laborübung nutzen, zu gewährleisten.
\
Der Switch braucht dabei als einziges Gerät 24V, der Raspberry PI 5.5V und alle anderen Komponenten - #htl3r.short[sps], Relaismodule, Reflex-Lichtschranken - werden mit dem 12V Netzteil betrieben.

#figure(
    image("../assets/topologie/ot-topologie/komponenten/stromversorgung.jpg", width: 50%),
    caption: "Netzteile: 12V, 24V, 5.5V"
)

=== Speicherprogrammierbare Steuerung (SPS)
Das Herzstück der Steuerung ist die #htl3r.long[sps] beziehungsweise die Siemens LOGO!, da sie als Modbus Client die Steuerung vom Raspberry und den Relais Modulen übernimmt. Sie wird dabei mit der Software "LOGO! Soft Comfort" in der Version 8.4 programmiert. Um ein Schaltprogramm zu schreiben, wird ein externes Gerät mit der Software "LOGO!Soft Comfort" benötigt. Sobald das Programm auf die #htl3r.short[sps] gespielt wird, kann man es von dort über das kleinen Display starten und stoppen.
\ \
Zum Programmieren selbst wurde in diesem Projekt die Sprache "#htl3r.long[fub]". "#htl3r.short[fub]" ist eine grafische Programmiersprache, die mit logischen Funktionsblöcken arbeitet. Diese Blöcke sind einerseits logische Gatter wie 'AND' und 'XOR', aber auch verschiedene andere Bausteine wie Timer oder Counter. Der Vorteil von "#htl3r.short[fub]" ist, dass die Sprache einerseit leicht zu lernen ist und andererseits mit einem Verständnis von boolschen Operatoren einfach zu verstehen ist. Allerdings kann bei größeren Projekten die Übersicht leicht verloren gehen und Elemente wie Funktionen oder Bedingungen sind nicht vorhanden.

#htl3r.fspace(
    figure(
        image("../assets/topologie/ot-topologie/komponenten/siemens-logo.jpg", width: 50%),
        caption: "SPS - Siemens LOGO!")
)
#pagebreak()
==== LOGO!Soft Comfort V8.4
Die Oberfläche von 'LOGO!Soft Comfort' ist in zwei große Bereiche eingeteilt, den 'Diagram Mode' und das 'Network Project'. Im Diagram Mode gibt es das Fenster 'Instrutions' aus dem die Funktionsblöcke in den 'Diagram Editor' gezogen werden können. Im 'Diagram Editor' wird dabei die gesammte Steuerung abgebildet.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_uebersicht_diagram-mode.png", width: 85%),
    caption: "LOGO!Soft Comfort - Übersicht Diagram Mode"
)

Um die Steuerung zu testen - ohne dieses immer auf die #htl3r.short[sps] laden zu müssen - befindet sich im Diagram Editor auch die Option für den Simulationsmodus. Im Simulationsmodus können die unterschiedlichen Inputs an- und ausgeschalten werden, um verfolgen zu können, was dies in der Steuerung bewirkt. In der @simulationsmodus sieht man, dass der Input I1 im Simulationsmodus aktivert worden ist. Die Auswrikungen können dabei durch die nun rot eingefärbte Verbindung beobachtet werden.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_simulation-mode.png", width: 80%),
    caption: "Diagram Editor - Simulationsmodus"
) <simulationsmodus>\

Im 'Network Project' ist auch wieder der Diagram Editor abgebildet. Dieser wird hier benutzt, um die aktuelle Steuerung der #htl3r.short[sps] abzubilden beziehungsweise Änderungen vorzunehmen, die danach wieder auf die #htl3r.short[sps] gespielt werden.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_uebersicht_network-project.png", width: 80%),
    caption: "LOGO!Soft Comfort - Übersicht Network Project"
)\

Aber bevor der Diagram Editor im Network Project benutzt werden kann, muss man sich entweder zuerst mit der #htl3r.short[sps] verbinden oder ein Projekt mit einer #htl3r.short[sps] erstellen. Ein Projekt erstellen man indem man eine SPS mit "Add new Device" hinzufügt und die Einstellungen speichert.
Wenn man den anderen Weg wählt, weil man das akutelle Programm einer #htl3r.short[sps] abrufen will, kann man sich mit dem Tool 'LOGO! -> PC' zur #htl3r.short[sps] verbinden und das aktuelle Programm laden.
#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_sps-tools.png", width: 40%),
    caption: "Network Project - Toolleiste"
)\

Bevor das Programm allerdings angezeigt wird, wird man zu einem Konnektivitätstest weitergeleitet, bei dem die IP-Adresse der #htl3r.short[sps] anzugeben und das Interface vom PC auszuwählen ist. Der Test funktioniert, wenn der Balken grün aufleuchtet. Wenn dies nicht passiert, ist funktioniert etwas an der Netzwerkverbindung zwichen PC und #htl3r.short[sps] nicht.

#figure(
    image("../assets/ot-topologie/sps-test.png", width: 70%),
    caption: "Test der Konnektivität zwischen PC und SPS"
)\
#pagebreak()
Nach einer erfogreichen Konnektivität wird nicht nur im Diagram Editor das Programm angezeigt, es wird auch in der Network View die #htl3r.short[sps] abgebildet siehe @networkview. Auf dieser können nun Einstellungen wie die IP-Adresse der #htl3r.short[sps] getätigt aber auch das Busprotokoll Modbus aktiviert werden. Weiters ist zu erkennen, dass die #htl3r.short[sps] nicht nur eine Verbindung zum PC hat, sondern auch vier weitere Verbindungen. Diese zeigen auf, dass im Programm auf externe Inputs beziehungsweise Outputs verwiesen wird. Im Falle des Projekts ist das der Raspberry PI und die drei Relaismodule.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_network-view.png", width: 80%),
    caption: "Network View"
) <networkview>

Wenn man auf eine dieser vier Verbindungen klickt, werden weitere Details angezeigt. In diesem Fall wird preisgegeben, dass die Verbinung mit dem Gerät "10.100.0.11" besteht, welches ein Relaismodul ist. Weiters ist zu erkennen, dass zwei unterschiedliche Variablentypen vom Realismodul abgefragt werden - #htl3r.longpl[coil] und #htl3r.longpl[di]. Diese werden mit Adressen im Variablenspeicher verknüpft, um im Programm benutzt zu werden.

#figure(
    image("../assets/topologie/ot-topologie/Logo!soft-comfort_modbus-device.png",width: 85%),
    caption: "Verbindungen zu einem Modbus Device"
)

=== Raspberry PI
Der Raspberry übernimmt als Modbus Server die Weichensteuerung mittels Pythonskript. Wie in @piverkabelung erwähnt, hängen die Servomotoren an dem Raspberry PI, genauer gesagt an dem Servo Driver HAT "16 Kanal Servo Driver uHAT (I2C) für Raspberry Pi". Dieser dient zur erweiterung der #htl3r.short[pwm] Outputpins, da der Raspberry PI nur eine limitierte Anzahl hat. Dadurch, dass der Servo Driver HAT die Stromversorgung von dem Raspberry PI mitverwendet, zittern die Servos. Dieses Problem wurde gelöst indem am Servo Driver HAT ein Wiederstand abgezwickt wurde, um nun die Stromversorgung speperat zu legen. \


#figure(
    image("../assets/topologie/ot-topologie/komponenten/raspberry-pi_grafik.png", width: 40%),
    caption: "Raspberry PI 3B"
)

=== Relais Modul
Um die Blöcke der Eisenbahnstrecke anzusteuern, wurden drei Relaismodule mit Modbus Funktion verwendet. Dabei handelt es sich um das Modbus POE ETH Relay (B) des Unternehmens Waveshare. Es verfügt über 8 Relais Ausgänge, einem Ethernetport und 8 digitalen Eingängen. Die drei Module sollten dabei die dezentrale Steuerung darstellen, die nur noch mithilfe eines Ethernetkabels an den Hauptstandort, die Zentrale, angebunden ist.

#figure(
    image("../assets/ot-topologie/gleisplan/3BB_relais-modul.jpg", width: 70%),
    caption: "Waveshare Modbus POE ETH Relay (B) - Relais Modul"
)

Das besondere an dem Waveshare Relais ist, dass es über Modbus TCP Funktionen verfügt. Weiters könnnen die Inputs sowohl für passive als auch aktive Kontakte verwendet werden.
\ \
Um die Grundkonfiguration der Waveshare Relais vorzunehmen, kann die Software 'VirCom' eingesetzt werden. Diese findet mit einem Klick auf "Device" alle Waveshare Module, die im Netzwerk hängen, ohne die IP-Adresse oder sonstige Informationen zu haben. Sobald die IP-Adresse der Geräte bekannt ist, können alle anderen Einstellungen auch mit dieser mit der IP-Adresse des Relais Moduls über einen Webbrowser getätigt werden.
#figure(
    image("../assets/ot-topologie/vircom.png", width: 60%),
    caption: "Vircom Software"
)
\ \
Um die Relais bestmöglich nach Anwendungsfall einzusetzten, sollte zuerste der Richtige Control Mode eingestellt werden. Die Control Modes geben an wie die Eingänge und Ausgänge der Relaismodule geschalten werden sollen. Dabei ist zu beachten, dass beim linkage Modus die Relais nicht seperat angesprochen werden können.
- 0x0000 normaler Modus: Relais werden direkt mit Befehlen angesprochen.
- 0x0001 linkage Modus: Relaisstatus entspricht dem Status des jeweiligen Inputs.
- 0x0002 toggle Modus: Relaisstatus wird bei einem Impuls am jeweiligen Input umgeschalten.
- 0x0003 edge Modus: Relaistatus wird bei einem Flankenwechsel am jeweiligen Inputs umgeschalten.

=== Reflex-Lichtschranken
Um den Blockübertritt zu erkennen, werden Reflex-Lichtschranken an beiden Seiten der Isolierung eingesetzt, um die Richtung der Modelleisenbahn zu erkennen. Die Reflex-Lichtschranken hängen dabei am Input der Relaismodule und die #htl3r.short[sps] kann sie über diese abfragen. \
Genutzt wird dabei die "ZIMO SN1D Reflex-Lichtschranke", diese erfordern keine weitere Manipulation der Gleise oder des Zugs oder sonst irgendeine Konfiguration.

#htl3r.fspace(
  figure(image("../assets/topologie/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke.png"), caption: "Bauteile Reflex-Lichtschranke"),
  figure(image("../assets/topologie/ot-topologie/hersteller-zimo-stein-stationaer-einrichtungs-modul-zimo-sn1d-reflex-lichtschranke~4.png"), caption: "Installationsweise Reflexlichtschranke"),
)


=== Switch
In der #htl3r.short[ot]-Topologie wird zum Verbinden der Geräte ein Hirschmann RS20 Railswitch verwendet. Außerdem werden #htl3r.short[snmp] Daten an die IT Überwachung des Netzwerks weitergeben.
#figure(
    image("../assets/topologie/ot-topologie/komponenten/hirschmann-rs20.jpg", width: 60%),
    caption: "Hirschmann RS20 - Switch"
)

=== Firewall
Um die IT-Welt mit der #htl3r.short[ot]-Welt zu verknüpfen wird eine Firewall, genauer gesagt eine FortiGate 60E benutzt. Diese ist mit den FortiGates der Standorte Eisenstadt und Wien mittels #htl3r.short[ipsec] #htl3r.short[vpn] Verbindungen verknüpft.

#figure(
    image("../assets/topologie/ot-topologie/komponenten/fortigate-60e-grafik.png", width: 60%),
    caption: "FortiGate 60E - Firewall"
)
