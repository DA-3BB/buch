#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Marlene Reder")

= Blocksteuerung <blocksteuerung>
Die Steuerung der Modelleisenbahn besteht aus zwei Teilen - der Weichensteuerung und der Blocksteuerung. In diesem Kapitel wird die Blocksteuerung genauer betrachtet.

== Blockschaltbild

Bevor die Steuerung selbst erklärt werden kann, ist wichtig zu wissen, dass die Gleise in mehrere Blöcke unterteilt sind, welche seperat angesteuert werden können. Dabei fährt der Zug sobald auf dem jeweiligen Gleisabschnitt Strom anliegt. Um die Blöcke eindeutig zu kennzeichnen, sind sie beschriftet mit B1-B7.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Gleisplan_bloecke-mit-beschriftung.png", width: 90%),
    caption: "Gleisplan mit Blöcken"
  )
)

Bei der Grenze zwischen zwei Gleisabschnitten sind Reflex-Lichtschranken eingebaut, mithilfe derer erkannt werden kann, dass ein Zug in einen Block einfährt beziehungsweise einen Gleisabschnitt verlässt.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Netzplanabschnit.png"),
    caption: "Aufbau Blockübergang"
  )
)

Auch die Reflex-Lichtschranken sind beschriftet mit BX.Y, um einen Überblick zu behalten. Dabei steht X für den Block in dem sich die Lichtschranke befindet und Y ist die Nummerierung der Reflex-Lichtschranken in einem Block.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Gleisplan_blocke-reflex.jpg"),
    caption: "Gleisplan mit Blöcken und Reflex-Lichtschrankenbeschriftung"
  )
)

== Zuordnung der Steuerelemente zum SPS Programm <mapping>
Für die Blocksteuerung werden folgende Komponenten benötigt:


#htl3r.fspace(
  figure(
    table(
        columns: (1fr, 0.5fr,0.5fr),
        table.header(
            [*Gerät*], [*Adresse*], [*Funktion*],
        ),
        [Siemens LOGO! SPS],[10.100.0.1],[Modbus-Client],
        [RTU - Relaismodule],[10.100.0.11],[Modbus-Server],
        [RTU - Relaismodule],[10.100.0.12],[Modbus-Server],
        [RTU - Relaismodule],[10.100.0.13],[Modbus-Server],
    ),
    caption: [Komponenten aus Betrachtungssicht der Blocksteuerung]
  )
)
Die Relaismodule dienen als dezentrale Steuerelemente. Sie zeichnen den Input der Reflex-Lichtschranken auf und steuern die Blöcke an. Da es sich um eine Modbuskommunikation zwischen den Relaismodulen und der #htl3r.short[sps] handelt, werden die Ausgänge, die zu den Gleisabschnitten gehen auch als Coils und die Eingänge der Reflex-Lichtschranken als Discrete Inputs bezeichnet.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_relais-modul.jpg", width: 75%),
    caption: "Ein- und Ausgänge eines Relaismoduls"
  )
)



Die Siemens LOGO! #htl3r.short[sps] ist dabei der Kopf der Steuerung, das heißt auf der #htl3r.short[sps] läuft das Programm, das die einzelnen Blöcke ansteuert. Um zu wissen, welche Blöcke angeschaltet werden sollen, holt sich die #htl3r.short[sps] als Modbus-Client von den RTUs die Zustände der Reflex-Lichtschranken und entscheidet infolgedessen, welche Blöcke angesteuert werden sollen und schickt diese Entscheidung wieder zurück an die #htl3r.shortpl[rtu].

Im Programm der Siemens LOGO! #htl3r.short[sps] werden die Eingänge und Ausgänge Variable Memorys (VMs) zugeordnet. Die VMs sind eindeutig durch eine Zahl A.B gekennzeichnet. In diesem Fall ist A das Relaismodul und gleichzeitg der Unterschied zwischen Coils und Discrete Inputs. B steht für den Platz am Relais Modul.

