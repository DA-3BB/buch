#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Esther Lina Mayer")

= Weichensteuerung
Dieses Kapitel befasst sich mit der Steuerung der Weichen und den Komponenten, welche dafür benötigt werden. Diese Komponenten sind

#figure(
    table(
        columns: (25%,15%,25%),
        table.header(
            [*Gerät*], [*Adresse*], [*Funktion*],
        ),
        [Siemens LOGO! SPS],[10.100.0.1],[Modbus-Client],
        [Raspberry Pi],[10.100.0.2],[Modbus-Server],
        [Servo 1 bis 4],[Coil 1 bis 4],[Stellen der Weichen], // maybe mehr zeilen basteln
    ),
    caption: [Komponenten aus Betrachtungssicht der Weichensteuerung]
)

Die #htl3r.short[sps] verarbeitet die Nutzeranfragen - den Befehl zum Umschalten der Weichen - und sendet das Kommando an den Raspberry Pi via Modbus/#htl3r.short[tcp]. Der Raspberry Pi fungiert als Übersetzer, indem er aus den Befehlen der #htl3r.short[sps] (diese sind Wahrheitswerte - entweder `true` oder `false`) passende Befehle für die Servos (diese arbeiten mit Pulsweitenmodulation) erzeugt.

== Konfiguration der Siemens LOGO! SPS
Die Konfigurationen, welche auf der #htl3r.short[sps] getätigt werden müssen, sind minimal. Das Programm selbst ist sehr einfach gehalten. Das grundlegende Konzept ist, dass jeder Eingang entweder 0 oder 1 empfängt und das direkt an den Raspberry Pi weiterschickt.

Die Kommunikation der #htl3r.short[sps] läuft ausschließlich über den Ethernet-Adapter und somit das LAN. Daher können die physischen Ein- und Ausgänge der #htl3r.short[sps] nicht im Programm verwendet werden. Stattdessen werden Merker als Eingänge und Netzwerkausgänge als Ausgänge verwendet.

#pagebreak()

#figure(
  image("../assets/python_programm/sps/logo_software.png", width: 50%),
  caption: "Ausschnitt des Programms der SPS - Weichensteuerung"
)

Jeder Merker (`M1` bis `M4`) ist einem Netzwerkausgang (`NQ1` bis `NQ4`) zugeordnet, welcher wiederum einem Coil auf dem Raspberry Pi zugewiesen ist.

Das gesamte Programm auf der #htl3r.short[sps] ist im Kapitel Blocksteuerung genauer beschrieben. Für die Weichensteuerung ist jedoch nur der im obigen Bild ersichtliche Teil notwendig.

== Konfiguration des Raspberry Pi
Auf dem Raspberry Pi befinden sich verschiedene Skripte (Python beziehungsweise Bash), welche für die Weichensteuerung entscheidend sind und den Raspberry Pi zum Modbus-Server werden lassen. Diese werden im folgenden Abschnitt einzeln beschrieben.

#pagebreak()

=== Vorbereitung des Raspberry Pi
Für die Vorbereitung des Raspberry Pi wurden drei einfache Skripte verfasst, welche die grundlegenden Einstellungen für die eigentlichen Skripte setzen.
1. `install.sh` erzeugt das Verzeichnis `/opt/3bb/modbus` und kopiert benötigte Skripte in das neu erstellte Verzeichnis#footnote[Das Skript kopiert von z.B. dem Downloads-Folder in den global nutzbaren Ordner.]. So kann man das Skript systemweit nutzen.
2. `update.sh` wird verwendet, aktualisierte Skripte in das vorhandene Verzeichnis zu kopieren.
3. `prep_python.sh` bereitet das virtuelle Environment (#htl3r.short[venv]) für Python vor und installiert benötigte Pakete.

=== Konfigurationsdatei für den Modbus-Server
Die Konfiguration des Modbus-Servers am Raspberry Pi kann mithilfe der Konfigurationsdatei `3bb_cfg.json` bearbeitet werden. Neben allgemeinen Einstellungen des Modbus-Servers (wie zum Beispiel der IP-Adresse des Clients oder dem Port) befindet sich hier die Konfiguration der Servos.

#htl3r.code-file(
  caption: "3bb_cfg.json - Ausschnitt einer Servo-Konfiguration",
  filename: [3bb_cfg.json],
  lang: "json",
  ranges: ((22, 32),),
  text: read("../assets/python_programm/script/3bb_cfg.json")
)

