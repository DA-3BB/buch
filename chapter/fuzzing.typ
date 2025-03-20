#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Fuzzing
Fuzzing kommt aus der automatisierten Softwaretestung und soll dabei zufällige Benutzereingaben in großen Mengen simulieren um so Schwachstellen zu entdecken. Fuzzing kann allerdings auch als Angriff genutzt werden, vor allem, wenn der Quellcode unbekannt ist. Dabei kann Fuzzing sowohl ein #htl3r.long[dos] als auch eine Injektion als Ziel haben.

=== Vorrausetzungen für den Angriff
Um mit dem Angriff Fuzzing ausführen zu können, wird ein Gerät innerhalb des Netzwerks benötigt, das ein Python Script mit der Libary _boofuzz_ und _argparse_ ausführen kann und Wireshark installiert hat.


=== Fuzzing Script
Der erste Teil des Fuzzing Scripts erstellt eine Methode, die die Modbuspakete für das Fuzzing selbst erstellt und das Fuzzing ausführt. Dabei wird angegeben, welche Werte "fuzzable" sind, also welche Werte durch zufällige andere Werte ersetzt werden sollen. In diesem Fall ist dies die Transaction ID, die Länge und die Adresse des Coils.

#htl3r.code-file(caption: "Fuzzing Script: Methode FuzzWriteCoil", lang: "python", text: read("../assets/fuzzing/Fuzzing.py"), ranges: ((1, 18),))

Um allerdings das Fuzzing ausführen zu können, muss eine Session übergeben werden. Dieses wird im main erstellt, indem das Angriffsziel mithilfe von argparse vom User abgefragt wird. Wenn der User kein Ziel spezifizert, wird die IP-Adresse 10.100.0.11 als Angriffziel angenommen.

 #htl3r.code-file(caption: "Fuzzing Script: argparse um Angriffsziel abzufragen ", lang: "python", text: read("../assets/fuzzing/Fuzzing.py"), ranges: ((21,24),))

Nachdem das Ziel bekannt ist, wird nun ein Target also, ein Ziel für den Aufbau einer #htl3r.short[tcp]-Session mit IP-Adresse und Port definiert. Und danach wird mit diesem Target eine Session aufgebaut, die der vorher erstellten Methode übergeben werden kann.

 #htl3r.code-file(caption: "Fuzzing Script: Target- und Sessiondefinition", lang: "python", text: read("../assets/fuzzing/Fuzzing.py"), ranges: ((21,21),(26,29)), skips: ((22,0),))

=== Umsetztung - Fuzzing
Um das Skript aufzurufen und somit das Fuzzing zu starten, wird folgender Befehl eingegeben:
```
python3 Fuzzing.py
```
Dieser startet das Fuzzing - wie auf der Kommandozeile sichtbar wird - unverzüglich.
#htl3r.fspace(
  figure(
    image("../assets/fuzzing/fuzzing-powershell.png"),
    caption: "Terminalausgabe beim Starten des Fuzzing Scripts"
  )
)

Ein Feature von boofuzz ist es dabei auch einen Webserver lokal am Port 26000 zu Starten, welcher Auskünfte über den aktuellen Fuzzing zustand gibt.
#htl3r.fspace(
  figure(
    image("../assets/fuzzing/fuzzing-web.png"),
    caption: "Fuzzing im Browser"
  )
)

Wenn dieser Angriff durch den Wireshark betrachtet wird, ist zu sehen, dass immer wieder #htl3r.short[tcp]-Session mit dem Ziel 10.100.0.11 aufgebaut werden, ein Modbuspaket gesendet wird und die Session wieder abgebaut wird. All dies erfolgt so schnell, so dass die Antwort nicht einmal angezeigt wird.
#htl3r.fspace(
  figure(
    image("../assets/fuzzing/wireshark-fuzzing.png"),
    caption: "Fuzzing im Browser"
  )
)
