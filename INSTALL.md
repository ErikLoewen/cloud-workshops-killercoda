# Installation

Kopiere den Inhalt dieses Pakets in die Wurzel deines Repositorys:

```bash
cd /home/boki/git/killercoda/cloud-workshops-killercoda
unzip -o /pfad/zu/labforge-codex-markdown-only.zip
```

Danach enthält das Repository:

```text
AGENTS.md
skills/
├── 01-workshopdidaktik-evidenzbasiert.md
├── 02-killercoda-authoring-standards.md
└── 03-workshop-aenderungen.md
```

Es werden keine Python-Skripte, GitHub-Actions oder automatischen Validatoren installiert.

Starte Codex in der Repository-Wurzel, damit `AGENTS.md` berücksichtigt wird.

Beispielauftrag:

```text
Ändere Workshop 01.09 so, dass der Dienst Port 8081 verwendet.
Lies zuerst die verbindlichen Referenzen und den vollständigen Szenarioordner.
Aktualisiere nur tatsächlich betroffene Dateien. Prüfe Lernziel, Challenge,
Verify, Lösung und Testplan gemeinsam. Recherchiere aktuelle Killercoda-Syntax,
falls Plattformfunktionen oder Platzhalter betroffen sind.
```
