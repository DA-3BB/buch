#import "@local/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

= OT-Steuerung
== Blockssteurung
Die Steuerung der Modelleisenbahn besteht aus zwei Teilen der Weichensteuerung und der Blocksteuerung. In diesem Kapitel wird die Blocksteuerung genauer betrachtet.

=== Blockschaltbild

Bevor das die Steuerung selbst erklärt werden kann, ist wichtig zu wissen, dass Modelleisenabhnanlage, geneauer gesagt die Gleise in mehrere Blöcke untereilt sind, welche seperat angesteuert werden können. Der Zug fährt dabei, wenn in dem Gleisabschnitt auf dem er steht Strom anliegt. Um die Blöcke auseinander zu halten sind sie beschriften mit B1-B7.

#figure(
  image("../assets/blocksteuerung/3BB_Gleisplan_bloecke-mit-beschriftung.png"),
  caption: "Gleisplan mit Blöcken"
)

Bei der Grenze zwischen zwei Gleisabschnitten sind Refelx-Lichtschranken eingebaut, mithilfe dessen erkannt werden kann, dass ein Zug in einen Block einfährt beziehungsweise einen Gleisabschnitt verlässt.  

#figure(
  image("../assets/blocksteuerung/3BB_Netzplanabschnit.png"),
  caption: "Aufbau Blockübergang"
)

Auch die Refelx-Lichtschranken sind beschriftet mit BX.Y um einen Überblick zu behalten. Dabei steht X für den Block in dem die Lichtschranke liegt und Y ist die Nummerierung der Refelx-Lichtschranken in einem Block. 

#figure(
  image("../assets/blocksteuerung/3BB_Gleisplan_blocke-reflex.png"),
  caption: "Gleisplan mit Blöcken und Reflex-Lichtschranken Beschriftung"
)


=== Zuordnung der Steuerelemente zum SPS Programm <mapping>
Für die Blocksteuerung werden folgende Komponenten benötigt:


#figure(
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

Die Relaismodule werden verwendet um den Input der Refelx-Lichtschranken aufzuzeichnen und die Blöcke anzusteuerun. Da es sich um eine Modbuskommunikation zischen den Relaismodulen und der SPS handelt, werden die Ausgänge, die zu den Gleisabschnitten gehen, auch als Coils und die Eingänge der Refelx-Lichtschranken als Discrete Inputs bezeichnet. 

#figure(
  image("../assets/blocksteuerung/3BB_relais-modul.png", width: 75%),
  caption: "Ein- und Ausgänge eines Relaismoduls"
)



Die Siemens LOGO! SPS ist dabei der Kopf der Steuerung das heißt auf der SPS läuft das Programm das die einzelnen Blöcke ansteuerut. Um zu wissen, welche Blöcke angeschaltet werden sollen, holt sich die SPS als Modbus-Client von den RTUs die Zustände der Refelx-Lichtschranken und entscheidet infolgedessen welche Blöcke ansteuert werden sollen und schickt diese Enscheidung wieder zurück an die RTUs.

Im Programm der Siemens LOGO! SPS werden die Eingänge und Ausgänge Variable Memorys (VMs) zugeordnet. Die VM sind eindeutig durch eine Zahl X.Y. In diesem Fall ist X dabei das Relaismodul und gleichzeitg der unterschied zwischen Coils und Discrete Inputs und Y den Platz am Modul. 

#figure(
  table(
    columns: 4,
    table.header([*Relaismodul*],[*VM Discrete Input*],[*VM Coils*], [*IP-Adresse*]),
    [W1], [0.0 - 0.5], [1.0 - 1.3], [10.100.0.11],
    [W2], [2.0 - 2.5], [3.0 - 3.3], [10.100.0.12],
    [W3], [4.0 - 4.5], [5.0 - 5.5], [10.100.0.13],
  ),
  caption: "Zuordnung Relais Module zum Variable Memory Speicher"
)

Ein Überblick über alle Ein- und Ausgänge von den Bauteilen selbst bis hin zur SPS wird in den folgenden zwei Tabellen dargestellt. 

#figure(
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

