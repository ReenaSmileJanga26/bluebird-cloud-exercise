#!/usr/bin/env bash
set -euo pipefail

URL="${1:?health url required}"

for i in $(seq 1 30); do
  if curl -fsS "$URL" >/dev/null 2>&1; then
    echo "OK: $URL"
    exit 0
  fi
  sleep 10
done

echo "FAILED: $URL"
exit 1
