# Das 3BB Diplomarbeitsbuch

# Notizen

Um alle möglichen Gedanken und Arbeitsschritte niederschreiben und auf Git verewigen zu können ohne dabei direkt in den Inhalt des Diplomarbeitsbuches einzugreifen gibt es den Ordner `notizen`. Dieser wird nicht in die Erstellung des Buches miteinbezogen und dient somit als temporäre Gedankenablage. Der Inhalt kann somit auch beliebig sein :)

# Git einrichten

1. `git clone https://github.com/DA-3BB/buch.git`
2. `cd buch`
3. Branch erstellen: `git branch <name>`
4. Branch wechseln: `git switch <name>`
5. Dateien zum Commiten hinzufügen: `git add /path/to/file`
4. Commit: `git commit -m "message"`
5. Änderungen hochladen: `git push`
6. Synchronisieren: `git pull`
8. wenn “fertig” -> Pull-Request

# Typst-Setup (Windows)

## Vorlage einbinden
1. von github mit diesem Link (https://github.com/HTL3R-Typst/htl3r-da) das Zip herunterladen
2. das Zip entpacken
3. Ordnerstruktur %appdata%/typst/packages/local/htl3r-da/0.1.0 erstellen
4. entpackter Ordner in “0.1.0” verschieben

## Visual Studio Code einrichten
1. ordner in VSC öffnen
2. extension: tinymist Typst installieren
3. (enablen)
4. zum compilen: suchleiste → command —> Typst preview

# Typst-Setup (Linux)

1. Typst mit beliebigen Package-Manager installieren (apt/dnf/pacman/...)
2. Typst-Templates in `~/.local/share/typst/packages/` hineinkopieren, oder das zugehörige Install-Script des Templates ausführen. BEACHTE: im Directory `~/.local/share/typst/packages/` werden die Unterordner beim Importieren angegeben, d.h. `#import "local/htl3r-da:0.1.0" as htl3r` ergibt folgende Ordnerstruktur: `~/.local/share/typst/packages/local/htl3r-da/0.1.0`
3. `typst compile path/to/main.typ` fürs einmalige compilen oder `typst watch path/to/main.typ` für live-preview.
4. Möglicher Editor: https://zed.dev/

# Eventuell Fonts installieren
https://fonts.google.com/specimen/Source+Code+Pro  
https://fonts.google.com/noto/specimen/Noto+Sans
