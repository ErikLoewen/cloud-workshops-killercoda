#!/usr/bin/env bash
set -Eeuo pipefail

test -f /tmp/killercoda-verbindungstest.txt
grep -qx 'killercoda-ok' /tmp/killercoda-verbindungstest.txt
