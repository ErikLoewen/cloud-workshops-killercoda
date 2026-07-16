# Challenge: Abschlussserver selbstständig bereitstellen

## Zielzustand

Stelle einen zweiten lokalen HTTP-Server bereit.

Verbindlich sind:

- Arbeitsverzeichnis: `/root/httplabor/abschluss`;
- Datei: `index.html`;
- exakter Inhalt: `HTTP-Server auf Port 8080 bereit`;
- Bind-Adresse: `127.0.0.1`;
- TCP-Port: `8080`;
- Hintergrundstart mit `&`;
- Portprüfung mit `ss -ltn`;
- lokale Anfrage an `http://localhost:8080/`.

## Dein Auftrag

Führe selbstständig diese Handlungen aus:

1. Wechsle in das Abschlussverzeichnis.
2. Erzeuge dort `index.html` mit dem exakten vorgegebenen Inhalt.
3. Kontrolliere die Datei unmittelbar mit `cat`.
4. Starte aus diesem Arbeitsverzeichnis den Python-HTTP-Server.
5. Binde ihn ausschließlich an `127.0.0.1`.
6. Verwende Port `8080`.
7. Starte ihn mit `&` im Hintergrund.
8. Prüfe den Listener mit `ss -ltn`.
9. Sende mit `curl` eine lokale HTTP-Anfrage.
10. Vergleiche Dateiinhalt und HTTP-Antwort.
11. Führe danach den technischen CHECK aus.

Alle Befehle werden selbst eingegeben. Verwende keine neuen Optionen oder Shelloperatoren.

<details>
<summary>Hinweis 1 – Konzept</summary>

Prüfe nacheinander:

- richtiges Arbeitsverzeichnis;
- richtige Datei;
- Loopback-Bindung;
- Port `8080`;
- lauschenden Port;
- HTTP-Antwort.

</details>

<details>
<summary>Hinweis 2 – Werkzeuge</summary>

Du benötigst ausschließlich:

- `cd`;
- `echo`;
- doppelte Anführungszeichen;
- `>`;
- `cat`;
- `python3 -m http.server`;
- `--bind`;
- `127.0.0.1`;
- `8080`;
- `&`;
- `ss -ltn`;
- `curl`.

</details>

<details>
<summary>Hinweis 3 – Struktur</summary>

Ergänze die Lücken. Die Unterstriche sind Platzhalter und werden nicht mit eingegeben.

```text
cd /root/httplabor/________

echo "HTTP-Server auf Port 8080 bereit" > ________

python3 -m http.server --bind 127.0.0.1 ____ &

ss -ltn

curl http://localhost:____/
```

</details>

<details>
<summary>Hinweis 4 – vollständige Musterlösung</summary>

Öffne diesen Hinweis erst nach einem eigenen Lösungsversuch.

```bash
cd /root/httplabor/abschluss
echo "HTTP-Server auf Port 8080 bereit" > index.html
cat index.html
python3 -m http.server --bind 127.0.0.1 8080 &
ss -ltn
curl http://localhost:8080/
```

Erwartete Beobachtungen:

1. `cd` setzt das Arbeitsverzeichnis für Datei und späteren Serverstart.
2. `echo` mit `>` erzeugt die Datei mit genau einer abschließenden Zeile.
3. `cat` zeigt den unmittelbaren Dateiinhalt.
4. Der Python-Befehl startet den Server lokal auf Port `8080`.
5. `&` gibt den Prompt zurück, während der Prozess weiterläuft.
6. `ss -ltn` zeigt `LISTEN` und `127.0.0.1:8080`.
7. `curl` zeigt den Text `HTTP-Server auf Port 8080 bereit`.

</details>

## Technischer CHECK

Der CHECK prüft den Endzustand. Er prüft nicht, ob du die Befehle selbstständig zusammengesetzt oder tatsächlich `ss -ltn`, `curl` und `&` verwendet hast.

Bei einem Fehler erhältst du eine Diagnose und kannst den CHECK erneut ausführen.
