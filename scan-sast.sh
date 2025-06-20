#!/bin/bash

REPORT_DIR="semgrep-reports"
mkdir -p "$REPORT_DIR"

# Pliki do analizy
FILES=(
  "src/main/java/servlets/module/challenge/SqlInjection1.java"
  "src/main/java/servlets/module/challenge/SqlInjection5CouponCheck.java"
)

# Zbuduj komendę semgrep dla wybranych plików
docker run --rm \
  -v "$(pwd):/src" \
  -w /src \
  returntocorp/semgrep semgrep scan \
  --config=p/owasp-top-ten \
  --json \
  "${FILES[@]}" > "$REPORT_DIR/semgrep-report.json"

echo "✅ Semgrep scan complete. Report: $REPORT_DIR/semgrep-report.json"

# Filtrowanie: HIGH likelihood + HIGH confidence
if jq '.results[]? | select(.extra.metadata.likelihood == "HIGH" and .extra.metadata.confidence == "HIGH")' "$REPORT_DIR/semgrep-report.json" | grep -q .; then
  echo "❌ High+High severity SAST issues found in patched files!"
  exit 1
else
  echo "✅ Patched files are clean from HIGH likelihood + HIGH confidence issues."
fi
