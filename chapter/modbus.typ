#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Marlene Reder")
= MODBUS

== Überblick
Modbus ist ein Industrieprotokollstandard der Firma Modicon, heute Schneider Electrics, dass in den späten 70er Jahren auf dem Markt kam.

Es ist ein Kommunikationsprotokoll zwischen:
-	Client und Server
-	Master und Slave
- HMI / SCADA und SPS / PCLs / Sensoren
- Computern und Mess-/Regelsystemen (I/O Geräten)

Dabei ist es ein Anfrage/Antwort Protokoll, bei dem es einen oder mehrere Client geben kann, die meistens die Kommunikation initiieren. 

Es gibt drei Arten
-	Modbus/#htl3r.short[rtu]
-	Modbus/#htl3r.short[ascii]
-	Modbus/TCP

Je nach Protokoll ist die Schnittstelle zur Datenübertragung eine andere:	RS-485, RS-422, RS-232 oder TCP/IP über Ethernet.
\ \
*Vorteile*
-	Einfachheit: Modbus ist ein vergleichsweises einfaches Protokoll.
-	Nicht properitär.
-	Flexibilität: sowohl für serielle Schnittstellen als auch für TCP/IP Netze.
\
*Nachteile*
-	Sicherheit: Das Protokoll hat keine eingebauten Sicherheitsmechanismen /Authentifizierung.
-	Datenkapazität: Die Datenmenge ist pro Nachricht begrenzt, das heißt Ineffizienz bei großen Datenmengen.
-	Keine Dynamische Adressvergabe.
-	Keine Fehlerkorrekturmechanismen.
-	Langsam im Gegensatz zu modernen Protokollen.

===	Datenmodell 
Das Datenmodell von Modbus basiert auf einer Tabellen Struktur, wobei eine Tabelle für jede Variable/Datentyp besteht, diese nennt man auch Register. Es gibt 4 primäre Register, dabei hatte jedes ursprünglich einen Adressbereich mit 9 999 Adressen, dieser kann allerdings auf 65 536 (2^16) Adressen erweitert werden. 
 
#figure(
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
  )
)

Diese Tabellen sind auf den Server Geräten gespeichert und sind somit eine Teilmenge des lokalen Speichers. Damit ein Modbus Client auf diese Daten zugreifen kann, muss er diese mithilfe von Funktionscodes abfragen. Wichtig ist außerdem, dass nicht alle Adressen und Register von einem Gerät benutzt werden müssen.

===	Modbus #htl3r.long[adu]
Die Modbus #htl3r.short[adu] hat je nach Kommunikationslayer einen anderen Aufbau (vergleiche die jeweiligen  Spezifikationen), die darin eingebettete #htl3r.long[pdu] hat allerdings immer die gleiche Struktur. 

====	Modbus Protocol Data Unit
Es gibt drei Arten von PDUs, die alle unterschiedliche Einsatzgebiete haben:
-	MODBUS Request #htl3r.short[pdu], mb_req_pdu
-	MODBUS Response #htl3r.short[pdu], mb_rsp_pdu
-	Exception Response #htl3r.short[pdu], mb_excep_rsp_pdu
Die Modbus #htl3r.long[pdu] bestehen alle aus einem 1 Byte langen Funktionscode/Fehlermeldungsfeld und maximal 252 Byte für die benötigten Daten in Big-Endian Schreibweise.

#figure(
  image("../assets/modbus/modbus-pdu.png"),
  caption: "Modbus Protocol Data Unit"
)

====	Funktionscode <fehlercode>
Der Bereich an Funktionscode reicht von 1-255, wobei 128-255 für Fehlermeldungen reserviert sind. Die Funktionscodes selbst kann man noch unterteilen in öffentliche, User definierte und Reservierte Funktionscodes (siehe @mod-kategorien).

#figure(
  image("../assets/modbus/modbus-funktionscode-kategorien.png", width: 30%),
  caption: "Modbusfunktionscode Kategorien"
) <mod-kategorien>