#htl3r.fspace(
  figure(
    table(
      columns: 4,
      table.header([*Relaismodul*],[*VM Discrete Input*],[*VM Coils*], [*IP-Adresse*]),
      [W1], [0.0 - 0.5], [1.0 - 1.3], [10.100.0.11],
      [W2], [2.0 - 2.5], [3.0 - 3.3], [10.100.0.12],
      [W3], [4.0 - 4.5], [5.0 - 5.5], [10.100.0.13],
    ),
    caption: "Zuordnung Relais Module zum Variable Memory Speicher"
  )
)

Ein Überblick über alle Ein- und Ausgänge von den Bauteilen, selbst bis hin zur #htl3r.short[sps] wird in den folgenden zwei Tabellen dargestellt.

#htl3r.fspace(
  figure(
    table(
      columns: 5,
      table.header([*Block*],[*Schienen Position*],[*Relais Modul Slot*],[*Variable Memory*], [*IP Adresse*]),
      [B1],	[außen],	[W2.1], [3.0],	[10.100.0.12],
      [B1],	[innen],	[W2.2], [3.1],	[10.100.0.12],
      [B2],	[außen],	[W3.1], [5.0],	[10.100.0.13],
      [B2],	[innen],	[W3.2], [5.1],	[10.100.0.13],
      [B3],	[außen],	[W3.3], [5.2],	[10.100.0.13],
      [B3],	[innen],	[W3.4], [5.3],	[10.100.0.13],
      [B4],	[außen],	[W1.3], [1.2],	[10.100.0.11],
      [B4],	[innen],	[W1.4], [1.3],	[10.100.0.11],
      [B5],	[außen],	[W1.1], [1.0],	[10.100.0.11],
      [B5],	[innen],	[W1.2], [1.1],	[10.100.0.11],
      [B6],	[außen],	[W2.3], [3.2],	[10.100.0.12],
      [B6],	[innen],	[W2.4], [3.3],	[10.100.0.12],
      [B7],	[außen],	[W3.5], [5.4],	[10.100.0.13],
      [B7],	[innen],	[W3.6], [5.5],	[10.100.0.13]
    ),
    caption: "Zuordnung der Blöcke"
  )
)

#htl3r.fspace(
  figure(
    table(
      columns: 4,
      table.header([*Reflex-Lichtschranken*],[*Relais Modul Slot*],[*Variable Memory (VM)*], [*IP Adresse*]),
      [B1.1], [W1.1], [0.0], [10.100.0.11],
      [B1.2], [W2.1], [2.0], [10.100.0.12],
      [B1.3], [W1.6], [0.5], [10.100.0.11],
      [B2.1], [W2.2], [2.1], [10.100.0.12],
      [B2.2], [W3.3], [4.2], [10.100.0.13],
      [B2.3], [W2.4], [2.3], [10.100.0.12],
      [B3.1], [W3.4], [4.3], [10.100.0.13],
      [B3.2], [W3.2], [4.1], [10.100.0.13],
      [B3.3], [W3.6], [4.5], [10.100.0.13],
      [B4.1], [W3.1], [4.0], [10.100.0.13],
      [B4.2], [W1.4], [0.3], [10.100.0.11],
      [B4.3], [W2.5], [2.4], [10.100.0.12],
      [B5.1], [W1.3], [0.2], [10.100.0.11],
      [B5.2], [W1.2], [0.1], [10.100.0.11],
      [B6.1], [W1.5], [0.4], [10.100.0.11],
      [B6.2], [W2.3], [2.2], [10.100.0.12],
      [B7.1], [W2.6], [2.5], [10.100.0.12],
      [B7.2], [W3.5], [4.4], [10.100.0.13]
    ),
    caption: "Zuordnung der Reflex-Lichtschranken"
  )
)

== Programm Begrifflichkeiten
Das Programm, um die Gleisabschnitte zu schalten, ist mit der Software LOGO!Soft Comforte geschrieben, welche als Programiersprache Funktionsplan (FUP) verwendet. FUP ist eine grafische Programmiersprache und verwendet Bausteine aus der booleschen Algebra, um ein Programm zu schreiben.

Um bei größeren Programmen einen Überblick zu behalten, können mehrere Bausteine zu einem größeren zusammengefasst werden. Dieser größere Baustein wird als #htl3r.long[udf] oder auch #htl3r.short[udf] bezeichnet.