#pagebreak()

Im obigen Ausschnitt der Konfigurationsdatei befindet sich die Konfiguration der Optionen für Weiche 1. In Zeile 24 bis Zeile 27 befindet sich die Konfiguration des Servos selbst. Der `pin` ist der Steckplatz auf dem Servohat des Raspberry Pi, die Optionen `maxPw` und `minPw` sind die Werte, welche via Pulsweitenmodulation die Position der Servos bestimmen. In Zeile 29 und 30 ist die Zuordnung vom Servo zum Coil an der #htl3r.short[sps] festgelegt.

In Zeile 24 befindet sich die Bezeichnung `gpio` - diese wird in den folgenden Skripten als `i2c` bezeichnet, da der Servo-Hat des Raspberry Pi mit diesem Protokoll kommuniziert. Die Bezeichnung ist eine Verallgemeinerung für bessere Lesbarkeit.

=== Konfiguration des Modbus-Servers mithilfe von Python
Das wichtigste Skript am Raspberry Pi ist das Skript `modbus_server.py`, welches einen Modbus-Server aufsetzt und die #htl3r.short[i2c]-Treiber für die Servos lädt, um die Servos zu steuern. Im Skript gibt es neben der regulären Implementierung auch eine "Dummy"-Implementierung - ohne Initialisierung der #htl3r.short[i2c]-Treiber. Im folgenden Abschnitt ist das Skript genauer beschrieben.

#htl3r.code-file(
  caption: "modbus_server.py - Globale Variablen",
  filename: [modbus_server.py],
  lang: "python",
  ranges: ((17, 23),),
  text: read("../assets/python_programm/script/modbus_server.py")
)

In dem oben gezeigten Abschnitt sind die globalen Variablen des Skripts definiert.
- Die Zeile `host = '0.0.0.0'` definiert den Client, auf welchen der Raspberry Pi lauscht, in diesem Fall hört er auf "alle".
- Der `port = 502` definiert den Standard-Modbus-Port.
- Die Konfigurationsdatei wird mit der Option `cfg_json_file = "3bb_cfg.json"` an das Programm übergeben. Dieses File kann mit der Konfigurationsdatei überschrieben und somit bearbeitet werden.
- Für das Logging wurde das Loglevel `DEBUG` gewählt. Die Methode, welche das Logging definiert, wird im folgenden Abschnitt aus Gründen der Übersichtlichkeit nicht behandelt. Sie basiert auf dem Package `PyLog`.

#pagebreak()

#htl3r.code-file(
  caption: "modbus_server.py - Dummy zum Testen der Konnektivität zur SPS",
  filename: [modbus_server.py],
  lang: "python",
  ranges: ((62, 80),),
  text: read("../assets/python_programm/script/modbus_server.py")
)

Die Klasse `modBusDummyServant` dient dazu, die Verbindung zwischen der #htl3r.short[sps] und dem Raspberry Pi zu testen. Der Server hört hierbei auf Anfragen der #htl3r.short[sps], initialisiert dabei aber keine #htl3r.short[i2c]-Treiber der Servos. Wenn der Modbus-Server Pakete der #htl3r.short[sps] erhält, werden Log-Nachrichten auf der Konsole ausgegeben.

#pagebreak()

#htl3r.code-file(
  caption: "modbus_server.py - Initialisierung der Servos",
  filename: [modbus_server.py],
  lang: "python",
  ranges: ((83, 104),),
  text: read("../assets/python_programm/script/modbus_server.py")
)

