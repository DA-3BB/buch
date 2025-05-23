#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Marlene Reder")

= MODBUS
Modbus ist ein Industrieprotokollstandard der Firma Modicon, heute Schneider Electrics, der in den späten 70er Jahren auf dem Markt kam.

Es ist ein Kommunikationsprotokoll zwischen:
-	Client und Server
-	Master und Slave
- HMI / SCADA und SPS / PCLs / Sensoren
- Computern und Mess-/Regelsystemen (I/O Geräten)

Dabei ist es ein Anfrage-Antwort-Protokoll, bei dem es einen oder mehrere Client geben kann, die meistens die Kommunikation initiieren.

Es gibt drei unterschiedliche Ausführungen von Modbus:
-	Modbus/#htl3r.short[rtu]
-	Modbus/#htl3r.short[ascii]
-	Modbus/TCP

Je nach Protokoll ist die Schnittstelle zur Datenübertragung eine andere:	RS-485, RS-422, RS-232 oder TCP/IP über Ethernet.
\ \
*Vorteile von Modbus*
-	Einfachheit: Modbus ist ein vergleichsweises einfaches Protokoll.
-	Nicht properitär.
-	Flexibilität: sowohl für serielle Schnittstellen als auch für TCP/IP Netze.
\
*Nachteile von Modbus*
-	Sicherheit: Das Protokoll hat keine eingebauten Sicherheitsmechanismen und Authentifizierung mechanismen.
-	Datenkapazität: Die Datenmenge ist pro Nachricht begrenzt, das heißt Ineffizienz bei großen Datenmengen.
-	Keine dynamische Adressvergabe.
-	Keine Fehlerkorrekturmechanismen.
-	Langsam im Gegensatz zu modernen Protokollen.

===	Datenmodell
Das Datenmodell von Modbus basiert auf einer Tabellenstruktur, wobei für jede Variable beziehungsweise jeden Datentyp eine Tabelle besteht. Diese nennt man auch Register. Es gibt 4 primäre Register, dabei hatte jedes ursprünglich einen Adressbereich mit 9 999 Adressen, dieser kann allerdings auf 65 536 (2^16) Adressen erweitert werden.

#htl3r.fspace(
  figure(
    table(
      columns: 5,
      table.header(
        [*Variablen Typ*], [*Typ*], [*Objekt Typ*], [*Adressbereich*], [*Beispiel*],
      ),
      [*Coils (Discrete Output)*],
      [lesen-schreiben],
      [1 Bit],
      [00001-09999],
      [Relay],
      [*Discrete Input*],
      [lesen],
      [1 Bit],
      [10001-19999],
      [Schalter],
      [*(Analog) Input Register*],
      [lesen],
      [16 Bit/ 2 Bit],
      [30001-39999],
      [Temperatur],
      [*(Analog) Holding Register*],
      [lesen-schreiben],
      [16 Bit/ 2  Bit],
      [40001-49999],
      [Motordrehzahl],
    ),
    caption: "Modbus: wichtigste Datentypen"
  )
)

Diese Tabellen sind auf den Servergeräten gespeichert und somit eine Teilmenge des lokalen Speichers. Damit ein Modbus Client auf diese Daten zugreifen kann, muss er diese mithilfe von Funktionscodes abfragen. Wichtig ist außerdem, dass nicht alle Adressen und Register von einem Gerät benutzt werden müssen.

===	Modbus ADU
Die Modbus #htl3r.short[adu] hat je nach Kommunikationslayer einen anderen Aufbau (vergleiche die jeweiligen  Spezifikationen), die darin eingebettete #htl3r.long[pdu] hat allerdings immer die gleiche Struktur.
#pagebreak()
====	Modbus Protocol Data Unit
Es gibt drei Arten von PDUs:
-	Anfrage: MODBUS Request #htl3r.short[pdu], mb_req_pdu
-	Antwort: MODBUS Response #htl3r.short[pdu], mb_rsp_pdu
-	Antwort mit Fehlermeldung: Exception Response #htl3r.short[pdu], mb_excep_rsp_pdu
Die Modbus #htl3r.longpl[pdu] bestehen alle aus einem 1 Byte langen Funktionscode/Fehlermeldungsfeld und maximal 252 Byte für die benötigten Daten in Big-Endian Schreibweise.
#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus-pdu.jpg"),
    caption: "Modbus Protocol Data Unit"
  )
)

====	Funktionscodefeld <fehlercode>
Der Bereich an Funktionscode reicht von 1-255, wobei 128-255 für Fehlermeldungen reserviert ist. Die Funktionscodes kann man noch unterteilen in:
- öffentliche
- User definierte
- reservierte Funktionscodes

#htl3r.fspace(
  [
    #figure(
      image("../assets/modbus/modbus-funktionscode-kategorien.jpg", width: 30%),
      caption: "Modbusfunktionscode Kategorien"
    ) <mod-kategorien>
  ]
)

