#!/usr/bin/env bash
set -Eeuo pipefail

/tmp/workshop-0106-assets/setup-workshop >/dev/null 2>&1
clear 2>/dev/null || printf '\033[2J\033[H'
exec su - waerter
