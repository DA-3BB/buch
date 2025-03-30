#import "@local/htl3r-da:0.1.0" as htl3r
#htl3r.author("Esther Lina Mayer")

= Website des HTTP-Servers auf der SPS
Im folgenden Kapitel wird die Konfiguration der Website des HTTP-Servers auf der SPS behandelt.

== Aufbau des LWE
Der LWE generiert bei neu erstellten Projekten benötigte Seiten. Diese sind in der untenstehenden Abbildung aufgelistet und werden im folgenden genauer beschrieben.

#figure(
  image("../assets/lwe/seitenuebersicht.png", width: 25%),
  caption: "Seiten des LOGO! Web-Editors"
)

In der ersten Zeile ist der Projektname (3bb-webserver) ersichtlich. Unter ihm sind die anderen Seiten des Projektes zu finden.

Pages sind die Seiten, die am HTTP-Server der SPS gehostet werden. Standardmäßig – und im Fall 3BB – existieren die beiden Seiten Login Page und Home Page. Erstere ist die Anmelde-Seite, bei welcher der User der SPS (das Passwort ist default-mäßig admin, kann aber mit der LOGO! Soft 8.4 geändert werden) sich anmeldet.

#pagebreak()

#figure(
  image("../assets/lwe/login-seite.png", width: 65%),
  caption: "Login-Seite im LOGO! Web-Editor"
)

Die zweite Seite – Home Page – ist jene, auf welche der User nach der Anmeldung weitergeleitet wird. Da diese die primäre Seite ist, wird auf sie in einem Folgekapitel detailliert eingegangen.

Neben den Pages gibt es die Global Configuration, in welcher der Tag Table von besonderer Bedeutung ist. Der IoT Thing Table ist nur in Cloud-Projekten verfügbar, was in diesem Projekt nicht der Fall ist. Im Tag Table werden die Blöcke (z.B. Merker, Inputs, …) einer Variable zugewiesen, welche dann auf den Pages referenziert werden kann. Die genaue Konfiguration befindet sich weiter unten.

Zuletzt gibt es noch den Navigator, eine Menüleiste zur Navigation zwischen den Pages. Dieser wird benötigt, wenn man mehrere Pages erstellt. Für dieses Projekt wurde davon nicht Gebrauch gemacht.

== Konfigurationen
In diesem Abschnitt wird die spezifische Konfiguration im Rahmen des Projektes 3BB genauer beschrieben.

#pagebreak()

=== Tag Table
Vorbereitend für die Home Page sollte als erstes der Tag Table mit den benötigten Variablen konfiguriert werden. Hierfür werden die vier Merker für die Weichen sowie die zwei Merker für Start und Stopp hinzugefügt. Ihnen wird ein Variablenname gegeben und ein Verweis auf den betroffenen Merker hinterlegt.
Im folgenden Bild ist die Konfiguration ersichtlich:

#figure(
  image("../assets/lwe/tagtable.png", width: 90%),
  caption: "Konfiguration der Merker im Tag Table"
)

=== Home Page
Für die Home Page werden die Components, welche der LWE zur Verfügung stellt, benötigt. Die gegebene Auswahl ist die folgende:

#figure(
  image("../assets/lwe/component.png", width: 55%),
  caption: "Komponente für den Webserver"
)

Die wichtigsten Funktionen – zumindest für den Umfang dieses Projekts – sind in der Kategorie Digital. Die beiden Buttons (Push Button und Switch Button) werden verwendet, um den Wert der Merker zu bearbeiten.

Die Push Buttons setzen den Wert des Merkers „dauerhaft“ – also bis zum nächsten Klick auf den Button, der Switch Button ändert den Wert jedoch nur kurzfristig – er schalten ihn auf True und nach kurzem Warten wieder auf False.

Die Konfiguration der Home Page kann nun mithilfe der Komponenten gestartet werden. Klickt man auf die Page, so öffnet sich eine weiße Seite. Rechts findet man die betroffenen Properties, welche als erstes betrachtet werden.

#figure(
  image("../assets/lwe/home-prop.png", width: 45%),
  caption: "Home Page - Properties"
)

Unter Styles kann man ein Hintergrundbild für die Website auswählen und die Resolution bearbeiten. In diesem Fall wird ein Bild des Bahnnetzwerks gewählt.

#figure(
  image("../assets/lwe/home-3bb.png", width: 100%),
  caption: "Home Page - Hintergrundbild"
)

#pagebreak()

Die benötigte Funktionalität der Website kann nun implementiert werden. Diese lautet wie folgt:
-	Beim Klick auf eine Weiche soll die Weiche gestellt werden.
-	Es soll einen Start-Knopf geben, welcher den Zug losfahren lässt.
-	Ebenfalls soll es einen Stopp-Knopf geben, der den Zug stehen bleiben lässt.

Es bietet sich an, die vier Weichen mit Push Buttons und den Start- sowie Stopp-Knopf als Switch Button zu konfigurieren.

Zieht man einen Push-Button auf die Seite, so kann man die Properties betrachten.

#figure(
  image("../assets/lwe/push-start.png", width: 70%),
  caption: "Default-Properties eines Push-Buttons"
)

Neben allgemeinen Punkten wie der Größe und Position des Buttons oder dem Bild des Buttons muss man die zuvor im Tag Table definierten Variablen zuweisen. Im Feld Variable Name wird der vergebene Namen des betroffenen Merkers eingetragen.

Der bearbeitete Button sieht nun wie folgt aus und kann nun auf die Position der Weiche 1 im Hintergrundbild gezogen werden.

#pagebreak()

#figure(
  image("../assets/lwe/push-done.png", width: 70%),
  caption: "Bearbeitete Properties eines Push-Buttons"
)

Die Knöpfe für die Weichen sind nun konfiguriert und man kann die Switch Buttons für Start und Stopp erstellen. Die Properties sind ident und es wird ebenfalls Design sowie der korrekte Merker eingestellt.

Weiters wurden auch ein Logo sowie ein Feld mit dem aktuellen Datum sowie Uhrzeit hinzugefügt.

#pagebreak()

Zusammen sieht der Webserver nun wie in der folgenden Abbildung aus:

#figure(
  image("../assets/lwe/finito.png", width: 100%),
  caption: "Gesamtes Design der Website"
)

== Upload auf die SPS
Um die Website auf die SPS zu spielen, benötigt die SPS eine Mikro-SD-Karte. Im LWE gibt es oben im Menü den folgenden Button:

#figure(
  image("../assets/lwe/deploy.png", width: 40%),
  caption: "Button für das Speichern auf die SD-Karte"
)

Ist der Upload abgeschlossen, so kann man die SD-Karte in die SPS stecken. Beim Anmelden auf der SPS muss nun die Checkbox „bei benutzerspezifischer Website“ (siehe nachfolgende Abbildung) ausgewählt werden.

#pagebreak()

#figure(
  image("../assets/lwe/signin.png", width: 80%),
  caption: "Anmeldung auf der SPS zur neuen Website"
)

Hat man zuvor „Angemeldet bleiben“ ausgewählt, so muss man sich abmelden, um auf die neue Website zu kommen.

In den folgenden Kapiteln wird meist der Default-Webserver der SPS für Screenshots herangezogen. Dies ist auf persönliche Präferenzen sowie den Zeitpunkt des Verfassens des jeweiligen Kapitels zurückzuführen.