== Programm im Detail
Bei der Blocksteuerung ist immer der aktuelle, der letzte und der nächste Block freigeschaltet, damit der Übergang zwischen den Blöcken ohne Verzögerung funktionert siehe @an.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/block-an.jpg"),
      caption: "Blockübersicht mit Modelleisenbahn"
    ) <an>
  ]
)

Sobald nun  die Modelleisenbahn in den nächsten Block fährt, wird der übernächste Block freigeschalten und der vorletzte dekativert. Mit dem übernächsten Gleisabschnitt ist dabei nicht der Block gemeint in den, die Modelleisenbahn zu dem Zeitpunkt einfährt, sondern der danach siehe @uebergang.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/block-uebergang-2.jpg"),
      caption: "Blockübergang mit Modelleisenbahn"
    ) <uebergang>
  ]
)
#pagebreak()
Nachdem das Programm für die Blocksteuerung im Ganzen etwas unübersichtlich ist, werden hier einzelne Teile herausgenommen und beschrieben.
#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Blocksteuerung_v1_8.jpg", width: 80%),
    caption: "Gesamte Blocksteuerung"
  )
)

Wie in @mapping beschrieben, wird jeder Modbus Input und Output einer Adresse im Variablenspeicher zugeordnet. Um auf die Variablen zugreifen zu können - die in diesem Fall einen Block oder eine Weiche steuern - werden Network Inputs und Outputs benutzt, siehe @netinput. Zur vereinfachten Darstellung werden im folgenden Verlauf aber digitale Inputs und Outputs verwendet.
#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/inputs-vergleich.png", width: 80%),
      caption: "Vergleich Network und Digital Inputs und Outputs"
    )
    <netinput>
  ]
)

#pagebreak()
== Outputverarbeitung
Die Modelleisenbahn fährt indem an einen Block Strom angelegt wird. Dabei wird je nach Richtung entweder dem äußeren oder inneren Gleisabschnitt Strom hinzugefügt. Um dies in der Steuerung auf der #htl3r.short[sps] abzubilden und anzusteuern gibt es pro Blockabschnitt zwei Outputs, die die jeweilige Richtung steuern.
\ \
Vor jedem Output ist dabei die #htl3r.short[udf] "ende" angeschlossen.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-ende-angeschlossen.png", width: 50%),
    caption: "UDF Ende in der Steuerung"
  )
)

Die #htl3r.short[udf] "ende" schaltet dabei einen RS-Flip-Flop vor den Output. Mithilfe des RS-Flip-Flop kann der Output nun von seperaten Signalen ein- und ausgeschalten werden. Außerdem beinhaltet die #htl3r.short[udf] vor den Eingängen des RS-Flip-Flop jeweils ein OR Gatter, welches die Anzahl der Eingänge erweitert.



#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-ende-blockteuerung.png"),
    caption: "UDF Ende"
  )
)


=== Inputverarbeitung <anfang>
Jeder Gleisabschnitt hat eine Reflex-Lichtschranke am Blockanfang und eine am Blockende, somit liegen immer zwei Reflex-Lichtschranken nahe beieinander.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/blockubergang.png", width: 75%),
    caption: "Übergang von einem Block in den anderen"
  )
)

Um zu bestimmen, in welche Richtung der Zug fährt wird die #htl3r.long[udf] "anfang" verwendet. Diese schaltet, sobald die Modelleisenbahn über eine Reflex-Lichtschranke gefahren ist, den entsprechenden Output an, sodass der nächste Block unter Strom gesetzt wird und der Zug ohne Verzögerung weiterfahren kann.
\ \
In der @ausfahrt kann dieses Verhalten beobachtet werden. Dabei ist "I1" die Blockausfahrts-Reflex-Lichtschranke und "I2" die Blockeinfahrts-Reflex-Lichtschranke. Sobald der Zug über I1 fährt wird der nächste Block, in diesem Fall "Q1" freigeschaltet.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/input-2.png", width: 75%),
      caption: "Blockausfahrtsignal im Schaltbild"
    ) <ausfahrt>
  ]
)
#pagebreak()
Wenn nun auf der danebenliegenen Reflex-Lichtschranke ein Signal gesendet wird, in diesem Fall "I2", wird sie nicht durchgeschaltet, weil die Steuerung nur mit Blockausfahrtsignalen arbeitet und ansonsten ein zurückliegender Block eingeschaltet werden würde. 

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/input-3.png", width: 75%),
    caption: "Blockeinfahrtsignal im Schaltbild"
  )
)

