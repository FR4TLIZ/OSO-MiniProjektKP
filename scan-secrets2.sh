#!/bin/bash

REPORT_DIR="gitleaks-reports"
mkdir -p "$REPORT_DIR"

echo "🔍 Rozpoczynam skanowanie GitLeaks..."

docker run --rm \
  -v "$(pwd):/repo" \
  zricethezav/gitleaks:latest detect \
  --source=/repo \
  --report-format=json \
  --report-path="$REPORT_DIR/gitleaks-report.json"

if jq '.[]' "$REPORT_DIR/gitleaks-report.json" | grep -q .; then
  echo "GitLeaks wykrył potencjalne sekrety! Sprawdź $REPORT_DIR/gitleaks-report.json"
  exit 1
else
  echo "Brak wykrytych sekretów przez GitLeaks."
fi

