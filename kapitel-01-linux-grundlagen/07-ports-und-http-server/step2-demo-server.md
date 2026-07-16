# Vorbereiteten Demo-Server untersuchen

Der Demo-Server wurde vor deiner ersten Handlung technisch vorbereitet.

Er verwendet:

- Arbeitsverzeichnis: `/root/httplabor/demo`;
- Datei: `/root/httplabor/demo/index.html`;
- Bind-Adresse: `127.0.0.1`;
- TCP-Port: `8000`;
- erwarteten Dateiinhalt: `Demo-Server erreichbar`.

**Starte auf Port 8000 keinen zweiten Server.** Der Port ist bereits durch den vorbereiteten Demo-Server belegt.

## 1. In den Demo-Bereich wechseln

Tippe selbst:

```bash
cd /root/httplabor/demo
```

`cd` ändert dein aktuelles Arbeitsverzeichnis. Es verändert die Datei nicht.

## 2. Vorbereitete Datei anzeigen

Tippe selbst:

```bash
cat index.html
```

Erwartete Ausgabe:

```text
Demo-Server erreichbar
```

`cat` liest die Datei unmittelbar aus dem aktuellen Arbeitsverzeichnis.

## Kurzer Abruf

Beantworte in eigenen Worten:

1. Welches Verzeichnis ist jetzt dein aktuelles Arbeitsverzeichnis?
2. Welche Datei wurde unmittelbar mit `cat` gelesen?
3. Welchen exakten Text erwartest du später auch als HTTP-Antwort?

Der Demo-Server läuft bereits. Du untersuchst im nächsten Schritt seinen lauschenden TCP-Endpunkt.
