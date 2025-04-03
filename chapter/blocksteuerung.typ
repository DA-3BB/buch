#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Marlene Reder")

= Blocksteuerung <blocksteuerung>
Die Steuerung der Modelleisenbahn besteht aus zwei Teilen, der Weichensteuerung und der Blocksteuerung. In diesem Kapitel wird die Blocksteuerung genauer betrachtet.

== Blockschaltbild

Bevor die Steuerung selbst erklärt werden kann, ist wichtig zu wissen, dass Modelleisenbahnanlage genauer gesagt die Gleise in mehrere Blöcke unterteilt sind, welche seperat angesteuert werden können. Der Zug fährt dabei, wenn in dem Gleisabschnitt auf dem er steht, Strom angelegt ist. Um die Blöcke auseinander zu halten sind sie beschriften mit B1-B7.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Gleisplan_bloecke-mit-beschriftung.png"),
    caption: "Gleisplan mit Blöcken"
  )
)

Bei der Grenze zwischen zwei Gleisabschnitten sind Reflex-Lichtschranken eingebaut, mithilfe dessen erkannt werden kann, dass ein Zug in einen Block einfährt beziehungsweise einen Gleisabschnitt verlässt.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Netzplanabschnit.png"),
    caption: "Aufbau Blockübergang"
  )
)

Auch die Reflex-Lichtschranken sind beschriftet mit BX.Y, um einen Überblick zu behalten. Dabei steht X für den Block in dem die Lichtschranke liegt und Y ist die Nummerierung der Reflex-Lichtschranken in einem Block.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Gleisplan_blocke-reflex.png"),
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
        [3x RTU - Relais Module],[10.100.0.11 - 13],[Modbus-Server],
    ),
    caption: [Komponenten aus Betrachtungssicht der Blocksteuerung]
  )
)
Die Relaismodule werden verwendet, um den Input der Reflex-Lichtschranken aufzuzeichnen und die Blöcke anzusteuern. Da es sich um eine Modbuskommunikation zwischen den Relaismodulen und der #htl3r.short[sps] handelt, werden die Ausgänge, die zu den Gleisabschnitten gehen auch als Coils und die Eingänge der Reflex-Lichtschranken als Discrete Inputs bezeichnet.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_relais-modul.png", width: 75%),
    caption: "Ein- und Ausgänge eines Relaismoduls"
  )
)



Die Siemens LOGO! #htl3r.short[sps] ist dabei der Kopf der Steuerung, das heißt auf der #htl3r.short[sps] läuft das Programm, das die einzelnen Blöcke ansteuert. Um zu wissen, welche Blöcke angeschaltet werden sollen, holt sich die #htl3r.short[sps] als Modbus-Client von den RTUs die Zustände der Reflex-Lichtschranken und entscheidet infolgedessen, welche Blöcke angesteuert werden sollen und schickt diese Enscheidung wieder zurück an die RTUs.

Im Programm der Siemens LOGO! #htl3r.short[sps] werden die Eingänge und Ausgänge Variable Memorys (VMs) zugeordnet. Die VM sind eindeutig durch eine Zahl X.Y. In diesem Fall ist X das Relaismodul und gleichzeitg der Unterschied zwischen Coils und Discrete Inputs. Y steht für den Platz am Relais Modul.

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
      table.header([*Block*],[*Kabel außen / innen*],[*Relais Modul Slot*],[*Variable Memory*], [*IP Adresse*]),
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
Das Programm, um die Gleisabschnitte zu schalten, ist mit der Software LOGO!Soft Comforte geschreiben, welche als Programiersprache einen Funktionsplan (FUP) verwendet. FUP ist eine grafische Programmiersprache und verwendet Bausteine aus der booleschen Algebra, um ein Programm zu schreiben.

Um bei größeren Programmen einen Überblick zu behalten, können mehrere Bausteine zu einem größeren zusammengefasst werden. Dieser größere Baustein wird als #htl3r.long[udf] oder auch #htl3r.short[udf] bezeichnet.

== Programm im Detail
Die Blocksteuerung funktioniert indem sobald die Modelleisenbahn einen Block verlässt der übernächste freigeschalten wird und der letzte dekativert wrid. Mit dem übernächsten Gleisabschnitt ist nicht der Block gemeint in den, die Modelleisenbahn zu dem Zeitpunkt einfährt, sondern den danach.

