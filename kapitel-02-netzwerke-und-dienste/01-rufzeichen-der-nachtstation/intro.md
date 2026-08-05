# Das Rufzeichen der Nachtstation

Über der nächtlichen Hafenstadt steht eine alte Telegraphen- und Nachrichtenstation. Du übernimmst die Nachtschicht.

Das Übergabeprotokoll ist beschädigt. Bevor die offiziell stillgelegte zweite Leitung untersucht werden kann, muss die lokale Station eindeutig dokumentiert werden:

- Wie heißt dieser Host?
- Welche Netzwerkschnittstellen sind vorhanden?
- Welche IPv4-Adressen gehören zu ihnen?
- Welche Schnittstelle führt immer zurück zur Station selbst?

## Danach kannst du

- den Hostnamen der aktuellen Umgebung anzeigen;
- Schnittstellenabschnitte in `ip address` identifizieren;
- IPv4-Adressen an `inet` erkennen;
- Loopback von einer weiteren Schnittstelle unterscheiden;
- erklären, warum ein Host mehrere Schnittstellen und Adressen besitzen kann;
- den tatsächlichen Zustand in einem Stationsprotokoll dokumentieren.

## Dein Ergebnis

Du vervollständigst die vorbereitete Datei:

`/home/telegrafist/nachtstation/stationsprotokoll.txt`

Der CHECK vergleicht deine Einträge mit dem tatsächlichen Zustand dieser Sitzung. Es werden keine feste Schnittstelle und keine feste dynamische IPv4-Adresse vorausgesetzt.

Das Setup bringt dich direkt in das Arbeitskonto `telegrafist` und in den Ordner `~/nachtstation`.
