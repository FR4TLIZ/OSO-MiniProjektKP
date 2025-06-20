#!/bin/bash

REPORT_DIR="dast-reports"
TARGET_URL="https://localhost"
ZAP_IMAGE="ghcr.io/zaproxy/zaproxy:stable"

mkdir -p "$REPORT_DIR"

echo "Uruchamianie OWASP ZAP scan dla $TARGET_URL ..."

docker run --rm --network="host" \
  -v "$(pwd)/$REPORT_DIR:/zap/wrk" \
  -t "$ZAP_IMAGE" zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html

echo "Skanowanie zakończone. Raport zapisany w: $REPORT_DIR/zap-report.html"