Funktionscodes werden benötigt, um auf die gewünschte Funktion zu verweisen und um zu wissen, welcher Datentyp abgefragt wird. Dabei hat ein Register einen oder mehrere Funktionscodes. Das ist wichtig, denn im Frame werden die Startadressen der Tabellen (z.B.: 10001& 40001) alle gleichgesetzt, das heißt ihr Präfix wird weggelassen. Je nach Hersteller unterscheidet sich dabei die Speicherzuordung, das heißt, die erste Adresse kann sowohl 0 oder aber auch 1 sein. Das wird durch den Offset bemerkbar.

Beispiel: Wenn die logische Adresse 40001 bei 0 liegt, hat die Adresse 40009 einen Offset von 8. Bei einem Offset von 9 liegt die Startadresse dementsprechend bei 1. Der Offset ist somit der Abstand zur Startposition.


Die wichtigsten Funktionscodes lauten wie folgt und beziehen sich dabei auf die vier primären Datentypen - Coils, Discrete Inputs, Input Register, Holding Register:
#htl3r.fspace(
  figure(
    table(
      columns: 2,
      table.header([*Funktionscode*],[*Funktion*]),
      [1],
      [Lesen: Coil],
      [2],
      [Lesen: Discrete Input],
      [3],
      [Lesen: Holding Register],
      [4],
      [Lesen: Input Register],
      [5],
      [Setzen / schreiben: ein Coil],
      [6],
      [Setzen / schreiben: ein Holding Register],
      [15],
      [Setzen / schreiben: mehrere Coil],
      [16],
      [Setzen / schreiben: mehrere Holding Register],
    ),
    caption: "Modbus Funktionscodes"
  )
)

Dieser Funktionscode wird bei der Antwort auch genauso wieder zurückgegeben. Es sei denn, es ist ein Fehler aufgetreten. Dann wird eine Fehlermeldung als Funktionscode zurückgegeben. Diese Fehlermeldung beeinhaltet den Funktionscode mit dem invertierten most significant Bit ist. Außerdem wird ein Fehlercode im Datenfeld zurückgegeben.
#pagebreak()
Die Fehlercode lauten:
#htl3r.fspace(
  figure(
      table(
      columns: (0.5fr, 1fr, 1.5fr),
      table.header([*Fehlercode*],[*Kurzbeschreibung*],[*Bedeutung*]),
      [1],
      [Illegal Function],
      [Der Funktionscode wurde vom Server nicht erkannt oder ist nicht erlaubt am Server.],
      [2],
      [Illegal Data Address],
      [Angeforderte Registeradresse ist nicht existent.],
      [3],
      [Illegal Data Value],
      [Ein Wert der Abfrage ist nicht zulässig für den Server.],
      [4],
      [Server Device Failure],
      [Während der Verarbeitung ist ein nicht behebbarer Fehler aufgetreten.],
      [5],
      [Acknowledge],
      [Die Verarbeitung der Abfrage dauert länger als erwartet und deshalb wird - damit nicht ein Time Out Fehler entsteht - diese Nachricht gesendet.],
      [6],
      [Server Device Busy],
      [Der Client soll die Anfrage, sobald der Server wieder Kapazitäten hat, noch einmal schicken.],
      [8],
      [Memory Parity Error],
      [Die Daten im Speicher sind beschädigt (z.B. unlesbar)],
      [10],
      [Gateway Path Unavailable],
      [Router findet das Modbus Endgerät nicht.],
      [11],
      [Gateway Target Device Failed to Respond],
      [Das Gerät, an dem die Modbus Nachricht adressiert ist, gibt keine Rückmeldung.],
    ),
    caption: "Modbus Fehlercodes"
  )
)


==== Datenfeld
Das Datenfeld beinhaltet bei der Anfrage zusätzliche Werte wie die Startadresse und die Anzahl der zu lesenden Register. Bei der Antwort enthält das Datenfeld entweder die angefragten Daten oder den oben erwähnte Fehlercode.

==== Server Anfrageverarbeitung
Das untenstehende Diagramm beschreibt, wie eine Modbus Kommunikation auf Seiten eines Servers aussieht. Dabei gibt es vier Stufen, die für die Validierung und die Ausführung der Anfrage zuständig sind. Sollte in einer dieser Stufen ein Fehler unterlaufen, wird sofort eine Antwort mit Fehlercode gesendet, ohne die weiteren Stufen zu durchlaufen. Sollte alles funktionieren, sendet der Server eine Antwort mit den geforderten Daten. \ \
Die Schritte beeinhalten:
+ Der Funktionscode wird validiert.
+ Die Speicheradresse für die Daten wird überprüft.
+ Die Datenwerte werden überprüft.
+ Die durch den Funktionscode mitgegebene Aktion wird ausgeführt.
+ Antwort mit Daten wird gesendet. \
Die Fehlercodes wurden im  @fehlercode erklärt.

