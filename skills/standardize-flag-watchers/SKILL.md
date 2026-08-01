---
name: standardize-flag-watchers
description: Standardisiert Flaggen, Flag-Abgaben, Hintergrund-Watcher, asynchrone Terminalmeldungen und Killercoda-CHECKs. Verwenden, wenn ein Workshop eine Flagge erzeugt oder enthüllt, ein Background-Skript Hinweise in das Teilnehmerterminal schreibt, ein flag-einreichen-Werkzeug besitzt oder ein Verify-Skript nach einer Flag-Abgabe prüft.
---

# Flaggen und Watcher standardisieren

## Vorgehen

1. Den gesamten Szenarioordner und die verbindlichen Repository-Referenzen lesen.
2. Alle Flag-Literale, Reveal-Skripte, Background-Einträge, Abgabewerkzeuge,
   Statusmarker, CHECKs, Aufgaben, Lösungen und Tests im Szenario ermitteln.
3. Reveal, Benachrichtigung, Abgabe und CHECK als zusammengehenden Ablauf
   bearbeiten.
4. Bash-Syntax, JSON, Dateireferenzen und den positiven sowie negativen
   Flag-Ablauf prüfen.

## Watcher und Terminalausgabe

- Statusdateien atomar über eine temporäre Datei und `mv` schreiben.
- Asynchrone Hinweise niemals ohne Zeilenbegrenzung auf ein TTY schreiben.
- PID und TTY der interaktiven Bash gemeinsam bestimmen.
- Vor und nach der Meldung `\r\n` ausgeben.
- Danach `SIGWINCH` an die ermittelte Bash senden, damit Readline Prompt und
  eine eventuell begonnene Eingabe neu zeichnet.
- Fehlt ein beschreibbares Teilnehmer-TTY, ohne Fehler weiterarbeiten und die
  Benachrichtigung bei Bedarf als Statusdatei für einen späteren Abruf erhalten.
- Niemals `SIGINT`, Tastatureingaben oder einen nachgebauten `PS1` verwenden.

Verbindliches TTY-Muster:

```bash
participant_shell="$(
  ps -u "${lab_user}" -o pid=,tty=,comm= 2>/dev/null |
    awk '$2 != "?" && $3 == "bash" { print $1, $2; exit }'
)" || true
read -r participant_pid participant_tty <<<"${participant_shell}"

if [[ -n "${participant_tty}" && -w "/dev/${participant_tty}" ]]; then
  {
    printf '\r\n'
    cat "${notification}"
    printf '\r\n'
  } >"/dev/${participant_tty}"
  [[ "${participant_pid}" =~ ^[0-9]+$ ]] &&
    kill -WINCH "${participant_pid}" 2>/dev/null || true
fi
```

## Flag-Abgabe und CHECK

- Die Flag erst durch die vorgesehene Lernhandlung sichtbar machen.
- `flag-einreichen` erhält genau eine Flagge, vergleicht sie exakt und erzeugt
  nur bei korrektem Wert atomar einen eindeutigen Abgabemarker.
- Der CHECK prüft ausschließlich diesen erfolgreichen Flag-Status. Er prüft
  weder Befehlsreihenfolge noch weitere Dateien, Verzeichnisse oder
  Watcher-Marker.
- Der CHECK verändert keinen Zustand, ist wiederholbar und nennt bei Fehlern
  das Lesen der Flag-Datei sowie die Abgabe als nächsten Schritt.
- Teilnehmertext, Musterlösung, Trainerleitfaden und Testplan müssen die Grenze
  des CHECKs ausdrücklich benennen.

## Mindesttests

```bash
bash -n setup.sh reveal-*.sh verify.sh assets/flag-einreichen
jq empty index.json
git diff --check
```

Zusätzlich testen:

- Watcher-Meldung beginnt getrennt vom vorhandenen Prompt.
- Nach der Meldung erscheint ohne `Strg+C` eine neu gezeichnete Eingabezeile.
- Falsche Flag wird abgelehnt und erzeugt keinen gültigen Status.
- Korrekte Flag wird angenommen; der CHECK besteht sofort und wiederholt.
- Nach erfolgreicher Flag-Abgabe beeinflussen andere Dateisystemzustände den
  CHECK nicht.
