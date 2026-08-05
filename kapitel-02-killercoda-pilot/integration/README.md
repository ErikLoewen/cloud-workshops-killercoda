# Integration in ein Repository mit structure.json

Der Paketordner ist bereits ein eigenständiges Killercoda-Szenario.

Wenn die Root-`structure.json` nur explizit aufgeführte Einträge veröffentlicht, muss der Pilot für den Test vorübergehend ergänzt werden:

```json
{ "path": "kapitel-02-killercoda-pilot" }
```

Nach dem Pilot kann der Eintrag wieder entfernt werden. Das Paket verändert keine vorhandene `structure.json` automatisch.

Vor dem Commit:

```bash
./validate-package.sh
./test-local.sh
```