#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus-slave-anfrageverarbeitung.jpg", width: 90%),
    caption: "Modbus: Server Anfrageverarbeitung"
  )
)


==	Modbus RTU
Bei Modbus #htl3r.short[rtu] werden die Signale über eine serielle Schnittstelle asynchron, im Binärformat übertragen. Asynchron bedeutet dabei, dass es keine eigene Taktleitung gibt, sondern, dass die Datenübertragung mit einem Start- und Endsignal synchronisiert wird.

Bei Modbus #htl3r.short[rtu] gibt es mehrere Schnittstellenstandards:
- RS232
- RS422
- RS485

=== Schnitstellenstandards
==== RS232
Die RS232 Schnittstelle ist die älterste, aber auch die am weitesten verbreitete. Dabei funktionert die Schnittstelle nur als Point-to-Point Verbindung, also für jedes Gerät wird ein einzelner Port benötigt. Weiters ist die empfohlene Reichweite auf 50ft beziehungsweise cirka 15 Meter beschränkt. Die Richtungsunabhängigkeit von dieser Schnittstelle ist Vollduplex, dabei hat sie aber nur eine Leitung für die Signalspannung und ist somit single ended. Das heißt, die Sende- und die Empfangsleitung sind auf eine gemeinsame Masse bezogen. Das hat zum Nachteil, dass die Leitung sehr störempfindlich ist und somit die Messspannung bei einer Störspannung die ganze Auswirkungen abbekommt. Um das zu beheben, gibt es den Ansatz des Differenzeingangs (siehe @rs422).

#htl3r.fspace(
  figure(
    image("../assets/modbus/RS232-verkabelung.jpg", width: 50%),
    caption: [RS232 Verkabelung @rs-232]
  )
)
==== RS422 <rs422>
Die Schnittstelle RS422 erlaubt im Gegensatz zum Vorgänger RS232 eine Point-to-Multipoint Verbinung mit einem Sender und bis zu 32 Empfängern. Die Schnittstelle ist dabei weiterhin Vollduplex und die Leitung kann nun bis zu 500ft beziehungsweise cirka 45m lang sein. Außerdem ist sie weniger störempfindlich, da durch die Doppelleitung sowohl für den Sender als auch für den Empfänger eine differenzielle Signalübertragung ermöglicht. Das heißt, das Singal wird in eine positive und eine negative Spannung aufgeteilt (4V = +2V - (-2V)), bei der die Differenz entscheidend ist, damit im Falle einer Störspannung, diese sich von selbst aufhebt ((+2V + 1V) - (-2V + 1V) = 4V). Außerdem sind die Adernpaare verdrillt (Twisted-Pair), was zusätzlich zur Störunempfindlichkeit beiträgt.

#htl3r.fspace(
  figure(
    image("../assets/modbus/RS422-verkabelung.jpg", width: 55%),
    caption: [RS422 Verkabelung @rs-422]
  )
)

==== RS485
Die RS485 Schnittstelle weist dieselben elektrischen Eigenschaften wie RS422 auf. Dazu kommt allerdings, dass RS485 Multipoint-to-Multipoint fähig ist. In der häufigsten Bauweise, die nur als zwei Drähten besteht ist sie jedoch nur Halbduplex fähig. Die Vollduplex Bauart mit vier  ist hingegen nur sehr selten zu finden. @serielleschnittstellen
#htl3r.fspace(
  figure(
    image("../assets/modbus/RS485-verkabelung.jpg", width: 50%),
    caption: [RS485 Verkabelung @rs-485]
  )
)

===	Aufbau #htl3r.long[adu]
Bei Modbus #htl3r.short[rtu] besteht die #htl3r.short[adu] zusätzlich zur #htl3r.long[pdu] aus einem Adressfeld und einem Error-Check-Feld mit einer zyklischen Redundanzprüfung (#htl3r.short[crc]). Außerdem gibt es zu Beginn und am Ende einer #htl3r.short[adu] immer eine mindestens 3,5 Zeichen lange Pause.

#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus-rtu-adu.jpg"),
    caption: "Modbus RTU: Application Data Unit"
  )
)