Funktionscodes werden benötigt, um auf die gewünschte Funktion zu verweisen und um zu wissen, welcher Datentyp abgefragt wird. Dabei hat ein Register einen oder mehrere Funktionscodes. Das ist wichtig, denn im Frame werden die Startadressen der Tabellen (z.B.: 10001& 40001) alle gleichgesetzt, das heißt ihr Präfix wird weggelassen. Je nach Hersteller unterscheidet sich dabei die Speicherzuordung, das heißt, die erste Adresse kann sowohl 0 oder aber auch 1 sein, das wird durch den Offset bemerkbar.

Beispiel: Wenn die logische Adresse 40001 bei 0 liegt. Hat die Adresse 40009 einen Offset von 8. Bei einem Offset von 9 liegt die Startadresse dementsprechend bei 1. Der Offset ist somit der Abstand zur Startposition. 

#pagebreak()

Die wichtigsten Funktionscodes lauten wie folgt:
#figure(
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
  )
)

Dieser Funktionscode wird bei der Antwort auch genauso wieder zurückgegeben, außer es ist ein Fehler aufgetreten, dann wird eine Fehlermeldung als Funktionscode zurückgegeben, welche der Funktionscode mit dem invertierten most significant Bit ist. Außerdem wird ein Fehlercode im Datenfeld zurückgegeben.

Die Fehlercode lauten: 
#figure(
  table(
    columns: 3,
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
    [Die Verarbeitung der Abfrage dauert länger und damit nicht ein Time Out Fehler entsteht wird die Nachricht gesendet.],
    [6],
    [Server Device Busy],
    [Der Client soll die Anfrage, wenn der Server wieder Kapazitäten hat noch einmal schicken.],
    [8],
    [Memory Parity Error],
    [Die Daten im Speicher sind beschädigt (z.B. beschädigt oder unlesbar)],
    [10],
    [Gateway Path Unavailable],
    [Router findet das Modbus Endgerät nicht.],
    [11],
    [Gateway Target Device Failed to Respond],
    [Das Gerät, an dem die Modbus Nachricht adressiert ist, gibt keine Rückmeldung.],
  )
)


==== Datenfeld
Das Datenfeld beinhaltet bei der Anfrage zusätzliche Werte wie die Startadresse und die Anzahl der zu lesenden Register. Bei der Antwort enthält das Datenfeld entweder die angefragten Daten oder den oben erwähnte Fehlercode.

==== Server Anfrageverarbeitung
Das untenstehende Diagramm beschreibt, wie eine Modbus Kommunikation auf Seiten eines Servers aussieht. Dabei gibt es vier Stufen, die für die Validierung und die Ausführung der Anfrage zuständig sind. Sollte in einer dieser Stufen ein Fehler unterlaufen wird sofort eine Antwort mit Fehlercode gesendet, ohne die weiteren Stufen zu durchlaufen. Sollte alles Funktionieren, sendet der Server eine Antwort mit den geforderten Daten. \ \
Die Schritte beeinhalten:
+ Der Funktionscode wird validiert.
+ Die Speicheradresse für die Daten wird überprüft.
+ Die Datenwerte werden überprüft.
+ Die durch den Funktionscode mitgegebene Aktion wird ausgeführt.
+ Antwort mit Daten wird gesendet. \
Die Fehlercodes wurden im  @fehlercode erklärt.

#figure(
  image("../assets/modbus/modbus-slave-anfrageverarbeitung.png", width: 90%),
  caption: "Modbus: Server Anfrageverarbeitung"
)

#pagebreak()
==	Modbus #htl3r.long[rtu]
Bei Modbus #htl3r.short[rtu] werden die Signale über eine serielle Schnittstelle asynchron, im Binärformat übertragen. Asynchron bedeutet dabei, dass es keine eigene Taktleitung gibt, sondern dass die Datenübertragung mit einem Start- und Endsignal synchronisiert wird. 

Bei Modbus #htl3r.short[rtu] gibt es mehrere Schnittstellenstandards:
- RS232
- RS422
- RS485

