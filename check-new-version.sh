#!/bin/bash

# Script to check for new OpenFGA releases
# Usage: ./check-new-version.sh

set -e

echo "Checking for latest OpenFGA release..."

# Fetch latest release from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/openfga/openfga/releases/latest | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Error: Could not fetch latest release from GitHub API"
    exit 1
fi

echo ""
echo "Latest OpenFGA release: ${LATEST_RELEASE}"
echo ""
echo "To publish this version:"
echo "1. Go to: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions/workflows/publish-docker.yml"
echo "2. Click 'Run workflow'"
echo "3. Enter version: ${LATEST_RELEASE}"
echo "4. Click 'Run workflow'"
echo ""

# Optional: Check if Docker Hub credentials are configured
if [ -n "$DOCKERHUB_USERNAME" ]; then
    echo "Docker Hub username: $DOCKERHUB_USERNAME"
    echo "You can also build and push manually:"
    echo ""
    echo "  docker buildx build --platform linux/amd64,linux/arm64 \\"
    echo "    --build-arg OPENFGA_VERSION=${LATEST_RELEASE} \\"
    echo "    -t ${DOCKERHUB_USERNAME}/openfga_run:${LATEST_RELEASE} \\"
    echo "    -t ${DOCKERHUB_USERNAME}/openfga_run:${LATEST_RELEASE#v} \\"
    echo "    -t ${DOCKERHUB_USERNAME}/openfga_run:latest \\"
    echo "    --push ."
    echo ""
fi
