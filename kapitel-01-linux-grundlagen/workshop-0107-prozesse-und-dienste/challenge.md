# Wo ist der Wärter geblieben?

Der Rundlauf funktioniert wieder. Das Schiff ist inzwischen hinter dem
Regenschleier verschwunden.

Vom Wärter fehlt weiterhin jede Spur.

In der Wartungsanleitung hast du gelesen, dass der Lichtbereich nicht nur auf
das Meer, sondern auch auf die Küste gerichtet werden kann. Nutze das
Leuchtfeuer, um Deich und Strand systematisch abzusuchen.

## Auftrag

Stelle die Küstensuche selbstständig her:

1. Lies die aktuelle Konfiguration.
2. Prüfe, ob deine Sicherungskopie vorhanden ist.
3. Bestimme die passende Einstellung für die Küstensuche.
4. Bearbeite die Konfiguration mit Nano.
5. Speichere die Datei und verlasse Nano.
6. Kontrolliere den gespeicherten Inhalt.
7. Validiere die Konfiguration.
8. Wende sie an.
9. Kontrolliere den angewendeten Status.
10. Lies die freigelegte Flag und reiche sie ein.

Der CHECK bestätigt ausschließlich die erfolgreiche Flag-Abgabe. Er bewertet
weder die verwendeten Befehle noch die Reihenfolge deiner Arbeitsschritte.

<details>
<summary>Hinweis 1 – Suchgebiet</summary>

Der vom Lichtstrahl abgesuchte Bereich wird durch den Schlüssel `BEREICH`
gesteuert.

</details>

<details>
<summary>Hinweis 2 – Zulässiger Wert</summary>

Die Wartungsanleitung nennt `kueste` als Wert für die Suche entlang von Deich
und Küstenlinie.

</details>

<details>
<summary>Hinweis 3 – Sichere Reihenfolge</summary>

```text
lesen
→ Sicherung prüfen
→ ändern
→ kontrollieren
→ prüfen
→ anwenden
→ Status kontrollieren
```

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

Lies zuerst den aktuellen Zustand und kontrolliere die Sicherung:

```bash
cat leuchtfeuer.conf
ls -l leuchtfeuer.conf.bak
nano leuchtfeuer.conf
```

Ändere in Nano:

```ini
BEREICH=meer
```

zu:

```ini
BEREICH=kueste
```

Speichere und verlasse Nano. Kontrolliere und übernimm danach den Zustand:

```bash
cat leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
```

Lies anschließend die technisch freigelegte Flagdatei, reiche den angezeigten
Wert ein und starte danach den CHECK:

```bash
cat status/abschlussflagge
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch den vollständigen Text aus der Flagdatei.

</details>
