#import "@preview/htl3r-da:1.0.0" as htl3r
#htl3r.author("Magdalena Feldhofer")

== FortiManager Administrator 7.4
Der FortiManager ist ein weiteres Produkt der Firma Fortinet, wobei hier der Fokus bei #htl3r.full[mssp] und anderen großen Unternehmen, mit einer Vielzahl von Standorten und Fortinet-Geräten, liegt. 

=== ADOMs
Eine #htl3r.full[adom] ist eine logische Abgrenzung innerhalb des FortiManagers, damit kann man unterschiedlichen Administratoren Zugriff auf nur die von ihnen verwalteten Geräte erlauben. 
\
Jede #htl3r.short[adom] hat dabei eigene Geräte und Policy Packages welche sie verwaltet und speichert, eine FortiGate kann nur einer #htl3r.short[adom] zugewiesen sein. Ein wichtiger Teil von #htl3r.short[adom]s ist jedoch, dass sie nur für jeweils eine Firmware Version einer Geräteart verwendet werden sollten. Als Beispiel: Wir sind ein #htl3r.short[mssp] und haben viele Kunden, der Kunde 3BB hat vier FortiGates im Einsatz, zwei FortiGate 60Es mit der Version 7.4.2 und zwei FortiGate 60Es mit der Version 7.6.1 Für jede Kombination aus Version (major release) und Modell sollte eine eigene #htl3r.short[adom] erstellt werden, damit es mit Scripts und Variablen nicht zu Problem kommt. Es könnte also nun die #htl3r.short[adom]s "Kunde-A_FGT60E_7-4-2", "FortiGates_3BB-v7-6" und "FortiGates_3BB-v7-4" geben. #htl3r.short[adom]s müssen aktiviert werden bevor sie erstellt werden können:

#htl3r.code-file(
  caption: "Aktivierung-ADOMs-CLI",
  filename: ["fortigate/adom-activation.conf"],
  lang: "",
  text: read("../assets/fortimanager/enable-adom.conf")
)
#htl3r.fspace(
  figure(
    image("../assets/fortimanager/create_new_adom.png", width: 110%),
    caption: "Erstellen einer neuen ADOM"
  )
)

=== Policy Packages