In der Klasse `modBusServant` wird die Methode `do_init_servos()` (ab Zeile 90) definiert. In dieser wird Information aus der Konfigurationsdatei eingelesen und für jeden Servo ein neues Objekt erstellt - der Vorgang wird gelogged. Die Methode `update()` (ab Zeile 102) wird aufgerufen, um den einem Servo zugeordneten Coil zu setzen und somit die Position zu verändern.

#pagebreak()

#htl3r.code-file(
  caption: "modbus_server.py - Servo-Objektdefinition",
  filename: [modbus_server.py],
  lang: "python",
  ranges: ((107, 133),),
  text: read("../assets/python_programm/script/modbus_server.py")
)

In diesem Ausschnitt wird ein (einzelner) Servo definiert. Die Funktion `__init__()` erzeugt ein neues Objekt mit den gelisteten Variablen, die Funktion `do_init()` setzt die Variablen mit den aus der Konfigurationsdatei gelesenen Werten. Die Methode `do_change()`, setzt die Position des Servos gemäß dem Parameter `new_value` entweder auf `min` oder auf `max`. Der Schaltvorgang wird gelogged.

#pagebreak()

Alle zuvor genannten Klassen und Methoden werden zusammen in der `main()`-Methode aufgerufen. Diese lautet wie folgt.

#htl3r.code-file(
  caption: "modbus_server.py - Argumente beim Aufruf des Skripts",
  filename: [modbus_server.py],
  lang: "python",
  ranges: ((155, 160),),
  text: read("../assets/python_programm/script/modbus_server.py")
)

In diesem Abschnitt des Skripts werden die Optionen, die vom User beim Aufrufen des Skripts mitgegeben werden, genauer beschrieben. Die beiden Argumente sind:
- `--cfg-file`, welches erlaubt, eine eigene Konfigurationsdatei an das Programm zu übergeben, sowie
- `-test`, um den "Dummy"-Betrieb zu starten.

#pagebreak()

Zwischen dem obigen und dem folgenden Codeausschnitten befinden sich diverse Log-Einträge, die aus Gründen der Übersichtlichkeit in diesem Abschnitt nicht gelistet werden.

#htl3r.code-file(
  caption: "modbus_server.py - Aufrufen der Methoden",
  filename: [modbus_server.py],
  lang: "python",
  ranges: ((212, 223),),
  text: read("../assets/python_programm/script/modbus_server.py")
)

In dem oben geliseten Abschnitt wird der Server initialisiert - im Testbetrieb mit der Methode `modBusDummyServant()` oder im Normalbetrieb mit der Methode `modBusServant()`. Anschließend - in Zeile 218 - werden die Servos initialisiert. Schlussendlich wird der Server gestartet.

#pagebreak()

Da nun die wichtigsten Skripte erklärt wurden, kann der Server gestartet werden. Dafür sorgt das folgende Hilfsskript:

#htl3r.code-file(
  caption: "Skript zum Starten des Servers",
  filename: [3bb-start-raspberry-modbusserver-for-trackswitching.sh],
  lang: "bash",
  // ranges: ((212, 223),),
  text: read("../assets/python_programm/script/3bb-start-raspberry-modbusserver-for-trackswitching.sh")
)

Das Skript wechselt in das mithilfe des `prep_python.sh` erstellte virtuelle Environment und führt das Skript `modbus_server.py` mit der Konfigurationsdatei `3bb_cfg.json` aus.

Für das obige und das folgende Skript sorgt `deactivate` in Zeile 4 beim Abbruch des Skripts für das sichere Beenden des Skripts.

Im Python-Skript `modbus_server.py` wurde der "Dummy"-Aufruf des Skripts beschrieben. Dieser kann mit dem folgenden Skript ausgeführt werden.

#htl3r.code-file(
  caption: "Skript zum Starten des Dummy-Servers",
  filename: [test-modbusserver-no-servos.sh],
  lang: "bash",
  ranges: ((212, 223),),
  text: read("../assets/python_programm/script/test-modbusserver-no-servos.sh")
)

