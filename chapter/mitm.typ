#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Marlene Reder")

== Man in the Middle Angriff
=== Theoretische Grundlagen
grundsätzlich plaintext und ohne authentifiziereung des wegen schon mit wireshark kommunikation anschaubr
#htl3r.info("WAS IST MAN IN THE MIDDLE")

=== Vorrausetztungen für den Angirff
Kali VM
Wireshark and Ettercap
Terminal
zugang zum netzwerk

=== Umsetztung - Man in the Middle
Wiresharke siehe nur traffic zu eigenen host??? \ 
erreichbarkeit testen von beiden geräten ???? \
kann man mit terminal herrausfinden welche hosts exitieren????
#figure(
  image("../assets/mitm/ping_wireshark.png")
)

ettercap mit befehle 
```
ethercap befhele wie posioining
```

Wireshark wied der angriff ausschaut und genauer in die pakete und beschreiben was ist
#figure(
image("../assets/mitm/wireshark_mitm.png"),
  caption: "Hallo"
)

#figure(
  image("../assets/mitm/wireshark_destchange.png"),
  caption: "Hallo"
)

#figure(
  image("../assets/mitm/wireshark_duplicated.png"),
  caption: "Hallo"
)


um traffic zu ändern Filter datei:

```c
if (ip.proto == TCP && tcp.dst == 502) {
    	if (search(DATA.data, "\xff\x00")) {
		msg( "Found \xff\x00");
		replace( "\xff\x00", "\x00\x00" );
	}
}

```

filter anwenden bei posioining
etherfilter um werte zu ändern

```
befhel filter angewendet
```

Wireshark jetzt 0 mit filter statt 1 beides herzeigen???
erfolg

=== Fazit ???

=== Quellen --> irgendwo anders hin???
https://www.geeksforgeeks.org/ettercap-sniffing-and-spoofing/ \
https://charlesreid1.com/wiki/Ettercap
PDF