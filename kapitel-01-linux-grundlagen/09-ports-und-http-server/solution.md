# Musterlösung und Referenzbeobachtungen

Diese Datei wird nicht in der Teilnehmeroberfläche referenziert.

## 1. Vollständiger Demoablauf als Beobachtungsweg

Der Demo-Server wird durch `setup.sh` bereitgestellt. Teilnehmende starten ihn nicht erneut.

```bash
cd /root/httplabor/demo
cat index.html
ss -ltn
curl http://localhost:8000/
cat index.html
```

### Erklärung

1. `cd /root/httplabor/demo`  
   Wechselt in den vorbereiteten Demo-Bereich.

2. `cat index.html`  
   Liest die Datei unmittelbar. Erwarteter Text:

   ```text
   Demo-Server erreichbar
   ```

3. `ss -ltn`  
   Zeigt lauschende TCP-Endpunkte numerisch. Gesucht werden `LISTEN` und `127.0.0.1:8000`.

4. `curl http://localhost:8000/`  
   Sendet eine lokale HTTP-Anfrage. Erwarteter Nutztext:

   ```text
   Demo-Server erreichbar
   ```

5. `cat index.html`  
   Ermöglicht den direkten Vergleich zwischen unmittelbarem Dateiinhalt und HTTP-Antwort.

Dynamische Prozesskennungen oder Warteschlangenwerte werden nicht fest vorgegeben.

## 2. Vollständige Abschlusslösung

```bash
cd /root/httplabor/abschluss
echo "HTTP-Server auf Port 8080 bereit" > index.html
cat index.html
python3 -m http.server --bind 127.0.0.1 8080 &
ss -ltn
curl http://localhost:8080/
```

### Erklärung jedes Befehls

1. `cd /root/httplabor/abschluss`  
   Setzt das Arbeitsverzeichnis. Der Server liefert später Dateien aus genau diesem Verzeichnis aus.

2. `echo "HTTP-Server auf Port 8080 bereit" > index.html`  
   Erzeugt `index.html` mit dem verbindlichen Text und genau einem abschließenden Zeilenumbruch.

3. `cat index.html`  
   Prüft den unmittelbaren Dateiinhalt.

4. `python3 -m http.server --bind 127.0.0.1 8080 &`  
   Startet den lokalen Serverprozess im Hintergrund.

5. `ss -ltn`  
   Prüft `LISTEN`, Adresse `127.0.0.1` und Port `8080`.

6. `curl http://localhost:8080/`  
   Sendet die lokale HTTP-Anfrage. Erwartete Antwort:

   ```text
   HTTP-Server auf Port 8080 bereit
   ```

## 3. Vollständige Zerlegung des Serverbefehls

| Bestandteil | Bedeutung |
|---|---|
| `python3` | startet den Python-Interpreter |
| `-m` | führt das angegebene vorhandene Modul aus |
| `http.server` | Modulname; der Punkt gehört zum Namen |
| `--bind` | legt die Bind-Adresse fest |
| `127.0.0.1` | Argument zu `--bind`; Loopback-Adresse |
| `8080` | Portargument; keine PID und kein Teil der IP-Adresse |
| `&` | bekannte Shell-Syntax für den Hintergrundstart |

Der zurückgekehrte Prompt bedeutet nicht, dass der Server beendet ist. Spätere Servermeldungen können optisch neben Prompt und `curl`-Antwort erscheinen.

## 4. Wirkungskette

```text
/root/httplabor/abschluss/index.html
        ↓
Python-Serverprozess
        ↓
Bind-Adresse 127.0.0.1
        +
TCP-Port 8080
        ↓
lokaler Netzwerkendpunkt
        ↓
HTTP-Anfrage mit curl
        ↓
HTTP-Antwort mit dem Dateiinhalt
```

`cat` liest die Datei unmittelbar. `curl` liest sie nicht unmittelbar, sondern erhält den Inhalt vom Server.

## 5. Grenzen des technischen CHECKs

Technisch geprüft werden können:

- exakter Dateipfad und bytegenauer Inhalt;
- Listener auf `127.0.0.1:8080`;
- Socket-Prozess-Zuordnung;
- Python-Prozess mit `-m http.server`;
- Bind- und Portargument;
- Prozessarbeitsverzeichnis;
- Antworten über `127.0.0.1` und `localhost`.

Nicht technisch nachgewiesen werden:

- selbstständige Zusammensetzung des Befehls;
- tatsächliche Verwendung von `&`, `ss -ltn` oder `curl`;
- fachliches Verständnis von Port, TCP, `LISTEN`, Loopback, Anfrage und Antwort.

`http.server` ist ein einfacher Übungsserver und kein produktiver Webserver.