Das Skript funktioniert wie das zuvor genannte Skript zum Starten des Servers, jedoch wird die Option `-test` (Zeile 3) beim Aufruf hinzugefügt. Die Servo-Objekte werden nicht initialisiert. Man kann die Kommunikation zwischen der #htl3r.short[sps] und dem Raspberry Pi nun testen, ohne dass man auf die Servos achten muss.

#pagebreak()

Neben dem Skript zum Testen der Kommunikation zwischen dem Raspberry Pi und der #htl3r.short[sps] gibt es ein weiteres Skript, welches dazu dient, die Verbindung zu den Servos zu testen. Dieses wurde in Python geschrieben und ähnelt `modbus_server.py`.

Das Skript schickt an alle in der Konfigurationsdatei `3bb_cfg.json` definierten Servos abwechselnd den Wert `True` oder `False` als Simulation der Funktion der SPS.

#htl3r.code-file(
  caption: "modbus_client.py - Skript zum Testen der Servos",
  filename: [modbus_client.py],
  lang: "python",
  ranges: ((46, 53),),
  text: read("../assets/python_programm/script/modbus_client.py")
)

Im obigen Ausschnitt findet sich eine Endlosschleife, welche jeden Servo aus der Konfigurationsdatei durchgeht, um ihm den neuen Wert `test_value` - welcher `True` oder `False` beträft - zuzuweisen. Am Ende der Schleife#footnote[Dieser Teil wurde aus Gründen der Übersichtlichkeit hier nicht gezeigt] befindet sich der Teil, welcher die Variable `test_value` vom einen Wert zum anderen welchselt.

Aufrufen kann man das Python-Programm mit dem folgenden Skript:

#htl3r.code-file(
  caption: "Skript zum Starten des Servo-Test-Servers",
  filename: [3bb-test-client.sh],
  lang: "bash",
  ranges: ((1, 4),),
  text: read("../assets/python_programm/script/3bb-test-client.sh")
)

#pagebreak()

=== Debugging des Skripts

Ein Problem mit dem Skript für den Modbus-Server kann auftreten, sollte es nicht korrekt beendet werden. Dies kann geschehen, wenn man das Programm nicht stoppt (`^C`) und die Stromversorgung zur Schaltung absteckt. Das Python-Programm kann den Prozess nicht korrekt beenden#footnote[Wenn das Skript planmäßig beendet wird, so wird im Bash-Skript ein `deactivate` ausgeführt.] und blockiert damit den Port `502`, welcher jedoch benötigt wird, um das Skript zu starten. Empfehlenswert ist es also, vor dem Abstecken der Stromversorgung das Programm zu beenden. Sollte man das vergessen, kann man das Problem mit den folgenden Befehlen lösen.

1. Mit dem Befehl `sudo netstat -tlpn` kann man den Prozess auslesen, welcher von Python gestartet wurde. Hier muss man die Prozess-ID notieren.
2. Im nächsten Schritt wird der Prozess mit `sudo kill PID` beendet. `PID` wird mit der ausgelesenen Prozess-ID ersetzt.

Nun kann das Programm ohne Probleme gestartet werden.

#pagebreak()

== Beispielablauf der Weichensteuerung
Im folgenden Abschnitt ist eine Demonstration der Weichensteuerung mit den zuvor beschriebenen Skripten dargestellt.

Als erstes wird das Skript `3bb-start-raspberry-modbusserver-for-trackswitching.sh` am Raspberry Pi gestartet.

