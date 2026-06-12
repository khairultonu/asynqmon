#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi

TAG=$1
IMAGE_NAME="ghcr.io/klikit/shadowchef/asynqmon"
FULL_IMAGE="$IMAGE_NAME:$TAG"

# Build the docker image
# We use --platform linux/amd64 to ensure the image is compatible with the deployment target
echo "Building Docker image: $FULL_IMAGE"
docker build --platform linux/amd64 -t "$FULL_IMAGE" .

# Push the docker image
echo "Pushing Docker image..."
docker push "$FULL_IMAGE"

echo "Done! Built and pushed $FULL_IMAGE"