#figure(
  table(
    columns: 4,
    table.header([*Refelx-Lichtschranken*],[*Relais Modul Slot*],[*Variable Memory (VM)*], [*IP Adresse*]),
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

=== Programm Begirfflichkeiten
Das Programm um die Gleisabschnitte zu schlaten ist mit der Software LOGO!Soft Comforte geschreiben, welche als Programiersprache einen Funktionsplan (FUP) verwendet. FUP ist eine grafische Programmiersprache und verwendet Bausteine aus der boolschen Algebra um ein Programm zu schreiben. 

Um bei größeren Programmen einen Überblick zu behalten können mehrere Bausteine zu einem größeren zusammengefasst werden. Dieser größere Baustein wird als User-Defined-Funktion oder auch UDF bezeichnet.

=== Programm im Detail
Die Blocksteuerung funktioniert indem sobal die Modelleisenbahn einen Block verlässt der übernächste freigeschalten wird und der letzt dekativiert ist. Mit dem übernächsten Gleisabschnitt ist nicht der Block gemeint in den die Modelleisenbahn zu dem Zeitpunkt einfährt sondern den danach.

Nachdem das Programm für die Blocksteuerung in einem etwas unerübersichtlich ist, wird werden hier einzelne Zeile herausgenommen und beschrieben.
#figure(
  image("../assets/blocksteuerung/3BB_Blocksteuerung_v1_8.jpg", width: 80%),
  caption: "Gesammte Blocksteuerung"
)

Wie in @mapping beschrieben wird jeder Modbus Input und Output einer Variable Memory Speicherstelle zugeordnet. Um die VM Speicherstelle im Programm benutzen zu können werden ein Network Inputs und Output benutzt siehe @netinput. Zur vereinfacheten Darstellung werden im folgenden verlauf aber digitale Inputs und Outputs verwendet.
#figure(
  image("../assets/blocksteuerung/input.png", width: 80%),
  caption: "Vereinfachtes Programm mit Network Inputs und Outputs"
) <netinput>


=== Outputverarbeitung
Ein Block wird gesteuert indem es je nach Richtung des Gleisabschnitts einen Output gibt vor diesem Output hängt jeweils ein UDF namens Ende, welches ein RS-Flip-Flop mit einem oder vor dem set und rest ist.

#figure(
  image("../assets/blocksteuerung/udf-ende-blockteuerung.png"),
  caption: "UDF Ende"
)


==== Inputverarbeitung <anfang>
Jeder Gleisabschnitt hat eine Reflex-Lichtschranke am Block Anfang und eine am Blockende somit liegen immer zwei Reflex-Lichtschranken nahe beieinander. Um zu bestimmen in welche Richtung der Zug fährt wird nun die UDF "anfang" verwendet. Diese schaltet sobald die Modelleisenbahn über eine Reflex-Lichtschranke gefahren ist den entsprechenden Output an sodass der nächste Block unter Strom gesetzt wird und der Zug ohne Verzögerung weiterfahren kann.

#figure(
  image("../assets/blocksteuerung/input-2.png", width: 75%),
  caption: "Blockausfahrt im Schaltbild"
)

Wenn nun der danebeliegene Input gleich drauf angeht wird dieser nicht durchgeschalten, weil immer nur auf den Austritt aus einem Block geschaut wird.

#figure(
  image("../assets/blocksteuerung/blockubergang.png", width: 75%),
  caption: "Übergang von einem Block in den anderen"
)

#figure(
  image("../assets/blocksteuerung/input-3.png", width: 75%),
  caption: "Blockeinfahrt im Schaltbild"
)

Die Funktion dahinter verteckt sich im UDF Anfang. Wenn das UDF genauer betrachet wird, ist fest zu stellen, dass sich in der Funktion ein Trigger befindet, der den zweiten Input für 3,5 Sekunden ignoriert. Die 3,5 Sekunden ist dabei die Zeit die ein Input nach Aktiverung der Reflex-Lichtschranke als High angezeigt wird.

#figure(
  image("../assets/blocksteuerung/udf-anfang.png", width: 90%),
  caption: "UDF Anfang"
)

==== Inputverarbeitung mit Weiche
Wenn nun der aktuelle Block eine Weiche beeinhaltet kann nicht einfach nur der nächste Block freigeschalten werden, sondern es muss erstmal geschaut werden, wie die Weichenstellung aktuell ist um den nächsten Block zu bestimmen. Dies wird gemacht mit dem UDF Weichenstellung gemacht. Dieses UDF hängt am Output des UDFs Anfang und bekommt zusätzlich noch einen Input von der Weichensteuerung. Je nachdem ob die Weiche in die eine Richtung, auf high gestellt ist oder in die andere auf low, wird der jeweilige input angesteuert.

#figure(
  image("../assets/blocksteuerung/weiche2.png", width: 80%),
  caption: "Schaltbild der Inputverarbeitung mit Weiche auf 0"
)

#figure(
  image("../assets/blocksteuerung/weiche3.png", width: 80%),
  caption: "Schaltbild der Inputverarbeitung mit Weiche auf 1"
)