Die Funktion dahinter versteckt sich in der #htl3r.short[udf] "anfang". Die #htl3r.short[udf] kann dabei als Bedingung gesehen werden die heißt - solange der erste Input an ist und 3,5 Sekunden nach dem Ausschalten des ersten Inputs hat der zweite Input keine Auswirkungen. Die 3,5 Sekunden sind dabei jene Zeit, die ein Input nach Aktiverung der Reflex-Lichtschranke als High angezeigt wird.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-anfang.png", width: 110%),
    caption: "UDF Anfang"
  )
)
#pagebreak()
=== Inputverarbeitung mit Weiche
Wenn der aktuelle Block eine Weiche beinhaltet, kann nicht einfach nur der nächste Block freigeschaltet werden, sondern es muss zuerst die aktuelle Weichenstellung geprüft werden, um den nächsten Block zu bestimmen. Dies wird mit der #htl3r.short[udf] "weichenstellung" gemacht. Diese #htl3r.short[udf] hängt am Output der #htl3r.shortpl[udf] "anfang" und bekommt zusätzlich noch einen Input für die akutelle Weichenstellung. Die #htl3r.short[udf] "weichenstellung" schaltet je Weichenstellung den nächsten Block frei.
\ \
In der @weiche0 ist zu sehen, dass "I2" die Reflex-Lichtschranke das Blockausfahrtsignal ist und deswegen wie in @anfang beschrieben das Signal durchgeschaltet wird. Nun hängt die #htl3r.short[udf] "weichenstellung" am Output und deklariert aufgrund der Weichenstellung den Output "Q3" als nächsten Block.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/weiche2.png", width: 90%),
      caption: "Schaltbild der Inputverarbeitung mit Weichenausgang LOW"
    ) <weiche0>
  ] 
)
#pagebreak()
Sollte die Weiche in die andere Richtung geschaltet sein, wird stattdessen wie in @weiche1 abgebildet der Output "Q2" freigeschaltet.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/weiche3.png", width: 90%),
      caption: "Schaltbild der Inputverarbeitung mit Weichenausgang HIGH"
    ) <weiche1>
  ]
)

Die #htl3r.short[udf] "weichensteuerung" ist dabei eine AND-Verknüpfung von der aktuellen Weichenstellung und dem Input der Reflex-Lichtschranke.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-weichenstellung.png", width: 85%),
    caption: "UDF Weichenstellung"
  )
)
#pagebreak()
=== Überschreiben der Weichenstellung
Beim Fahren über die Weiche in die gegengesetzte Richtung entsteht das Problem, dass die Weiche in die richtige Richtung gestellt sein muss, damit der Zug die Weiche nicht aufschneidet. Um dieses Problem zu bewältigen muss der Weichenzustand überschrieben werden, sobald der Zug über diese fährt. Gleichzeitg soll aber der Weichenzustand immer noch manuell eingestellt werden können.

In @weichensteuerung ist "NQ1" der Ausgang zur Weiche und "I1" der Userinput mit dem die Weiche gesteuert werden kann. Zu sehen ist außerdem der Input "I2", der eine Reflex-Lichtschranke un der Ausgang "Q1" der einen Block darstellt. 
\ \
Vor dem Weichenausgang hängt dabei eine #htl3r.short[udf] "OWeiche" oder "Overwrite Weiche". Die #htl3r.short[udf] ermöglicht dabei, dass solange der Zug nicht in die Gegenrichtung über die Weiche fährt, dass der User die Weiche kontrolliert siehe @weichensteuerung.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/ueberweiche2.png", width: 85%),
      caption: "Schaltbild Weichensteuerung durch User"
    )
    <weichensteuerung>
  ]
)

