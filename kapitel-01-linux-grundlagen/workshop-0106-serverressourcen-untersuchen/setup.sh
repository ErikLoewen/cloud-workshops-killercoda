#!/usr/bin/env bash
set -Eeuo pipefail

/tmp/workshop-0106-assets/setup-workshop >/dev/null 2>&1
exec runuser -u waerter -- /bin/bash -lc \
  'cd /home/waerter/leuchtturm/aussenstation && exec /bin/bash -l'
