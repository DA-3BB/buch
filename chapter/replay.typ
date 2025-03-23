#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Esther Lina Mayer")

== Replay
=== Theoretische Grundlagen
Bei einem Replay-Angriff werden gültige Daten abgefangen und vom Angreifer erneut übertragen - diese Art von Angriffen richtet sich somit gegen die Integrität der gesendeten Daten.

Das Prinzip hinter Replay-Angriffen ist sehr simpel, da ein Angreifer die gültigen Daten nicht entschlüsseln muss. Weiters haben sie kaum Anforderungen - der Angreiffer muss nur in der Lage sein, die Pakete zu erfassen, sie zu speichern und erneut abzusenden.

=== Analyse des Traffics mithilfe von Wireshark
Für die Durchführung eines Replay-Angriffs muss man valide Daten aus dem Netzwerk mitlesen, aus ihnen die entscheidenden Pakete herausfiltern und diese erneut senden. Dazu wird das Tool "Wireshark" - ein Sniffer#footnote[Eine detaillierte Erklärung zu Sniffern findet man unter: https://www.geeksforgeeks.org/introduction-to-sniffers/] zur Analyse des Netzwerktraffics - verwendet.

Es wird eine neue Aufzeichnung des Traffics gestartet, in welcher gültige Daten abgefangen werden. Für die folgende Demonstration wurde die _Weiche 4_ gewählt.

Als erstes wird der Ausgangszustand betrachtet. Hierfür wurde ein HTTP-Paket der SPS an den Management-PC ausgewählt und die Nutzdaten des Pakets ausgewertet.

#pagebreak()

#figure(
  image("../assets/angriffe/replay/wireshark_before.png", width: 100%),
  caption: "Ausschnitt des HTTP-Paketes vor der Änderung der Weiche in Wireshark"
)

Diese Daten - markiert in pink - sind im XML-Format und können mit einem beliebigen Online-Tool#footnote[https://www.samltool.com/prettyprint.php] lesbarer formatiert werden. So erhält man folgendes:

```xml
<rs>
  <r i="v0" e="0" v="00"/>
  <r i="v1" e="0" v="01"/>
  <r i="v2" e="0" v="01"/>
  <r i="v3" e="0" v="01"/>
</rs>
```

Aus den Daten ist folgende Stellung der Weichen ersichtlich:
- *Weiche 1*: v0 mit der Position 0
- *Weiche 2*: v1 mit der Position 1
- *Weiche 3*: v2 mit der Position 1
- *Weiche 4*: v3 mit der Position 1

Es wird die Stellung von Weiche 4 betrachtet - diese befindet sich in Position 1.

Anmerkung: Eine genaue Beschreibung der Positionen und Nummerierungen findet sich im Kapitel Weichensteuerung.

#pagebreak()

Nun wird vom Nutzer die Stellung der Weiche 4 bearbeitet und im Capture von Wireshark nach einer Änderung in den Daten gesucht. Diese findet sich in folgendem Paket:

#figure(
  image("../assets/angriffe/replay/wireshark_after.png", width: 100%),
  caption: "Ausschnitt des HTTP-Paketes nach der Änderung der Weiche in Wireshark"
)

Die Daten, welche aus dem Paket ausgelesen werden können, wurden wieder formatiert.

```xml
<rs>
  <r i="v0" e="0" v="00"/>
  <r i="v1" e="0" v="01"/>
  <r i="v2" e="0" v="01"/>
  <r i="v3" e="0" v="00"/>
</rs>
```

Man kann erkennen, dass die Weiche 4 von der Position 1 in die Position 0 gewechselt hat. Das bedeutet, dass in den abgefangenen Daten zwischen den gelisteten Paketen sich der Befehl zum Umschalten der Weiche befindet.

#pagebreak()

==== Auslesen des Befehls zum Ändern der Position der Weiche
Das Paket, das den gesuchten Befehl enthält, ist das folgende:

#figure(
  image("../assets/angriffe/replay/wireshark_switch.png", width: 100%),
  caption: "Ausschnitt des HTTP-Paketes mit dem Befehl zum Ändern der Weiche in Wireshark"
)

Um die Weiche 4 zu bearbeiten wird also vom Management-PC der folgende Befehl an die SPS gesendet.