Nachdem das Programm für die Blocksteuerung im Ganzen etwas unübersichtlich ist, werden hier einzelne Zeile herausgenommen und beschrieben.
#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/3BB_Blocksteuerung_v1_8.jpg", width: 80%),
    caption: "Gesammte Blocksteuerung"
  )
)

Wie in @mapping beschrieben, wird jeder Modbus Input und Output einer Variable Memory Speicherstelle zugeordnet. Um die VM Speicherstelle im Programm benutzen zu können, werden Network Inputs und Outputs benutzt siehe @netinput. Zur vereinfachten Darstellung werden im folgenden Verlauf aber digitale Inputs und Outputs verwendet.
#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/input.png", width: 80%),
      caption: "Vereinfachtes Programm mit Network Inputs und Outputs"
    )
    <netinput>
  ]
)


== Outputverarbeitung
Ein Block wird gesteuert, indem es je nach Richtung des Gleisabschnitts einen Output gibt. Vor diesem Output hängt jeweils ein #htl3r.short[udf] namens "Ende", welches ein RS-Flip-Flop mit einem OR vor dem SET und RESET des RS-Flip-Flop hat um die Eingänge zu erweitern.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-ende-blockteuerung.png"),
    caption: "UDF Ende"
  )
)


=== Inputverarbeitung <anfang>
Jeder Gleisabschnitt hat eine Reflex-Lichtschranke am Blockanfang und eine am Blockende somit liegen immer zwei Reflex-Lichtschranken nahe beieinander. Um zu bestimmen, in welche Richtung der Zug fährt wird nun die #htl3r.long[udf] "anfang" verwendet. Diese schaltet, sobald die Modelleisenbahn über eine Reflex-Lichtschranke gefahren ist, den entsprechenden Output an, sodass der nächste Block unter Strom gesetzt wird und der Zug ohne Verzögerung weiterfahren kann.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/input-2.png", width: 75%),
    caption: "Blockausfahrt im Schaltbild"
  )
)

Wenn nun der danebenliegene Input imanschluss angeht, wird dieser nicht durchgeschalten, weil immer nur auf den Austritt aus einem Block geschaut wird.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/blockubergang.png", width: 75%),
    caption: "Übergang von einem Block in den anderen"
  )
)

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/input-3.png", width: 75%),
    caption: "Blockeinfahrt im Schaltbild"
  )
)

Die Funktion dahinter versteckt sich im #htl3r.short[udf] Anfang. Wenn das #htl3r.short[udf] genauer betrachet wird, ist festzustellen, dass sich in der Funktion ein Trigger befindet, der den zweiten Input für 3,5 Sekunden ignoriert. Die 3,5 Sekunden ist jene Zeit, die ein Input nach Aktiverung der Reflex-Lichtschranke als High angezeigt wird.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-anfang.png", width: 90%),
    caption: "UDF Anfang"
  )
)

=== Inputverarbeitung mit Weiche
Wenn nun der aktuelle Block eine Weiche beinhaltet, kann nicht einfach nur der nächste Block freigeschalten werden, sondern es muss erstmal geschaut werden, wie die Weichenstellung aktuell ist um den nächsten Block zu bestimmen. Dies wird mit der #htl3r.short[udf] "Weichenstellung" gemacht. Diese #htl3r.short[udf] hängt am Output der #htl3r.shortpl[udf] "Anfang" und bekommt zusätzlich noch einen Input von der Weichensteuerung. Je nachdem ob die Weiche in die eine Richtung, auf high gestellt ist oder in die andere auf low, wird der jeweilige input angesteuert.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/weiche2.png", width: 80%),
    caption: "Schaltbild der Inputverarbeitung mit Weiche auf 0"
  )
)

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/weiche3.png", width: 80%),
    caption: "Schaltbild der Inputverarbeitung mit Weiche auf 1"
  )
)

Die #htl3r.short[udf] ist dabei eine AND-Verknüfung von der aktuellen Weichenstellung und dem Input der Reflex-Lichtschranke.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-weichenstellung.png", width: 80%),
    caption: "UDF Weichenstellung"
  )
)
=== Überschreiben der Weichenstellung
Beim Fahren über die Weiche in die gegengesetzte Richtung entsteht das Problem, dass die Weiche in die richtige Richtig gestellt sein muss, damit der Zug die Weiche nicht aufschneidet. Um diese Problem zu bewältigen muss der Weichenzustand überschrieben werden, sobald der Zug über diese drüber fährt, gleichzeitg soll aber der Weichenzustand immer noch manuel eingestellt werden können.

