#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Albin Gashi")

== IT-Topologie


// SIEHE AD-CHAPTER IM GAS_FORTISIEM BRANCH! WIRD SPÄTER HIER HINEINGEMERGED

#htl3r.author("Magdalena Feldhofer")

Die physische 60E FortiGate wird mittels LAN-Kabel mit dem Switch der OT verbunden, als auch mit dem Switch der UCS. Die UCS ist ein Unified Computing System von Cisco, auf dem System laufen eine vielzahl an Virtuellen Maschinen (VMs), welche gemeinsam die IT-Seite des Netzwerkes bilden. Auf der UCS sind die VMs in unterschiedliche Vlans aufgeteilt und sehen sich so untereinander nur eingeschränkt. \

Um die Standorte Wien, Eisenstadt und das Zugnetzwerk zu verbinden, sind drei Firewalls im einsatz. Die eine Physische 60E und zwei virtuelle FortiGates in der Version 7.6. Alle drei haben ein Interface in einem Vlan, in welchem nur sie kommunizieren können, es simuliert das Internet. Dadurch, dass man Daten zwischen Standorten nicht unverschlüsselt übertragen möchte, werden IPSec VPN Tunnel zwischen den Standorten gespannt mit dem Full-Mesh Modell (jede Firewall ist mit jeder anderen verbunden).