`SETVARS:_local_=v3,M..1:4-1,00`

Dieser Befehl bearbeitet den Merker 4 (`v3`) und setzt den Wert auf `00`. Nun ist der Befehl bekannt, welcher als Replay-Angriff erneut gesendet werden soll.

#pagebreak()

=== Durchführung des Replay-Angriffs
Der zuvor ausgelesene Befehl soll nun erneut abgesendet werden. Hierfür wird das Tool `curl` verwendet.

`curl -X POST "http://10.100.0.1/AJAX" -d "SETVARS:_local_=v3,M..1:4-1,00"`

Das Kommando führt einen HTTP-POST-Request auf den gegebenen URL - den Webserver der SPS - durch. Mit der Option `-d` werden die Daten spezifiziert, die an den Server gesendet werden sollen, in diesem Fall der zuvor ausgelesene Befehl zum Ändern der Stellung der Weichen.

Führt man den Befehl aus, bekommt man die folgende Rückmeldung:

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ curl -X POST "http://10.100.0.1/AJAX" -d "SETVARS:_local_=v3,M..1:4-1,00"
Forbidden.
```

Das bedeutet, dass die SPS ohne valide Tokens keinen Zugriff akzeptiert. Es könnte sein, dass Siemens für seine Produkte Cross-Side Request Forgery Protection#footnote[https://owasp.org/www-community/attacks/csrf] implementiert hat.#footnote[Im Jahr 2018 wurde Siemens ein Vorfall gemeldet: https://www.cisa.gov/news-events/ics-advisories/icsa-15-239-02] Bei CSRF missbraucht der Angreifer eine gültige Nutzung eines Users dazu, um Aktionen durchzuführen, während der Nutzer authorisiert ist. Ein Schutz vor diesem Angriff kann zu Folge haben, dass bestimmte Anfragen verweigert werden, wenn sie keinen gültigen Token haben oder aus keiner gültigen Session kommen.

Um dies zu umgehen, kann man die Session-ID (Cookies) auslesen. Theoretisch kann man diese mithilfe eines Man-in-the-Middle-Angriffes oder anderen Exploits auslesen, das würde jedoch den Umfang dieses beschriebenen Angriffes überschreiten. Da der Replay-Angriff im eigenen Netzwerk zum Identifizieren der Schwachstellen gedacht ist, kann man die Cookies direkt aus dem Browser auslesen und in den Befehl integrieren.

#pagebreak()

Die Cookies des Webinterfaces der SPS kann man in den gespeicherten Variablen des Browsers (unter Firefox dem Webspeicher) auslesen.

#figure(
  image("../assets/angriffe/replay/session-id.png", width: 100%),
  caption: "Session-ID des Management-PC im Browser"
)

Mithilfe der Session-ID lassen sich die folgenden drei Befehle erstellen:

```
curl -X POST "http://10.100.0.1/AJAX" -b "Session-id=84f95779b816ac86edfa7a52fc0cc97a01902eb4ea96f9b96ad63c344dfd1b15" -d "SETVARS:_local_=v3,M..1:4-1,01"
curl -X POST "http://10.100.0.1/AJAX" -b "Session-id=84f95779b816ac86edfa7a52fc0cc97a01902eb4ea96f9b96ad63c344dfd1b15" -d "SETVARS:_local_=v3,M..1:4-1,00"
curl -X POST "http://10.100.0.1/AJAX" -b "Session-id=84f95779b816ac86edfa7a52fc0cc97a01902eb4ea96f9b96ad63c344dfd1b15" -d "GETVARS:_local_=v3,M..1:4-1"
```

Wichtig zu betrachten sind hier die drei Kommandos, die mithilfe der Option `-d` an den Webserver der SPS übergeben werden:
- `-d "SETVARS:_local_=v3,M..1:4-1,01"` setzt die Position der Weiche 4 auf `01`,
- `-d "SETVARS:_local_=v3,M..1:4-1,00"` setzt die Position der Weiche 4 auf `00` und
- `-d "GETVARS:_local_=v3,M..1:4-1"` liefert die aktuelle Position der Weiche 4 zurück.

#pagebreak()

==== Erfolgsbedingungen des Replay-Angriffs
Bei einem Replay-Angriff werden die abgefangenen Befehle nicht bearbeitet - das wären dann Code-Injections. Daher kann der Angreifer nur Schaden anrichten, wenn der Nutzer bereits die Weichen erneut umgeschalten hat. In diesem Fall wurde der Befehl zum Ändern der Weiche 4 auf Position `00` abgefangen. Sendet man diesen Befehl erneut ab, während die Weiche 4 ihre Position noch nicht erneut geändert hat, so hat der Angriff keine Auswirkung. Natürlich kann der Angreifer weitere Pakete abfangen und dies so umgehen. Für dieses Beispiel wurde jedoch die Weiche 4 vom Nutzer auf Position `01` geändert.

==== Senden des abgefangenen Befehls
Der Angreifer versendet nun den Befehl an die SPS.

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ curl -X POST "http://10.100.0.1/AJAX" -b "Session-id=84f95779b816ac86edfa7a52fc0cc97a01902eb4ea96f9b96ad63c344dfd1b15" -d "SETVARS:_local_=v3,M..1:4-1,00"
<rs><r i='v3' e='1'/></rs>
```

