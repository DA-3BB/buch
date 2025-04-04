#import "@preview/htl3r-da:2.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Man in the Middle Angriff
Durch einen #htl3r.long[mitm] Angriff fängt man die Kommunikation zwischen zwei Geräten ab und schaltet sich in die Mitte, sodass alle folgenden Pakete über das Angreifergerät geschickt werden, um diese dann entweder "nur" mitzulesen oder gegebenenfalls auch zu manipulieren. \

Ein #htl3r.short[mitm] Angriff kann auf unterschiedliche Art und Weise passieren. In diesem Fall wird #htl3r.short[arp] Spoofing oder #htl3r.short[arp] Request Poisoning verwendet um den Datenverkehr abzufangen. Dabei werden #htl3r.short[arp] Request mit der IP-Adresse des anzugreifenden Geräts in LAN gesannt, um dem MAC-Adress-Table zu ändern. Ziel dabei ist, die eigene MAC-Adresse mit der IP-Adresse von einem anderen Gerät im Netzwerk zu assozieren. \
Dadurch, dass Modbus alle Daten ohne Authentifizierung im Plaintext verschickt, kann der Datenverkehr sofort nach einem #htl3r.short[mitm] Angriff mit dem Wireshark mitgelesen werden. \

=== Vorraussetzungen und Tools für den MITM Angriff
Um den Man in the Middle Angriff durchführen zu können, wird zuallererst Zugang zum LAN benötigt. Dies kann durch eine offene Schnittstelle, z.B. einen Port an einem Switch oder ein komprimiertes Netzwerkgerät erfolgen. \

Weiters wird auf dem Angreifergerät eine Kali-Linux Distribution in einer #htl3r.long[vm] oder als Hostbetriebssystem benötigty, da für den Angriff die vorinstallierten Tools Ettercap, Etterfilter und Wireshark verwendet werden. \

==== Ettercap
Ettercap ist ein Multifunktionstool, mit dessen Hilfe Man in the Middle-Angriffe durchgeführt werden können, um Sniffing, Filtering und Einspeisung von malizösen Daten zu erreichen. Ettercap wird im @umsetztung-mitm mit folgenden Optionen verwendet. \

#htl3r.fspace(
  figure(
    table(
      columns: 3,
      table.header(
        [*Option*], [*Parameter*], [*Funktion*],
      ),
      [-T], [], [Für eine reines Textinferface.],
      [-s], [\'lq\'], [Gibt eine Liste mit allen Hosts im Netzwerk zurück.],
      [-F], [\<File>], [Ein Filter für den Traffic kann angegeben werden.],
      [-M], [#htl3r.short[arp]], [Man in the Middle Angriff, in diesem Fall #htl3r.short[arp] Spoofing.]
      ),
      caption: "Verwendete Optionen von Ettercap",
  )
)
Weiters können mithilfe von Schrägstrichen die Ziele nach MAC-Adresse, IP-Adresse und Port angegeben werden.
```
/MAC/IPs/PORT
```
Ein Beispiel für eine spezifische IP-Adresse und ohne spezifischen Port und ohne spezifischer MAC-Adresse ist:
```
//10.100.0.1/
```
Ein Beispiel für einen spezifischen Port ohne spezifische MAC- und IP-Adresse ist:
```
///502
```

==== Etterfilter
Etterfilter ist eine erweiterte Funktion von Ettercap mihilfe dessen Filter für Ettercap compiled werden können. Hierbei werden folgende Optionen -o verwendet, um die Ausgabedatei zu spezifizieren.

==== Wireshark
Wireshark wird hierbei zusätzlich verwendet, um den Traffic beim Angriff genauer zu inspizieren und mitzuverfolgen.

=== Umsetzung - Man in the Middle-Angriff <umsetztung-mitm>
Bevor der Angriff gestartet wird, wird geschaut ob sich die zu angreifenden Ziele im Netzwerk befinden. Dabei wird in der Kali-Linux-#htl3r.short[vm] folgender Befehl ausgeführt:

```bash
  ettercap -T -s 'lq'
```
Dabei kann in der @hostscan erkannt werden, dass vier Geräte im Netzwerk gefunden wurden. Nachdem der Netzaufbau bekannt ist können die IP-Adressen auch gleich den Geräten zugeordnet werden, ein*e Angreifer*in ohne dieses Wissen kann dies einfach durch durchtesten ausprobieren. 

#htl3r.fspace(
  [
    #figure(
      image("../assets/mitm/mitm-hostscan.png"),
      caption: "Hostscan mit ettercap"
    ) <hostscan>
  ]
)

Nach dem Scan kann auch schon mit dem #htl3r.short[mitm]-Angriff und somit dem #htl3r.short[arp] Spoofing begonnen werden. Dabei werden im ersten Schritt die Pakete noch nicht modifiziert sonder nur zum mitlesen abgefangen und weitergeleitet.