In @weichensteuerung ist zu sehen, dass bei der Weichensteuerung zwischen dem Userinput I1 und dem Output zur Weiche NQ1 eine #htl3r.short[udf] hängt, welche das zweitweilige Überschreiben der Weichenstellung ermöglicht. In @weichensteuerung ist außerdem zu sehen, dass derzeit der User die Weiche kontrolliert, da auf den Eingängen _Low_ und _High_ kein Signal hängt.

#htl3r.fspace(
  [
    #figure(
      image("../assets/blocksteuerung/ueberweiche2.png", width: 85%),
      caption: "Schaltbild Weichensteuerung durch User"
    )
    <weichensteuerung>
  ]
)

Fährt nun die Modelleisenbahn in die Gegenrichtung über die Weiche, muss in diesem Fall der Weichenzustand auf Low gesetzt werden. Dies passiert, indem das Programm beim Freischalten des Blockabschnitts den Input _Low_ triggert, der wiederum nach einer kurzen Verzögerung die Weiche auf Low stellt.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/ueberweiche3.png", width: 85%),
    caption: "Schaldbild Weichensteuerung überschrieben"
  )
)

Die #htl3r.short[udf] "OWeiche" oder auch "Overwrite Weiche" schaut für den low-overwrite und high-overwrite gleich aus. Die #htl3r.short[udf] besteht jeweils aus zwei Triggern und einer Kombination aus AND und OR Gattern, die das Überschreiben ermöglichen. Der erste Trigger (4,5 Sekunden) ist dabei zuständig für eine kurze Verzögerung vom Überschreiben, die benötigt wird, damit im restlichen Programm der nächste Block in die richtige Richtung freigeschalten wird. Der zweite Trigger (7 Sekunden) ist die Zeit, die das Überschreiben anhalten soll. Diese Zeit ist die gemessene Dauer, die die Modelleisenbahn benötigt, um vom Triggern des #htl3r.short[udf] bis zum überfahren der Weiche.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/udf-oweiche.png", width: 95%),
    caption: "UDF Overwrite Weichenstellung"
  )
)


=== Funktion, um Inputs zu deaktiveren
Die Verarbeitung von zwei aneinanderfolgenden Inputs wird durch die #htl3r.short[udf] "Anfang" siehe @anfang verhindert. Allerdins muss auch geschaut werden, dass der richtige Input verarbeitet wird. Der "richtige" Input ist dabei, der der die Blockausfahrt angibt, da nur diese relevant sind. Das passiert indem sobald ein Gleisabschnitt in eine Richtung freigeschalten ist, die Reflex-Lichtschranke zur Blockeinfahrt deaktivert wird.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/reflex-aus.png", width: 70%),
    caption: "Netzplan mit deaktiverung der Reflexlichtschranke"
  )
)

Um die Blockeinfahrts-Reflex-Lichtschranke abzuschalten muss zwischen jedem Input und jeder #htl3r.short[udf] "Anfang" ein XOR und ein AND Gatter geschalten werden. Die zwei zusätzlichen Bausteine bewirken, dass Blöck nur vom jeweiligen Input eingeschaltet werden können, aber gleichzeitig das einschalten verhindern, wenn der der Input eine Einfahrts-Reflex-Lichtschranke ist, da diese einen Block hinter der Modelleisenbahn freischalten würde.

#htl3r.fspace(
  figure(
    image("../assets/blocksteuerung/input-deaktivieren.png"),
    caption: "Blockschaltbild mit Inputdeaktiverung"
  )
)

=== Stoppen der Steuerung
Die gesammte Steuerung wird gestoppt, indem auf allen Gleisabschnitten der Strom entzogen wird. Dabei hängt ein Merker am Reset-Eingang aller Outpus. Sobald dieser Merker angeschalten wird ist der Strom weg, wodurch der Zug auf keine Art und Weise fahren kann, bevor nicht der Merker wirder auf False gesetzt ist.

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
