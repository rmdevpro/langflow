# Langflow for Joshua Ecosystem

Control layer for LLM-orchestrated construction of the joshua ecosystem.

## Architecture

This setup runs Langflow in a **privileged container** with full host filesystem access. The container:

- Has root access to the host filesystem (`/` mounted at `/host`)
- Can orchestrate Docker containers (Docker socket mounted)
- Has direct access to the archive system at `/mnt/irina_storage/archive`
- Runs with all Linux capabilities enabled
- Uses host networking for seamless integration

## Package Management

This project uses **local package caching** to avoid repulling packages on every rebuild.

### Initial Setup - Download Packages

Before first build, download all required packages:

```bash
pip download -r requirements.txt -d packages/
```

This downloads all wheel files to the `packages/` directory, which are then copied into the Docker image during build.

### Adding New Dependencies

1. Add the package to `requirements.txt`
2. Download the new package:
   ```bash
   pip download <package-name> -d packages/
   ```
3. Rebuild the container:
   ```bash
   docker-compose up -d --build
   ```

### Why Local Packages?

- **Faster rebuilds**: No network downloads during build
- **Reproducible builds**: Exact versions committed to repository
- **Offline capability**: Can rebuild without internet access
- **Bandwidth savings**: Download once, use many times

## Quick Start

### Build and Start

First time setup:
```bash
# Download packages (first time only)
pip download -r requirements.txt -d packages/

# Build and start
docker-compose up -d --build
```

### Access Langflow

- **Web UI**: http://localhost:7860
- **API**: http://localhost:7860/api/v1/

### View Logs

```bash
docker-compose logs -f langflow
```

### Stop

```bash
docker-compose down
```

### Restart

```bash
docker-compose restart
```

## Container Access

### Shell Access

```bash
docker exec -it langflow-joshua bash
```

### Root Shell

```bash
docker exec -it -u root langflow-joshua bash
```

## Filesystem Access

From within the container:

- **Host root**: `/host/`
- **Archive**: `/archive/` (same as `/host/mnt/irina_storage/archive`)
- **Langflow data**: `/app/langflow_data/`

## Security Notice

This container runs with **full privileges** and **root filesystem access**. This is intentional for the joshua ecosystem orchestration but means:

- The container can modify any host file
- The container can spawn/control other containers
- The container has all Linux capabilities
- Container isolation is minimal

Only run this in a trusted environment.

## Troubleshooting

### Container won't start

Check logs:
```bash
docker-compose logs langflow
```

### Permission issues

The container runs with full privileges. If you encounter permission issues:
```bash
docker exec -it -u root langflow-joshua chmod 777 /path/to/file
```

### Langflow version

Check installed version:
```bash
docker exec langflow-joshua langflow --version
```

### Rebuild from scratch

```bash
docker-compose down -v
docker-compose up -d --build
```

## Development

### Update Langflow Version

1. Edit `requirements.txt` to specify desired version:
   ```
   langflow==1.3.0
   ```
2. Download the new version:
   ```bash
   pip download -r requirements.txt -d packages/
   ```
3. Rebuild:
   ```bash
   docker-compose up -d --build
   ```

## Integration Points

- **Archive**: `/mnt/irina_storage/archive/` accessible as `/archive/`
- **Host Projects**: `/mnt/projects/` accessible as `/host/mnt/projects/`
- **Docker**: Can orchestrate containers via `/var/run/docker.sock`
