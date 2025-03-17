#import "@local/htl3r-da:0.1.0" as htl3r

#show: htl3r.diplomarbeit.with(
  title: "3BB",
  subtitle: "Sicherheit im Bahnnetz",
  department: "ITN",
  school-year: "2024/2025",
  authors: (
    (name: "Albin Gashi", supervisor: "Christian Schöndorfer"),
    (name: "Magdalena Feldhofer", supervisor: "Christian Schöndorfer"),
    (name: "Marlene Reder", supervisor: "Richard Drechsler"),
    (name: "Esther Lina Mayer", supervisor: "Richard Drechsler"),
  ),
  abstract-german: [#include "chapter/kurzfassung.typ"],
  abstract-english: [#include "chapter/abstract.typ"],
  supervisor-incl-ac-degree: (
    "Prof, Dipl.-Ing. Christian Schöndorfer",
    "Prof, Dipl.-Ing. Richard Drechsler",
  ),
  sponsors: (
    "easyname GmbH",
    "Fortinet Austria GmbH",
    "HTL 3 Rennweg",
  ),
  date: datetime.today(),
  print-ref: true,
  generative-ai-clause: none,
  abbreviation: yaml("abbr.yml"),
  bibliography-content: bibliography("refs.yml", title: [Literaturverzeichnis])
)

#include "chapter/einleitung.typ"

#pagebreak()

#include "chapter/it-topologie.typ"

#include "chapter/ot-topologie.typ"

#include "chapter/modbus.typ"

#include "chapter/blocksteuerung.typ"

#include "chapter/weichensteuerung.typ"

// Angriffe

#include "chapter/angriffe_intro.typ"

#pagebreak()
#include "chapter/port-scan.typ"

#pagebreak()
#include "chapter/mitm.typ"

#pagebreak()
#include "chapter/dos.typ"

#pagebreak()
#include "chapter/fuzzing.typ"

#pagebreak()
#include "chapter/replay.typ"

#pagebreak()
#include "chapter/injection.typ"

// FCP

#include "chapter/fortigate.typ"

#include "chapter/fortimanager.typ"

#include "chapter/fortianalyzer.typ"

#include "chapter/fortisiem.typ"
