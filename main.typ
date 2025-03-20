#import "@preview/htl3r-da:1.0.0" as htl3r

#show: htl3r.diplomarbeit.with(
  title: "3BB",
  subtitle: "Sicherheit im Bahnnetz",
  department: "ITN",
  school-year: "2024/2025",
  authors: (
    (name: "Albin Gashi", supervisor: "Christian Schöndorfer", role: "Projektleiter"),
    (name: "Magdalena Feldhofer", supervisor: "Christian Schöndorfer", role: "Stv. Projektleiter"),
    (name: "Marlene Reder", supervisor: "Richard Drechsler", role: "Mitarbeiter"),
    (name: "Esther Lina Mayer", supervisor: "Richard Drechsler", role: "Mitarbeiter"),
  ),
  supervisor-incl-ac-degree: (
    "Prof, Dipl.-Ing. Christian Schöndorfer",
    "Prof, Dipl.-Ing. Richard Drechsler",
  ),
  sponsors: (
    "easyname GmbH",
    "Fortinet Austria GmbH",
    "HTL 3 Rennweg",
  ),
  abstract-german: [#include "chapter/kurzfassung.typ"],
  abstract-english: [#include "chapter/abstract.typ"],
  date: datetime.today(),
  print-ref: true,
  generative-ai-clause: none,
  abbreviation: yaml("abbr.yml"),
  bibliography-content: bibliography("refs.yml", title: [Literaturverzeichnis])
)

#include "chapter/einleitung.typ"

#include "chapter/topologie.typ"

#include "chapter/ot-topologie.typ"

#include "chapter/modbus.typ"

#include "chapter/port-scan.typ"

#include "chapter/dos.typ"

#include "chapter/fortigate.typ"

#include "chapter/fortisiem.typ"
