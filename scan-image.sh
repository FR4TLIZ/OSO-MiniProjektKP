#!/bin/bash

IMAGE_NAME="twoja_aplikacja:latest"
TLS_KEYSTORE_FILE="keystore.jks"
TOMCAT_DOCKER_VERSION="9.0.99"

echo "Budowanie obrazu Docker: $IMAGE_NAME"
docker build \
  --build-arg TLS_KEYSTORE_FILE=$TLS_KEYSTORE_FILE \
  --build-arg TOMCAT_DOCKER_VERSION=$TOMCAT_DOCKER_VERSION \
  -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
  echo "Błąd podczas budowania obrazu."
  exit 1
fi

echo "Skanowanie obrazu Trivy..."
trivy image --severity HIGH,CRITICAL --format table --output trivy-report.txt $IMAGE_NAME

if [ $? -eq 0 ]; then
  echo "Skanowanie zakończone. Raport zapisany w: trivy-report.txt"
else
  echo "Wystąpił błąd podczas skanowania."
fi
