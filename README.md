# OpenFGA with Default Run Command

This repository provides a custom Docker image of [OpenFGA](https://github.com/openfga/openfga) with a default `run` command. This is specifically designed for use with GitHub Actions services, which currently don't support custom arguments.

## Problem

GitHub Actions services don't yet support custom command arguments. The official OpenFGA image requires you to specify `run` as a command, which isn't possible in GitHub Actions service configurations.

## Solution

This custom image sets `CMD ["run"]` as the default command, allowing you to use it directly in GitHub Actions services without any additional configuration.

## Usage in GitHub Actions

```yaml
services:
  openfga:
    image: armujahid/openfga_run:v1.10.3
    env:
      OPENFGA_DATASTORE_ENGINE: memory
    ports:
      - 8080:8080
      - 8081:8081
```

## Setup Instructions

### 1. Configure Docker Hub Secrets

Add the following secrets to your GitHub repository:

1. Go to your repository → Settings → Secrets and variables → Actions
2. Add these secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Your Docker Hub access token ([create one here](https://hub.docker.com/settings/security))
     - **Required permissions**: Read, Write, and Delete (all three are needed for updating repository descriptions)

### 2. Publishing a New Version

1. Check the latest OpenFGA release at https://github.com/openfga/openfga/releases
2. Go to Actions → "Build and Publish OpenFGA Docker Image"
3. Click "Run workflow"
4. Enter the OpenFGA version (e.g., `v1.10.3`)
5. Click "Run workflow"

The workflow will:
- Build the image based on the specified OpenFGA version
- Tag it with multiple tags: `vX.Y.Z`, `X.Y.Z`, and `latest`
- Push to Docker Hub
- Build for both `linux/amd64` and `linux/arm64` platforms

### 3. Check for New Versions

You can manually check for new OpenFGA versions, or use the included helper script:

```bash
./check-new-version.sh
```

## Local Development

Test the image locally using docker-compose:

```bash
docker-compose up
```

This will:
1. Run migrations using the official OpenFGA image
2. Start OpenFGA with the custom image using the default `run` command

Access the services:
- HTTP API: http://localhost:8080
- gRPC API: http://localhost:8081
- Playground: http://localhost:3000

## Image Tags

Each published version creates three tags:
- `v1.10.3` - Full version with 'v' prefix
- `1.10.3` - Version without 'v' prefix
- `latest` - Points to the most recently published version

## Contributing

When bumping versions, ensure you're using the exact version tag from the [official OpenFGA releases](https://github.com/openfga/openfga/releases).
