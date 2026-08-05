# Kapitel 02 – Killercoda-Technikpilot V4

## Architekturentscheidung

V4 verwendet exakt das in Kapitel 1 funktionierende Startmuster:

```json
"intro": {
  "text": "intro.md",
  "foreground": "setup.sh"
}
```

`setup.sh` enthält alle benötigten Dateien als Heredocs und erzeugt die
Umgebung direkt. Es greift auf keine Nachbardatei und kein `/tmp`-Asset zu.

## Interaktivität

Direkt im Markdown:

- `<details>` und `<summary>`;
- anklickbare `{{exec}}`-Aktionen;
- live erzeugte Terminaldarstellungen.

HTML/CSS/JavaScript:

- lokale Web-App unter `/architektur`;
- erreichbar über `{{TRAFFIC_HOST1_8080}}/architektur`;
- keine externen Ressourcen;
- keine Bilddateien.

## Lokale Prüfung

```bash
./validate-package.sh
./test-local.sh
```

Die Browserdarstellung des Traffic-Links bleibt ausschließlich in Killercoda
prüfbar.