Die Auswirkungen des Befehls finden sich im folgenden Abschnitt.

#pagebreak()

=== Ergebnisse des Replay-Angriffs
Es gibt mehrere Wege, um zu prüfen, ob der Angriff erfolgreich war. Diese sind in diesem Abschnitt genauer beschrieben.

==== Prüfen des Erfolgs mithilfe von curl
Mithilfe des Tools curl, welches auch für den Replay-Angriff verwendet wurde, kann man - der Nutzer aber auch der Angreifer - auslesen, in welcher Position die Weiche 4 ist.

```
┌──(esther㉿Jellyfish-Fields)-[/mnt/c/Users/esthie]
└─$ curl -X POST "http://10.100.0.1/AJAX" -b "Session-id=84f95779b816ac86edfa7a52fc0cc97a01902eb4ea96f9b96ad63c344dfd1b15" -d "GETVARS:_local_=v3,M..1:4-1"
<rs><r i='v3' e='0' v='00'/></rs>
```

Aus dem Feld `v='00'` ist der Wert der Position der Weiche auslesbar. Vor dem Angriff war dieser auf `01` - nach dem Angriff ist er auf `00`.

==== Vergleich der physischen Position der Weiche
Als weitere Überprüfung kann man die pysische Position der Weiche vergleichen. In den nachfolgenden Bildern sieht man die Position der Weiche 4 vor (links) und nach (rechts) dem Angriff. Man erkennt, dass der Servo beziehungsweise die Gleise der Weiche ihre Position bewegt haben.

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("../assets/angriffe/replay/weiche4_pos2.png",   width: 90%) ],
        [ #image("../assets/angriffe/replay/weiche4_pos1.png", width: 90%) ],
    ),
    caption: [Vergleich der Position der Weiche 4: Links vor und rechts nach dem Angriff]
) //<glacier>

#pagebreak()

==== Log-Messages des Raspberry Pi
Im Skript am Raspberry Pi (siehe Kapitel Weichensteuerung) ist ein Feature eingebaut, welches bei Änderung der Weichen eine Log-Nachricht sendet. Im Laufe des Angriffes kam die folgende Nachricht.

`11/10/24 05:07:06 - INFO : servo Weiche4 switched to min` #footnote[Die Zeiten des Raspberry Pi sind nicht synchronisiert.]

Das bedeutet, dass der Raspberry Pi den Befehl von der SPS zum Ändern der Position der Weiche 4 erhalten hat.

=== Fazit
Aus dem durchgeführten Angriff ist ersichtlich, dass man für einen Replay-Angriff auf die SPS nicht einfach nur Pakete abfangen und erneut aussenden kann. Man benötigt eine Art der Authentifizierung - also eine valide Session - um Befehle absenden zu können.

Sollte ein Angreifer jedoch in der Lage sein, die Session-Cookies eines autorisierten Nutzers abfangen zu können, kann er ohne Probleme beliebige Befehle absenden. Dies kann mithilfe von zum Beispiel Malware geschehen oder sogar via Brute-Force.


// TODO add src https://chain.link/education-hub/replay-attack Zugriff 05.03.2025