=== Schnitstellenstandards
==== RS232 
Die RS232 Schnittstelle ist die älterste aber auch die weit Verbreiteste. Dabei funktionert die Schnittstelle nur als *Point-to-Point* Verbindung, also für jedes Gerät wird ein einzelner Port benötigt. Weiters ist die empfohlene *Reichweite* auf 50ft beziehungsweise cirka *15 Meter* beschrängt. Die Richtungsunabhängigkeit von dieser Schnittstelle ist *Vollduplex*, dabei hat sie aber nur eine Leitung für die Signalspannung und ist somit *single ended*. Das heißt die Sende und Empfansgleitung sind auf eine gemeinsame Masse bezogen. Das hat zum Nachteil, dass die Leitung sehr *störempfindlich* ist und somit bei einer Störspannung diese, die volle Auswirkung auf die Messspannung hat. Um das zu beheben git es den Ansatz des Differenzeingangs siehe @rs422.

#figure(
  image("../assets/modbus/RS232-verkabelung.png"),
  caption: "RS232 Verkabelung",
)

==== RS422 <rs422>
Die Schnittstelle RS422 erlaubt im Gegensatz zum Vorgänger RS232 eine *Point-to-Multipoint* Verbinung mit einem Sender und bis zu 32 Empfängern. Die Schnittstelle ist dabei weiterhin *Vollduplex* und die Leitung kann nun bis zu 500ft beziehungsweise cirka *45m* lang sein. Außerdem ist sie weniger störempfindlich, da durch die Doppelleitung sowohl für Sender und Empfänger eine *differenzielle Signalübertragung* ermöglicht. Das heißt, das Singal wird in einen positiven und negativen Spannung aufgeteilt (4V = +2V - (-2V)), bei der die Differenz entscheidend ist, damit im Falle einer Störspannung, diese sich von selbst aufhebt ((+2V + 1V) - (-2V + 1V) = 4V). Außerdem sind die Adernpaare verdrillt (*Twisted-Pair*), was auch noch zur Störunempfindlichkeit hinzufügt.

#figure(
  image("../assets/modbus/RS422-verkabelung.png"),
  caption: "RS422 Verkabelung"
)

==== RS485
Die RS485 Schnittstelle weißt dieselben elektrische Eigenschaften wie RS422 auf. Dazu kommt allerdings, dass RS485 *Multipoint-to-Multipoint* fähig ist, aber in der häufigsten Bauweise mit zwei Drähten nur Halbduplex fähig. Die Vollduplex Bauart mit vier Drähten nur sehr selten zu finden.

#figure(
  image("../assets/modbus/RS485-verkabelung.png"),
  caption: "RS485 Verkabelung"
)

===	Aufbau #htl3r.long[adu]
Bei Modbus #htl3r.short[rtu] besteht die #htl3r.short[adu] zusätzlich zur #htl3r.long[pdu] aus einem Adressfeld und einem Error-Check-Feld mit einer zyklischen Redundanzprüfung (#htl3r.short[crc]). Außerdem gibt es zu Beginn und am Ende einer #htl3r.short[adu] immer eine mindestens 3,5 Zeichen lange Pause.

#figure(
  image("../assets/modbus/modbus-rtu-adu.png"),
  caption: "Modbus RTU: Application Data Unit"
)
 
====	Adressfeld
Im Adressfeld steht immer die Adresse des Servers, die bei jedem Busteilnehmer eindeutig sein muss. Dabei stehen 8 Bit also der Bereich von 0 bis 255 zur Verfügung, wobei 0 die Broadcast Adresse ist und 248-255 reserviert sind. Empfohlen ist aber nur die Verwendung von bis zu 32 Geräten. Das ergibt sich aus der möglichen Leistung der RS485-Treiberbausteine. Diese liefern nur genug Strom für 31 andere Geräte (das sendende Gerät hört auch mit - daher 32). Für mehr als 32 Teilnehmer würde man zusätzliche Leitungstreiber bzw. Repeater benötigen

===	Kommunikationsbeispiel
+ *Clientanfrage an Server*
  - Funktionscode 1 - Anfrage einen Coil auszulesen.
  - Reference Number 1 - Adresse des Coils ist eins.
  - Bit Count 1 - Anzahl der zulesenden Coils ist eins.


