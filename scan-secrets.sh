#!/bin/bash

REPORT_DIR="trufflehog-reports"
mkdir -p "$REPORT_DIR"

echo "Rozpoczynam skanowanie TruffleHog..."

docker run --rm \
  -v "$(pwd):/repo" \
  trufflesecurity/trufflehog:latest \
  git file:///repo \
  --only-verified \
  --branch main \
  --json \
  > "$REPORT_DIR/trufflehog-report.json"

if jq '.[]?' "$REPORT_DIR/trufflehog-report.json" | grep -q .; then
  echo "TruffleHog wykrył potencjalne sekrety! Sprawdź $REPORT_DIR/trufflehog-report.json"
  exit 1
else
  echo "Brak wykrytych sekretów przez TruffleHog."
fi
