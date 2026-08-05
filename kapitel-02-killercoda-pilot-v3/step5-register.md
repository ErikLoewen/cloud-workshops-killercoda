# Namensauflösung und Hosts-Wrapper

## Ausgangszustand

`getent hosts xebico`{{exec}}

Der vorbereitete Ausgangswert ist eine Dokumentationsadresse.

Zeige die Staging-Datei:

`cat register/xebico.hosts`{{exec}}

## Stationsadresse vorbereiten

`./pilot-werkzeuge/register-stationsadresse-vorbereiten`{{exec}}

Prüfe den Eintrag unprivilegiert:

`./werkzeuge/register-pruefen`{{exec}}

Wende ausschließlich den validierten Xebico-Block an:

`./werkzeuge/register-anwenden`{{exec}}

Prüfe die Systemauflösung erneut:

`getent hosts xebico`{{exec}}

Der Name muss nun die in `status/stationsadresse` dokumentierte lokale Stationsadresse liefern. Das Werkzeug verändert keine fremden `/etc/hosts`-Einträge.