====	Adressfeld
Im Adressfeld steht immer die Adress des Servers, die bei jedem Busteilnehmer eindeutig sein muss. Dabei stehen 8 Bit - also der Bereich von 0 bis 255 - zur Verfügung, wobei 0 die Broadcast Adresse ist und die Adressen von 248 bis 255 sind laut Standart reserviert. Empfohlen ist aber nur die Verwendung von bis zu 32 Geräten. Das ergibt sich aus der möglichen Leistung der RS485-Treiberbausteine. Diese liefern nur genug Strom für 31 andere Geräte (das sendende Gerät hört auch mit - daher 32). Für mehr als 32 Teilnehmer würde man zusätzliche Leitungstreiber bzw. Repeater benötigen.
#pagebreak()
===	Kommunikationsbeispiel
+ *Clientanfrage an Server*
  - Funktionscode 1 - Anfrage einen Coil auszulesen.
  - Reference Number 1 - Adresse des Coils ist eins.
  - Bit Count 1 - Anzahl der zu lesenden Coils ist eins.

Hier in einem abgefangenen Wireshark Frame dargestellt:
#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus-query.jpg", width: 90%),
    caption: "Modbus TCP/IP - Anfrage"
  )
)

2. *Server Antwort an Client*
  - Funktionscode 1 - Anfrage hatte Erfolg, da der Funktionscode gleichgeblieben ist.
  - Byte Count 1 - Ein Byte wurde für die weiteren Daten benötigt.
  - Bit 1 : 0 - Das ausgelesene Bit hat den Wert 0 beziehungsweise False.

Hier in einem abgefangenen Wireshark Frame dargestellt:
#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus-response.jpg", width: 90%),
    caption: "Modbus TCP/IP - Antwort"
  )
)
#pagebreak()
==	Modbus ASCII
Diese Form von Modbus ist mittlerweile veraltet und wird nur noch von älteren Systemen benutzt. @asciialt
Modbus #htl3r.short[ascii] und Modbus #htl3r.short[rtu] verwenden beide serielle Schnittstellen zur Übertragung. Allerdings werden die Daten bei Modbus #htl3r.short[ascii] nicht im Binärformat, sondern in #htl3r.short[ascii]-Code übertragen. Das heißt, jedes Byte wird in zwei hexadezimal ASCII Zeichen konvertiert. Dies hat einen geringeren Datendurchsatz zur Folge.

===	Aufbau Application Data Unit
Bei Modbus #htl3r.short[ascii] ist der Aufbau sehr ähnlich zu Modbus #htl3r.short[rtu]. Zusätzlich kommt aber noch ein Doppelpunkt als Startzeichen und das #htl3r.short[crlf]-Zeichen als Endsymbol hinzu. Außerdem ist der Error-Check kein #htl3r.short[crc], sondern eine #htl3r.long[lrc] (#htl3r.short[lrc]). Die #htl3r.short[lrc] ist dabei bezüglich der Fehlererkennung schlechter, da mehrere Fehler sich aufheben können und so die Daten trotzt Fehler stimmig erscheinen können.

#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus-ascii-adu.jpg", width: 95%),
    caption: "Modbus ASCII: Application Data Unit"
  )
)
#pagebreak()
==	Modbus TCP/IP
Modbus TCP/IP ist ein Applikation Layer Protokoll, dass das Modbus #htl3r.long[pdu] in ein TCP-Packet kapselt. Es ermöglicht so die Übermittlung über ein IP-Netzwerk. Dabei wird der TCP-Port 502 verwendet und die Begriffe Master/Slave werden oft durch Client/Server ausgetauscht.
===	Aufbau #htl3r.long[adu]
Die Modbus #htl3r.short[adu] besteht bei Modbus TCP/IP aus der #htl3r.short[pdu] und aus dem #htl3r.long[mbap] Header. \ \
Der #htl3r.short[mbap]-Header besteht aus 4 Teilen:
-	Transaction Identifier: Eindeutiger, beliebig ausgewählter Wert zur Identifikation einer Modbus Kommunikation. Dieser ist vom Client ausgewählt und wird in der Antwort vom Server wiederholt.
-	Protocol Identifier: Immer 0000.
-	Länge: Kommende Byte Anzahl (von Unit Identifier bis zum Ende).
-	Unit Identifier: Server Adresse.

#htl3r.fspace(
  figure(
    image("../assets/modbus/modbus_tcp-ip_adu.jpg"),
    caption: "Modbus TCP/IP: Application Data Unit"
  )
)
===	Security
In Modbus wird sowohl der Funktionscode als auch die Daten als Plaintext übertragen und es gibt keine Security Features. Allerdings kann Modbus TCP/IP mit #htl3r.long[tls]verwendet werden. Damit werden sowohl Daten Integrität, also auch Verschlüsselung und Authentifizierung bereitgestellt. Das geschieht, indem TLS mithilfe eines Handshakes einen sicheren Tunnel aufbaut, wobei zuerst die Verschlüsselungsverfahren gewählt werden und sich dann die zwei Geräte gegenseitig mit Zertifikaten authentifizieren. Weiters wird ein session-key ausgehandelt, mit dem im weiteren Verlauf die Nachrichten bis zur Schließung der Session ver- und entschlüsselt werden.
