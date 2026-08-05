# Nachtschicht übernehmen

Der Prompt sollte ungefähr so beginnen:

```text
telegrafist@nachtstation:~/nachtstation$
```

Der Text vor dem `$` gehört zum Prompt. Deine Eingabe beginnt erst danach.

## Standort prüfen

`pwd`{{exec}}

Erwartet wird:

```text
/home/telegrafist/nachtstation
```

## Das beschädigte Protokoll ansehen

`cat stationsprotokoll.txt`{{exec}}

Die technischen Pflichtfelder sind noch leer.

## Vorhersage

Besitzt diese Station vermutlich nur **eine** Adresse oder **mehrere** Adressen?

Trage deine Vermutung in die Zeile `Vorhersage` ein. Diese Vermutung wird nicht bewertet.

Tippe dazu selbst:

```bash
nano stationsprotokoll.txt
```

Speichere anschließend wie aus Kapitel 1 bekannt.

<details>
<summary>Hilfe: Nano-Bedienung auffrischen</summary>

- Speichern: `Ctrl+O`, danach Enter
- Beenden: `Ctrl+X`

Bearbeite nur die Zeile `Vorhersage`. Die technischen Werte untersuchst du in den nächsten Schritten.

</details>

Ein **Host** ist hier das laufende Computersystem beziehungsweise die laufende Übungsumgebung, die im Netzwerk einen Namen und Adressen besitzen kann.
