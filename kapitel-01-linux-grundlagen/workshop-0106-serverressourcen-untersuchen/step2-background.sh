#!/usr/bin/env bash
set -Eeuo pipefail

/tmp/workshop-0106-assets/prepare-workshop >/dev/null 2>&1
exec /usr/local/lib/leuchtturm/start-beschwoerung >/dev/null 2>&1