```bash
  ettercap -T -M arp //10.100.0.1/ //10.100.0.11/
 ```

Der Output des Befehls gibt gleich mehrere Informationen preis. Einerseits auf welchem Interface der Angriff stattfindet.
#htl3r.fspace(
  figure(
    image("../assets/mitm/mitm-1.png"),
    caption: "Ausgabe MITM Angriff: Interface"
  )
)

Andererseits, beide Angriffsziele im Netzwerk gefunden wurden und das #htl3r.short[arp] Spoofing begonnen hat.

#htl3r.fspace(
  figure(
    image("../assets/mitm/mitm-2.png"),
    caption: "Ausgabe MITM Angriff: Angriffsziele"
  )
)

Und als letztes werden fortlaufend alle Pakete im Terminal abgebildet die bei der Kommunikation abgefangen wurden.

#htl3r.fspace(
  figure(
    image("../assets/mitm/mitm-3.png"),
    caption: "Ausgabe MITM Angriff: abgefangene Pakete"
  )
)


Das #htl3r.short[arp] Spoofing kann auch mittels Wireshark angeschaut werden. Die @arp1 zeigt den ersten Teil des #htl3r.short[arp] Spoofing. Dabei schickt das Kali-Linux Gerät, in diesem Fall die _VMware..._, #htl3r.short[arp]-Request zu den IP-Adressen aus dem Ettercap Befehl.  Die Geräte, genauer gesagt die SPS und die #htl3r.short[rtu], die die IP-Adressen 10.100.0.1 und 10.100.0.11 besitzen antworten.

#htl3r.fspace(
  [
    #figure(
      image("../assets/mitm/wireshark-arp-spoofing_teil1.png"),
      caption: "ARP Request Posioning - Teil 1"
    )
   <arp1>
  ]
)

Im nächsten Schritt sendet die Kali-Linux-#htl3r.short[vm] #htl3r.short[arp] Antworten an das jeweilige andere Gerät, um vorzutäuschen, dass die IP-Adresse beim Angreifer*in terminiert.

#htl3r.fspace(
  figure(
    image("../assets/mitm/wireshark-arp-spoofing_teil2.png"),
    caption: "ARP Request Posioning - Teil 2"
  )
)

Nun werden wie in @spooferfolg gezeigt die Modbuspakete über den Angreifer geleitet und somit war der Angriff erfolgreich.

#htl3r.fspace(
  [
    #figure(
      image("../assets/mitm/wireshark_mitm.png"),
      caption: "Wiresharkauszug von einem erfolgreichen MITM-Angriff"
    )
    <spooferfolg>
  ]
)

Um den Datenstrom nun nicht nur mitlesen zu können, sondern ihn auch zu verändern, wird ein Filter erstellt. Dieser beeinhaltet eine Abfrage nach einem Modbus Paket. Weiters wird abgefragt ob in diesem Modbus Paket ein Coil eingeschalten wird. Sollte dies der Falls sein, wird das Paket so verändert, dass das Paket den Coil aus- statt einschaltet.

#htl3r.code-file(lang: "c", text: read("../assets/mitm/coil-true-to-false.filter"), caption: "Filter für eine Coiländerung")

Damit der Filter bei Ettercap angegeben werden kann, muss er noch in eine Binärdatei umgewandelt werden. Dies wird mit dem Tool Etterfilter erreicht,indem die vorher erstellte Filterdatei und ein Ausgabefile angegeben werden.

```bash
  etterfilter /usr/share/ettercap/3bb/coil-true-false.filter -o coil-true-to-false.ef
```

#htl3r.fspace(
  figure(
    image("../assets/mitm/terminal-create-filter.png"),
    caption: "Etterfilter generieren"
  )
)

Nun kann der #htl3r.short[mitm]-Angriff erneut mit dem Filter ausgeführt werden.

```bash
  ettercap -T -F coil-true-to-false.ef -M arp //10.100.0.1/ //10.100.0.11/
```

#htl3r.fspace(
  figure(
    image("../assets/mitm/arp-posioning-filter.png"),
    caption: "MITM durch ARP Spoofing mit einem Filter"
  )
)

In Wireshark kann nun beobachtet werden, dass alle Modbuspakete mit einem _Write Single Coil_ Funktionscode als Datenwert _FALSE_ beziehungsweise 0 haben.

#htl3r.fspace(
  figure(
    image("../assets/mitm/mitm-coil-false.png", width: 120%),
    caption: "MITM mit einem Filter im Wireshark"
  )
)

=== Fazit
Ein #htl3r.long[mitm] Angriff ist bei Busprotokoll, wie in dem Fall Modbus TCP sehr erfolgreich, da die übermittelten Daten im Plaintext und ohne Authentifizierung einfach zum Mitlesen un Manipulieren sind, gleichzeitg aber einen enormen Schaden am System anrichten können.