Das UDF ist dabei eine AND-Verknüfung von der aktuellen Weichenstellung und dem Input der Reflex-Lichtschranke.

#figure(
  image("../assets/blocksteuerung/udf-weichenstellung.png", width: 80%),
  caption: "UDF Weichenstellung"
)
==== Überschreiben der Weichenstellung
Beim Fahren über die Weiche in die gegengesetzte Richtung ensteht das Problem, dass die Weiche in die richtige Richtig gestellt sein muss, damit der Zug die Weiche nicht aufschneidet. Um diese Problem zu bewältigen muss der Weichenzustand überschrieben werden sobald der Zug über diese drüber fährt, gleichzeitg soll aber der Weichenzustand aber immernoch manuel eingestellt werden können. 

In @weichensteuerung ist zu sehen, dass bei der Weichensteuerung swichen dem Userinput I1 und dem Output zur Weiche NQ1 eine UDF hängt, welche die das zweitweilige überschreiben der Weichenstellung ermöglicht. In @weichensteuerung ist außerdem zu sehen, dass derzeit der User die Weiche kontrolliert, da auf den Eingängen _Low_ und _High_ kein Signal hängt. 

#figure(
  image("../assets/blocksteuerung/ueberweiche2.png", width: 85%),
  caption: "Schaltbild Weichensteuerung durch User"
) <weichensteuerung>

Fährt nun die Modelleisenbahn in die gegenrichtung über die Weiche muss in diesemfall der Weichenzustand auf Low gesetzt werden. Dies passiert, indem das Programm beim freischalten des Blockabschnitts den Input _Low_ Triggert, der wiederum nach einer kurzen Verzögerung den die Weiche auf Low stellt.

#figure(
  image("../assets/blocksteuerung/ueberweiche3.png", width: 85%),
  caption: "Schaldbild Weichensteuerung überschrieben"
)

Das UDF OWeiche oder auch Overwrite Weiche schaut dabei für den low-overwrite und high-overwrite gleich aus. Das UDF besteht jeweils aus zwei Triggern und einer Kompbination aus AND und OR Gattern die das überschreiben ermöglichen. Der erste Trigger ist dabei zuständig für eine kurze Verzögerung vom überschreiben, die benötigt wird, damit im restlichen Programm der nächste Block in die richtige Richtung freigeschalten wird. Der zweite Trigger ist die Zeit, die das überschreiben anhalten soll, diese Zeit ist die gemessene Dauer die die Modelleisenbahn benötigt um vom Triggern des UDF bis zum überfahren der Weiche.

#figure(
  image("../assets/blocksteuerung/udf-oweiche.png", width: 95%),
  caption: "UDF Overwrite Weichenstellung"
)


==== Funktion um Input zu dekativieren
Damit nicht nur nicht beide Inputs verarbeitet werden was durch die UDF Anfang @anfang bereitgestellt wird, sonder auch der richtige Input verarbeitet wird, wird sobald der Gleisabschnitt in eine Richtung freigeschalten ist die Reflex-Lichtschranke zur Blockeinfahrt deaktivert, da nur die Ausfahrst-Reflex-Lichtschranken für das Programm relevant sind. 

#figure(
  image("../assets/blocksteuerung/reflex-aus.png", width: 70%),
  caption: "Netzplan mit deaktiverung der Reflexlichtschranke"
)

Um das zu erreichen muss zwischen jedem Imput und jedem UDF Anfang ein XOR und ein AND Gatter geschalten werden, welche darauf schauen, dass der Block nur vom Input geschaltet werden, aber gleichzeitig das Schalten verhindern, wenn der Block so eingeschalten ist, dass der Input das Einfahrssingal ist.

#figure(
  image("../assets/blocksteuerung/input-deaktivieren.png"),
  caption: "Netzplan mit deaktiverung der Reflexlichtschranke"
)

==== Stoppen der Steuerung
Die gesammte Steuerung wird gestoppt indem auf allen Gleisabschnitten der der Strom entzogen wird. Dabei kängt ein Merker am Reset Eingang aller Output und sobald dieser Merker angeschalten wird ist der Strom weg und bis dieser wieder ausgeschalten wird kann der Zug auf keine Art und Weise wieder fahren.

#figure(
  image("../assets/blocksteuerung/stopp.png", width: 45%),
  caption: "Merker zum Stoppen mit allen Anschlüssen"
)
#figure(
  image("../assets/blocksteuerung/stopp-2.png", width: 45%),
  caption: "Vereinfachtes Programm mit Stoppmerker und einem Output"
)