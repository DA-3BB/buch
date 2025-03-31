#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Magdalena Feldhofer")
#import "@preview/wordometer:0.1.4": word-count, total-words

#show: word-count


== FortiManager Administrator 7.4
Der FortiManager ist ein weiteres Produkt der Firma Fortinet, wobei hier der Fokus bei #htl3r.full[mssp] und anderen großen Unternehmen, mit einer Vielzahl von Standorten und Fortinet-Geräten, liegt. 

=== ADOMs
Eine #htl3r.full[adom] ist eine logische Abgrenzung innerhalb des FortiManagers, damit kann man unterschiedlichen Administratoren Zugriff auf nur die von ihnen verwalteten Geräte erlauben. 
\
Jede #htl3r.short[adom] hat dabei eigene Geräte und Policy Pakete welche sie verwaltet und speichert. Ein wichtiger Teil von #htl3r.short[adom]s ist jedoch, dass sie nur für jeweils eine Firmware Version einer Geräteart verwendet werden sollten. Als Beispiel: Wir sind ein #htl3r.short[mssp] und haben viele Kunden, der Kunde A hat acht FortiGates im Einsatz, zwei FortiGate 60Es mit der Version 7.4.2, vier FortiGate 100Es mit der Version 7.6.1 und zwei FortiGate 100Es mit der Version 7.4.2. Für jede Kombination aus Version und Modell sollte eine eigene #htl3r.short[adom] erstellt werden, damit es mit Scripts und Variablen nicht zu Problem kommt. Es könnte also nun die #htl3r.short[adom]s "Kunde-A_FGT60E_7-4-2", "Kunde-A_FGT100E_7-6-1" und "Kunde-A_FGT100E_7-4-2" geben. Erstellt werden #htl3r.short[adom]s wie folgt:

#htl3r.fspace(
  figure(
    image("../assets/fortimanager/create_new_adom.png"),
    caption: "Erstellen einer neuen ADOM"
  )
)





#total-words Words insgesamt