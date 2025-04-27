#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Fuzzing
Fuzzing kommt aus der automatisierten Softwaretestung und soll dabei zufällige Benutzereingaben in großen Mengen simulieren um so Schwachstellen zu entdecken. Fuzzing kann allerdings auch als Angriff genutzt werden, vor allem, wenn der Quellcode unbekannt ist. Dabei kann Fuzzing sowohl ein #htl3r.long[dos] als auch eine Injektion als Ziel haben.

=== Vorrausetzungen für den Angriff
Um mit dem Angriff Fuzzing ausführen zu können, wird ein Gerät innerhalb des Netzwerks benötigt, das ein Python Script mit der Libary _boofuzz_ und _argparse_ ausführen kann und Wireshark installiert hat.

=== Fuzzing Script
Im ersten Teil des Fuzzing Scripts wird eine Methode definiert, die die Modbuspakete für das Fuzzing selbst erstellt und das Fuzzing ausführt. Dabei wird angegeben, welche Werte "fuzzable" sind, also welche Werte durch zufällige andere Werte ersetzt werden sollen. In diesem Fall ist dies die Transaction ID, die Länge, die Adresse des Coils und die Daten.

#htl3r.code-file(caption: "Fuzzing Script: Methode FuzzWriteCoil", lang: "python", text: read("../assets/fuzzing/Fuzzing.py"), ranges: ((1, 18),))

Um allerdings das Fuzzing ausführen zu können, muss eine Session übergeben werden. Dieses Session wird in der Main-Methode erstellt, indem das Angriffsziel mithilfe von argparse vom User abgefragt wird. Wenn der User kein Ziel spezifizert, wird die IP-Adresse 10.100.0.11 als Angriffziel angenommen.

 #htl3r.code-file(caption: "Fuzzing Script: argparse um Angriffsziel abzufragen ", lang: "python", text: read("../assets/fuzzing/Fuzzing.py"), ranges: ((21,24),))

Nachdem das Ziel bekannt ist, wird nun ein Target, ein Ziel für den Aufbau einer #htl3r.short[tcp]-Session mit IP-Adresse und Port definiert. Mit diesem Target wird nun eine Session aufgebaut, die der vorher erstellten Methode übergeben werden kann.

 #htl3r.code-file(caption: "Fuzzing Script: Target- und Sessiondefinition", lang: "python", text: read("../assets/fuzzing/Fuzzing.py"), ranges: ((21,21),(26,29)), skips: ((22,0),))
#pagebreak()
=== Umsetztung - Fuzzing
Um das Skript aufzurufen und somit das Fuzzing zu starten, wird folgender Befehl eingegeben:
```
python3 Fuzzing.py
```
Dieser startet das Fuzzing - wie auf der Kommandozeile sichtbar wird - unverzüglich und geht alle möglichen Kombinationen mithilfe von "Test Cases" druch. In der @fuzzingstart ist dabei der erste Test Case un die Schritte zum absenden dieses Test Cases zu sehen.

#htl3r.fspace(
  [
    #figure(
      image("../assets/fuzzing/fuzzing-powershell.png", width: 110%),
      caption: "Terminalausgabe beim Starten des Fuzzing Scripts"
    ) <fuzzingstart>
  ]
)

Ein Feature von boofuzz ist es dabei auch einen Webserver lokal am Port 26000 zu starten, welcher Auskünfte über den aktuellen Fuzzing zustand gibt. Das bedeutet, man kann das Fuzzing stoppen und starten und jeden beliebigen Test Case im eigenen Tempo durchschauen kann. In der @fuzzingweb sieht man dabei den Test Case 690 und dass der Angriff derzeit läuft.
#htl3r.fspace(
  [
    #figure(
      image("../assets/fuzzing/fuzzing-web.png"),
      caption: "Fuzzing im Browser"
    ) <fuzzingweb>
  ]
)

Wenn das Fuzzing durch den Wireshark betrachtet wird, ist zu sehen, dass immer wieder #htl3r.short[tcp]-Session mit dem Ziel 10.100.0.11 aufgebaut werden, ein Modbuspaket gesendet wird und die Session wieder abgebaut wird. All dies erfolgt so schnell, so dass die Antwort nicht einmal angezeigt wird.
#htl3r.fspace(
  figure(
    image("../assets/fuzzing/wireshark-fuzzing.png"),
    caption: "Fuzzing im Wireshark"
  )
)

=== Fazit
Für den Angriff Fuzzing ist kein Verständnis der Steuerung nötig, da alle möglichen Kombinationen von Attributen ausgetestet werden. Dies macht Fuzzing zum Testen der Steueranlage auf ungewolltes Verhalten sehr brauchbar. Gleichzeitg muss der*die Angreifer*in keinen genaueren einblick in die Steuerung haben um Schaden anzustellen.