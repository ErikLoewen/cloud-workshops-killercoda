# Abschlussprüfung: die Spur einreichen

Kontrolliere den erreichten Zustand:

1. `whoami` zeigt `mrs_ah`.
2. `pwd` zeigt `/home/mrs_ah`.
3. `ls -l letzte-nachricht` zeigt `x` im Besitzerblock.
4. `./letzte-nachricht` gibt die Flag aus.
5. Reiche sie ein und starte danach den CHECK.

```bash
whoami
pwd
ls -l letzte-nachricht
./letzte-nachricht
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch den vollständigen Flag-Text aus der Ausgabe.
Der CHECK bestätigt anschließend ausschließlich die erfolgreiche Flag-Abgabe.
Das Abgabewerkzeug akzeptiert sie nur, wenn `signaltest` und
`letzte-nachricht` ausführbar gemacht und tatsächlich ausgeführt wurden.

<details>
<summary>Hinweis – wenn die Flag-Abgabe scheitert</summary>

Lies die Rückmeldung genau. Prüfe, unter welchem Benutzer du arbeitest, und
kontrolliere bei beiden Dateien das Besitzer-`x`. Wiederhole danach die
jeweilige Ausführung und die Flag-Abgabe.

</details>
