# Workshop 9 abgeschlossen

Der technische CHECK bestätigt den technisch beobachtbaren Endzustand:

- die Abschlussdatei liegt am erwarteten Pfad;
- ihr Inhalt stimmt bytegenau;
- ein passender Python-HTTP-Server lauscht lokal auf `127.0.0.1:8080`;
- der Prozess arbeitet aus dem Abschlussverzeichnis;
- lokale Anfragen über `127.0.0.1` und `localhost` liefern den erwarteten Inhalt.

## Verständnis abrufen

Beantworte ohne die vorherigen Erklärungen erneut zu lesen:

1. Was ist in `127.0.0.1:8080` die IP-Adresse und was ist der Port?
2. Warum ist der Port keine PID?
3. Was bedeutet `LISTEN`?
4. Warum beweist `LISTEN` allein noch keinen richtigen Dateiinhalt?
5. Wie hängt `localhost` mit Loopback und `127.0.0.1` zusammen?
6. Was ist in `http://localhost:8080/` das Protokoll, der lokale Name, der Port und der angeforderte Pfad?
7. Was liest `cat` unmittelbar?
8. Was fragt `curl` an?
9. Warum können `cat` und `curl` denselben Nutztext zeigen?
10. Warum bedeutet der zurückgekehrte Prompt nicht, dass der Server beendet ist?
11. Wie ordnest du eine später erscheinende Servermeldung ein?

## Wirkungskette

```text
/root/httplabor/abschluss/index.html
        ↓
Python-Serverprozess
        ↓
TCP + 127.0.0.1 + 8080
        ↓
curl http://localhost:8080/
        ↓
HTTP-Server auf Port 8080 bereit
```

## Grenze des technischen CHECKs

Der CHECK kann nicht nachweisen, dass du:

- den Serverbefehl selbstständig zusammengesetzt hast;
- `&`, `ss -ltn` oder `curl` tatsächlich verwendet hast;
- IP-Adresse, Port, Loopback, Anfrage und Antwort verstanden hast;
- die Wirkungskette fachlich erklären kannst.

Diese Leistungen hast du durch Beobachtungs-, Vergleichs- und Abruffragen getrennt bearbeitet.

Damit ist das Kapitel **Linux-Grundlagen** abgeschlossen.
