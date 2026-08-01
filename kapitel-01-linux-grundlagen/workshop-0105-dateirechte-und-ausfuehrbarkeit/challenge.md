# Abschlussmission: die letzte Nachricht

Führe die Untersuchung zu Ende:

- vergewissere dich, dass du Rechte und Besitzverhältnisse an der
  Schalttafel untersucht und die eigene gesperrte Signaldatei freigegeben
  hast;
- nutze die zugänglichen Protokolle, um die Spur über beide weiteren Konten
  bis zur aktuellen Identität nachzuvollziehen;
- kontrolliere deine aktuelle Identität und deinen Standort;
- untersuche die erreichbaren Dateien sowie ihre Besitz- und Rechteangaben;
- bestimme bei der letzten gesperrten eigenen Datei die notwendige minimale
  Rechteänderung;
- führe die Datei direkt aus;
- reiche die dadurch erstmals sichtbare Flag ein;
- starte danach den CHECK.

Der CHECK bestätigt ausschließlich die korrekte Flag-Abgabe. Er bewertet
weder Befehlsreihenfolge noch frühere Rechteänderungen oder Benutzerwechsel.

<details>
<summary>Hinweis 1: Woran sollte ich zuerst denken?</summary>

Nutze die bekannte Kontrollroutine: Identität prüfen, Standort prüfen,
Besitzer und Rechte lesen, fehlendes Recht bestimmen, Änderung kontrollieren.

</details>

<details>
<summary>Hinweis 2: Wo könnte ich suchen?</summary>

Untersuche das Home des aktuellen Kontos mit `ls -l`. Die letzte Nachricht ist
eine eigene reguläre Datei, der im Besitzerblock ein bekanntes Recht fehlt.

</details>

<details>
<summary>Hinweis 3: Konkreter Lösungsansatz</summary>

Versuche `letzte-nachricht` relativ auszuführen. Ergänze anschließend nur das
Besitzer-Ausführungsrecht, kontrolliere den Rechteblock und wiederhole die
Ausführung.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
whoami
pwd
ls -l
ls -l letzte-nachricht
./letzte-nachricht
chmod u+x letzte-nachricht
ls -l letzte-nachricht
./letzte-nachricht
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch den vollständigen Flag-Text aus der Ausgabe.
Starte nach der erfolgreichen Abgabe den CHECK.

</details>