Fährt die Modelleisenbahn in die Gegenrichtung über die Weiche, triggert das entweder den Input _Low_ oder _High_ der #htl3r.short[udf] "OWeiche". Die #htl3r.long[udf] bewirkt daraufhin, dass der aktuelle Zustand der Weiche überschrieben wird. 
#pagebreak()
In @ueberschreiben ist zu sehen, dass die Reflex-Lichtschranke "I2" an ging und somit das Signal sendet, dass der Zug in die Gegenrichtung über die Weiche fährt. Dies passiert, indem das Programm beim Freischalten des Blockabschnitts den Input _Low_ triggert, der wiederum nach einer kurzen Verzögerung den Steuerausgang für die Weiche "NQ1" auf Low stellt und somit der Userinput überschrieben wird.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/ueberweiche3.png", width: 90%),
      caption: "Schaltbild Weichensteuerung überschrieben"
    ) <ueberschreiben>
  ] 
)
#pagebreak()
Die #htl3r.short[udf] "OWeiche" sieht für den low-overwrite und den high-overwrite gleich aus. Die #htl3r.short[udf] besteht jeweils aus zwei Triggern und einer Kombination aus AND und OR Gattern, die das Überschreiben ermöglichen. Der erste Trigger (4,5 Sekunden) ist dabei zuständig für eine kurze Verzögerung vor dem Überschreiben. Die Verzögerung wird benötigt, damit im restlichen Programm der nächste Block in die richtige Richtung freigeschaltet wird. Der zweite Trigger (7 Sekunden) ist die Zeit, die das Überschreiben anhalten soll. Diese Zeit ist die gemessene Dauer, die die Modelleisenbahn benötigt, um vom triggern der #htl3r.short[udf] "OWeiche" bis zur Weiche selbst zu gelangen.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-oweiche.png"),
    caption: "UDF Overwrite Weichenstellung"
  )
)

#pagebreak()
=== Funktion, um Inputs zu deaktivieren
Die gleichzeitige Verarbeitung von zwei nebeneinander liegenden Reflex-Lichtschranken wird durch die #htl3r.short[udf] "anfang" siehe @anfang verhindert. Allerdins muss auch sichergestellt werden, dass der richtige Input verarbeitet wird. Der "richtige" Input ist dabei das Blockausfahrtsignal. Das passiert indem das Blockeinfahrtsignal dekativert wird, sobald der dazu gehörige Gleisabschnitt aktivert wird.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/reflex-aus.png", width: 70%),
    caption: "Netzplan deaktiverter Reflexlichtschranke"
  )
)

Um die Blockeinfahrts-Reflex-Lichtschranke abzuschalten muss zwischen jedem Input und jeder #htl3r.short[udf] "anfang" ein XOR und ein AND Gatter geschaltet werden siehe @deaktivierung. Die zwei zusätzlichen Bausteine bewirken, dass Blöck nur von der jeweiligen Reflex-Lichtschranke eingeschaltet werden können - so wie bisher auch - aber gleichzeitig, dass die Blöcke nicht eingeschaltet werden, wenn es sich um das Blockeinfahrtsignal handelt. 

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/input-deaktivieren.png"),
      caption: "Blockschaltbild mit Inputdeaktiverung"
    ) <deaktivierung>
  ] 
)
#pagebreak()
=== Stoppen der Steuerung
Die gesamte Steuerung wird gestoppt, indem auf allen Gleisabschnitten der Strom entzogen wird. Dabei hängt ein Merker am Reset-Eingang aller Outpus. Sobald dieser Merker angeschalten wird, wird die Spannungsversorgung aller Blöcke abgeschaltet, wodurch der Zug auf keine Art und Weise fahren kann, bevor nicht der Merker wieder auf False gesetzt ist.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/stopp.png", width: 45%),
    caption: "Merker zum Stoppen mit Anschlüssen zu Reset-Eingängen der Outputs"
  )
)
#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/stopp-2.png", width: 45%),
    caption: "Vereinfachtes Programm mit Stoppmerker und einem Output"
  )
)
