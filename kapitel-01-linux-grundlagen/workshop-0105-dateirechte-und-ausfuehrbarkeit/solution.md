# Musterlösung

Diese Datei ist nicht in `index.json` referenziert.

```bash
whoami
pwd
ls -l
./signaltest
chmod u+x signaltest
ls -l signaltest
./signaltest
cat uebergabe-chat.log
su - nachtwache
# Passwort: sturmlicht
whoami
pwd
ls -l
cat dienst-chat.log
cat sicherheitsnotiz.log
su - mrs_ah
# Passwort: tabitha
whoami
pwd
ls -l letzte-nachricht
./letzte-nachricht
chmod u+x letzte-nachricht
ls -l letzte-nachricht
./letzte-nachricht
flag-einreichen 'FLAG{mrs_a_h_war_nie_ihr_name}'
```

`u` bezeichnet jeweils den Besitzer der Datei. Deshalb kann `waerter`
`signaltest` und `mrs_ah` die `letzte-nachricht` gezielt verändern.
Der CHECK prüft nur den von der korrekten Flag-Abgabe atomar erzeugten Marker.
Das Abgabewerkzeug vergleicht ausschließlich die eingereichte Flag.
