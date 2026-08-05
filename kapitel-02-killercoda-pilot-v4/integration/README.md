# Integration in das aktuelle Repository

Das aktuelle Root-`structure.json` verweist auf
`kapitel-02-killercoda-pilot-v3`.

Für den V4-Test gibt es zwei sichere Varianten.

## Variante A – vorhandenen Testeintrag umstellen

```json
{
  "path": "kapitel-02-killercoda-pilot-v4"
}
```

Den bisherigen V3-Ordner zunächst behalten, aber nicht mehr in der
Struktur veröffentlichen.

## Variante B – V3 ersetzen

Den V3-Ordner archivieren oder löschen und V4 auf denselben Pfad
`kapitel-02-killercoda-pilot-v3` umbenennen. Dann ist keine Änderung der
Root-`structure.json` nötig.

Variante A ist für die erste Prüfung transparenter.

## Vor dem Commit

```bash
cd kapitel-02-killercoda-pilot-v4
./validate-package.sh
./test-local.sh
```

## Erwarteter Start

Im Intro darf kein `/tmp/...wait.sh` erscheinen. Nach abgeschlossenem
Setup steht direkt ein Prompt ähnlich diesem bereit:

```text
telegrafist@nachtstation:~/nachtstation$
```
