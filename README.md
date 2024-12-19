# DA-3BB/Buch
Das offizielle Repository für das Diplomarbeitsbuch "3BB - Sicherheit im Bahnnetz"

# Aufbau
Die Typst-Struktur ist in Kapitel eingeteilt. Unter "chapter/" können Kapitel erstellt werden (z.B. "fortisiem.typ"), die dann im "main.typ" File alle zusammengetragen werden. Dabei muss im main.typ file folgende Zeile für jedes Kapitel eingefügt werden:

```typst
#include "chapter/fortisiem.typ"
```