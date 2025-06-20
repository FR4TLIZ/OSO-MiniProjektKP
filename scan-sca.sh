#!/bin/bash

API_KEY="354fbfe6-081a-4099-83f3-a5e1776af766"
REPORT_DIR="odc-reports"
PROJECT_NAME="Security Shepherd"

mkdir -p "$REPORT_DIR"

docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd):/src" \
  -v odc-data:/usr/share/dependency-check/data \
  -v "$(pwd)/odc-reports:/report" \
  owasp/dependency-check:latest \
  --project "Security Shepherd" \
  --scan /src \
  --format HTML \
  --format JSON \
  --out /report \
  --nvdApiKey 354fbfe6-081a-4099-83f3-a5e1776af766 \
  --failOnCVSS 7
