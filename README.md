# Das Buch der Diplomarbeit 3BB

Die Diplomarbeit "3BB - Sicherheit im Bahnnetz" wurde im Rahmen der HTL 3 Rennweg zwischen Semptember 2024 und April 2025 umgesetzt. Das Buch basiert auf der [offiziellen Typst-Vorlage der HTL 3 Rennweg](https://typst.app/universe/package/htl3r-da/). In diesem Repository sind neben den Typst-Files für das Buch auch Bilder, Grafiken und Scripts inkludiert.

![Die Topologie der Diplomarbeit 3BB](assets/topologie/topo-all-white.png)

## Kurzfassung

Die Diplomarbeit 3BB befasst sich mit der Verbindung und Absicherung von IT- und OT-Netzwerken. Dabei wird das OT-Netzwerk durch eine vernetzte Steuerung für eine Modelleisenbahn abgebildet und mit Komponenten, wie einer speicherprogrammierbaren Steuerung und Remote Terminal Units realisiert. Die Komponenten steuern die Aktoren (wie z. B. Weichen und Züge), um den Bahnverkehr zu gewährleisten. Dabei wurde eine für die Diplomarbeit individuelle Weichen- und Blocksteuerung entwickelt und implementiert. Dies dient als Trainingsumgebung für eine zukünftige OT-Security-Ausbildung.

Um ein Unternehmensnetzwerk zur Verwaltung der Eisenbahnsteuerung zu simulieren, wurde ein Active Directory konfiguriert. Die Infrastruktur besteht dabei aus zwei Standorten, mehreren Abteilungen sowie dessen Benutzerinnen und Benutzer. Auf Basis dieser Infrastruktur wird den Mitarbeiterinnen und Mitarbeitern der Zugriff auf die Steuerung der Eisenbahn ermöglicht.

Die Absicherung der beiden Netzwerke erfolgt über Firewalls. Dadurch wird der Zugriff aus dem Internet begrenzt, um das Angriffspotenzial zu verringern. Des Weiteren werden die Firewalls an den Standorten über verschlüsselte VPN-Verbindungen miteinander verbunden, um die sichere Kommunikation zwischen den Netzwerken zu gewährleisten.

Um die Sicherheit im Netzwerk zu garantieren, wurde ein Security Information and Event Management (kurz SIEM) sowie ein Security Operations Center (kurz SOC) implementiert. Das SIEM dient der Netzwerküberwachung, um Anomalien zu erkennen. Die daraufhin erkannten Sicherheitslücken werden dem SOC über Ereignisse mitgeteilt.

Die Sicherheit der Infrastruktur wird durch Angriffe auf die Probe gestellt. Zu den Angriffen zählen Aufspüren von Informationen im Netzwerk, Manipulation der Eisenbahnsteuerung und der Ausfall von kritischen Komponenten. Die Auswirkungen der Angriffe werden dabei protokolliert.

Die Diplomarbeit 3BB zeigt die Herausforderungen der Cybersicherheit für kritische Infrastrukturen auf und stellt wesentliche Verteidigungsstrategien zu ihrer Bewältigung vor.

## Abstract

The diploma thesis 3BB focuses on the connection and protection of IT and OT networks. The OT network is modeled as a railway network using components like a programmable logic controller (PLC) and remote terminal units (RTUs). The components control the actuators (such as points and trains) to ensure a safe railway traffic. A customised switch and block control system was developed and implemented as part of the thesis. As a result, the topology serves as a training environment for a future OT security course.

In the IT network, an Active Directory was configured to simulate a corporate environment for managing the railway control system. The infrastructure consists of two locations, several departments and their users. Based on this infrastructure, employees are granted controlled access to the railway control system.

The two networks are secured by Fortinet firewalls. This restricts Internet access, minimizing attack vectors and reducing cybersecurity risks. In addition, the firewalls at the sites are interconnected via encrypted VPN connections, ensuring secure communication between the networks.

Security Information and Event Management (SIEM for short) and a Security Operations Centre (SOC for short) were implemented to guarantee network security. The SIEM is used to monitor the network in order to recognise anomalies. The security gaps are then recognised and communicated to the SOC via events.

To evaluate the infrastructure's resilience, various cyberattacks are simulated. These include the detection of information in the network, manipulation of the railway control system and the failure of critical components. The impact of these attacks are thoroughly logged and analyzed.

The 3BB diploma thesis demonstrates the cybersecurity challenges facing critical infrastructure and highlights the essential defense strategies to mitigate them.

# Bibliotheksexemplar

Das Bibliotheksexemplar ist im [Releases-Tab](https://github.com/DA-3BB/buch/releases) zu finden. Um das Buch direkt aus dem Repository zu generieren wird Typst benötigt.
```sh
git clone https://github.com/DA-3BB/buch
cd buch
typst compile main.typ 3BB_Sicherheit-im-Bahnnetz.pdf
```