```
root@raspberrypi:/home/admin/3bb_mod_bus# 3bb-start-raspberry-modbusserver-for-trackswitching.sh
+------------------------------------------------------------+
| config file: /opt/3bb/modbus/3bb_cfg.json                  |
| log file:    /opt/3bb/modbus/3bb_server.log                |
| log Level:   info                                          |
+------------------------------------------------------------+
+------------------------------------------------------------+
| Server IP:   0.0.0.0                                       |
| Server Port: 502                                           |
+------------------------------------------------------------+
11/10/24 05:06:34 - INFO : initialising Servo Weiche1 gpio pin 14, min PW: 1200.0ms max PW:1050.0ms
11/10/24 05:06:34 - INFO : initialising Servo Weiche2 gpio pin 15, min PW: 1300.0ms max PW:1100.0ms
11/10/24 05:06:34 - INFO : initialising Servo Weiche3 gpio pin 13, min PW: 1200.0ms max PW:1000.0ms
11/10/24 05:06:34 - INFO : initialising Servo Weiche4 gpio pin 12, min PW: 1230.0ms max PW:1080.0ms
11/10/24 05:06:34 - INFO : {0: <__main__.Servo object at 0x7fa9ef3b10>, 1: <__main__.Servo object at 0x7fa9ebc150>, 2: <__main__.Servo object at 0x7fa9c04710>, 3: <__main__.Servo object at 0x7fa9c04850>}
11/10/24 05:06:34 - INFO : starting modbusserver 0.0.0.0:502
11/10/24 05:06:34 - INFO : connect Servant to ThreeDB Object
```

In Zeile 17 ist ersichtlich, dass der Raspberry Pi eine neue Verbindung zu einem Client - der #htl3r.short[sps] - aufgebaut hat. Der Server ist also nun funktionsbereit.

#pagebreak()

Man kann nun den Webserver der #htl3r.short[sps] von einem Management-PC starten. Die Addressierung lautet: `http://10.100.0.1`. Es öffnet sich eine Seite, auf der der Nutzer sich authentifizieren muss. Das Passwort für den User "Web User" ist auf dem Default-Wert ("admin") belassen worden.

#figure(
  image("../assets/python_programm/sps/login.png", width: 80%),
  caption: "Ausschnitt des Webservers der SPS - Login-Seite"
)

In diesem Beispieldurchlauf wird die Weiche 4 bearbeitet. Um das zu initialisieren, wird im Tab "LOGO! Variablen" beziehungsweise unter `http://10.100.0.1/logo_variable_01.html` der Wert des Merkers 4 von `false` auf `true` geändert.

In den folgenden beiden Bildern befindet sich Screenshots aus dem "LOGO! Variablen"-Tab der #htl3r.short[sps]. Man beachte, dass Merker 4 in der letzten Zeile vom Wert false auf den Wert true gesetzt wird.

#figure(
  image("../assets/python_programm/sps/weiche4_false.png", width: 80%),
  caption: "Ausschnitt des Webservers der SPS - Merker 4 mit Wert false"
)

#figure(
  image("../assets/python_programm/sps/weiche4_true.png", width: 80%),
  caption: "Ausschnitt des Webservers der SPS - Merker 4 mit Wert true"
)

#pagebreak()

Beim Ändern des Merkers wird der zugehörige Coil vom entsprechenden Merker am Raspberry Pi angesprochen. Man kann den Schaltplan der Weiche 4 betrachten:

#figure(
  image("../assets/python_programm/sps/logo_weiche4.png", width: 60%),
  caption: "Ausschnitt des Programms der SPS - Weiche 4"
)

Wird der Merker 4 geändert, wird ein Modbus-#htl3r.short[tcp]-Paket an den Raspberry Pi (10.100.0.2) auf Coil 4 gesendet. Im Programm des Raspberry Pi wird dem Coil 4 der zugehörige Servo-Pin zugewiesen. Empfängt er also ein Paket auf Coil 4, so ändert er den Servo der Weiche 4. Die Log-Nachrichten lauten wie folgt:

```
11/10/24 05:07:14 - INFO : servo Weiche4 switched to min
11/10/24 05:07:18 - INFO : servo Weiche4 switched to max
```

Der Zustand der Weiche 4 wurde also von "min" auf "max" geschalten. Weiters kann man den physischen Zustand der Weiche 4 vergleichen.

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("../assets/python_programm/img/weiche4_pos2.png",   width: 90%) ],
        [ #image("../assets/python_programm/img/weiche4_pos1.png", width: 90%) ],
    ),
    caption: [Vergleich der Position der Weiche 4]
) //<glacier>
