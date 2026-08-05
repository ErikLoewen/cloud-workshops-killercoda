# HTTP 200, 404 und 500

Die folgenden Live-Demonstrationen verändern jeweils nur den kontrollierten HTTP-Zustand und zeigen die vollständige Antwort.

## 404

`./pilot-werkzeuge/http-404-testen`{{exec}}

## 500

`./pilot-werkzeuge/http-500-testen`{{exec}}

## 200 und Erfolgsheader

`./pilot-werkzeuge/http-200-wiederherstellen`{{exec}}

Prüfe die Antwort erneut:

`curl --noproxy '*' -i http://127.0.0.1:8080/meldung`{{exec}}

Erwartet werden:

- `HTTP/1.1 200 OK`
- `X-Xebico-Status: EMPFANGEN`
- der deterministische Xebico-Body
