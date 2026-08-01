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
- Vor der Meldung `\r\n` ausgeben.
- Vor der Ausgabe mindestens zweimal prüfen, dass Bash schläft und selbst die
  Vordergrund-Prozessgruppe des TTY ist. So wird kein laufender
  Vordergrundbefehl unterbrochen.
- Danach `SIGINT` direkt an die wartende Bash senden. Ein extern gesendetes
  Signal beendet bei der geprüften Vordergrundlage keinen Lernendenbefehl und
  lässt Bash zuverlässig einen vollständigen neuen Prompt ausgeben.
- In der vom Setup erzeugten interaktiven `.bashrc`
  `bind 'set echo-control-characters off'` setzen. Dadurch zeigt das für die
  Neuzeichnung verwendete Signal kein verwirrendes `^C`.
- Fehlt ein beschreibbares Teilnehmer-TTY, ohne Fehler weiterarbeiten und die
  Benachrichtigung bei Bedarf als Statusdatei für einen späteren Abruf erhalten.
- Niemals Tastatureingaben injizieren oder einen `PS1` nachbauen.
- `SIGWINCH` nicht zur Prompt-Neuzeichnung verwenden; ohne echte
  Größenänderung zeichnet Readline den Prompt nicht zuverlässig neu.

Verbindliches TTY-Muster:

```bash
participant_shell="$(
  ps -u "${lab_user}" -o pid=,tty=,comm= 2>/dev/null |
    awk '$2 != "?" && $3 == "bash" { print $1, $2; exit }'
)" || true
read -r participant_pid participant_tty <<<"${participant_shell}"

shell_is_waiting=false
stable_samples=0
for _ in {1..100}; do
  read -r shell_state foreground_group < <(
    ps -o stat=,tpgid= -p "${participant_pid}" 2>/dev/null
  ) || break
  if [[ "${shell_state}" == S* && "${foreground_group}" == "${participant_pid}" ]]; then
    ((stable_samples += 1))
    if (( stable_samples >= 2 )); then
      shell_is_waiting=true
      break
    fi
  else
    stable_samples=0
  fi
  sleep 0.05
done

if [[ "${shell_is_waiting}" == "true" &&
  -n "${participant_tty}" && -w "/dev/${participant_tty}" ]]; then
  {
    printf '\r\n'
    cat "${notification}"
  } >"/dev/${participant_tty}"
  [[ "${participant_pid}" =~ ^[0-9]+$ ]] &&
    kill -INT "${participant_pid}" 2>/dev/null || true
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
- Jeder Abschluss-Walkthrough eines Flag-Workshops muss den gesamten letzten
  Ablauf explizit und in dieser Reihenfolge zeigen: Flag-Datei mit `cat` lesen,
  `flag-einreichen 'GEFUNDENE_FLAG'` ausführen, danach den CHECK starten.
- `GEFUNDENE_FLAG` bleibt ein klar erkennbarer Platzhalter; die konkrete Flag
  nur in einer internen Musterlösung zeigen, wenn dies ausdrücklich vorgesehen
  ist.

## Mindesttests

```bash
bash -n setup.sh reveal-*.sh verify.sh assets/flag-einreichen
jq empty index.json
git diff --check
```

Zusätzlich testen:

- Watcher-Meldung beginnt getrennt vom vorhandenen Prompt.
- Nach der Meldung erscheint ohne Benutzereingabe und ohne sichtbares `^C`
  der vollständige neue Prompt.
- Ein während der Erkennung laufender Vordergrundbefehl wird nicht unterbrochen.
- Falsche Flag wird abgelehnt und erzeugt keinen gültigen Status.
- Korrekte Flag wird angenommen; der CHECK besteht sofort und wiederholt.
- Nach erfolgreicher Flag-Abgabe beeinflussen andere Dateisystemzustände den
  CHECK nicht.