#figure(
  image("../assets/modbus/modbus-query.png"),
  caption: "Modbus TCP/IP - Anfrage"
)

2. *Server Antwort an Client*
  - Funktionscode 1 - Anfrage hatte Erfolg, da der Funktionscode gleichgeblieben ist.
  - Byte Count 1 - Ein Byte wurde für die weiteren Daten benötigt.
  - Bit 1: 0 - Das Ausgelesene Bit hat den Wert 0 beziehungsweise False.

#figure(
  image("../assets/modbus/modbus-response.png"),
  caption: "Modbus TCP/IP - Antwort"
)

==	Modbus #htl3r.short[ascii]
Diese Form von Modbus ist mittlerweile veraltet und wird nur noch selten benutzt.
Modbus #htl3r.short[ascii] und Modbus #htl3r.short[rtu] verwenden beide serielle Schnittstellen zur übertragung. Allerdings, werden die Daten bei Modbus #htl3r.short[ascii] nicht im Binärformat sondern in #htl3r.short[ascii]-Code übertragen werden. Das heißt, jedes Byte wird in zwei hexadezimal ASCII Zeichen konvertiert, das hat einen geringeren Datendurchsatz zurfolge. 

===	Aufbau #htl3r.long[adu]
Bei Modbus #htl3r.short[ascii] ist der Aufbau sehr ähnlich zu Modbus #htl3r.short[rtu], zusätzlich kommt aber noch ein Doppelpunkt als Startzeichen und das #htl3r.short[crlf]-Zeichen als Endsymbol, außerdem ist der Error-Check kein #htl3r.short[crc], sondern eine #htl3r.long[lrc] (#htl3r.short[lrc]). Die #htl3r.short[lrc] ist dabei bezüglich der Fehlerekennung schlechter, da mehrere Fehler sich aufheben können und so die Daten trotzt Fehler stimmig erscheinen können.

#figure(
  image("../assets/modbus/modbus-ascii-adu.png"),
  caption: "Modbus ASCII: Application Data Unit"
)

==	Modbus TCP/IP
Modbus TCP/IP ist ein Applikation Layer Protokoll, dass das Modbus #htl3r.short[pdu] in ein TCP-Packet kapselt. Es ermöglicht so die Übermittlung über ein IP-Netzwerk. Dabei wird der TCP-Port 502 verwendet und die Begriffe Master/Slave werden oft durch Client/Server ausgetauscht.
===	Aufbau #htl3r.long[adu]
Die Modbus #htl3r.short[adu] besteht bei Modbus TCP/IP aus der #htl3r.short[pdu] und aus dem Modbus Application Protocol Header. Der MBAP-Header besteht aus 4 Teilen:
-	Transaction Identifier: Eindeutiger, beliebig ausgewählter Wert zur Identifikation einer Modbus Kommunikation. Dieser ist von Client ausgewählt und wird in der Antwort vom Server wiederholt.
-	Protocol Identifier: Immer 0000
-	Länge: Kommende Byte Anzahl (von Unit Identifier bis zum Ende)
-	Unit Identifier: Server Adresse

#figure(
  image("../assets/modbus/modbus_tcp-ip_adu.png"),
  caption: "Modbus TCP/IP: Application Data Unit"
)

===	Security
In Modbus wird swohl der Funktionscode als auch die Daten als Plain Text übertragen und es gibt an sich keine Security Features; allerdings kann Modbus TCP/IP mit Transport Layer Security (TLS) verwendet werden. Damit wird sowohl Daten Integrität, Verschlüsselung und Authentifizierung bereitgestellt. 
Das geschieht, indem TLS mithilfe eines Handshakes einen Sicheren Tunnel aufbaut, wobei zuerst die Verschlüsselungsverfahren gewählt werden und sich dann die zwei Geräte gegenseitig mit Zertifikaten authentifizieren. Weiters wird ein session-key ausgehandelt, mit dem im weiteren Verlauf die Nachrichten ver- und entschlüsselt werden, bis die Session geschlossen ist. 