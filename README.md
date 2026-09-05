# Minecraft Server

## Table of Contents
- [Description](#description)
- [Quickstart](#quickstart)
- [Usage](#usage)

## Description

This repository contains a fully containerized Minecraft Java Edition server, built from scratch with Docker instead of relying on a pre-built Minecraft image.

Its purpose is to provide everything needed to deploy and operate a self-hosted Minecraft server reproducibly on any Docker host: the world data survives container recreation, all settings are supplied through environment variables rather than baked into the image, and the server recovers automatically from crashes.

Key contents:
- **`Dockerfile`** — builds the server image on top of a minimal `eclipse-temurin` JRE base. The server JAR is downloaded directly from Mojang and its integrity is verified via a pinned SHA-256 checksum. The container runs as a dedicated non-root user.
- **`entrypoint.sh`** — enforces explicit EULA acceptance via an environment variable, then starts the Java process in a way that forwards shutdown signals correctly for a clean server stop.
- **`docker-compose.yaml`** — defines the `mc-server` service, including port mapping, a named volume for persistent world data, environment-based configuration, and an automatic restart policy on failure.

## Quickstart

**Prerequisites:** Docker and Docker Compose.

1. Clone this repository and move into it.
2. Copy the example environment file and adjust it:
   ```
   cp example.env .env
   ```
   At minimum, `EULA` must be set to `true` to start the server (see [Usage](#usage)).
3. Build and start the server:
   ```
   docker compose up -d --build
   ```
4. The server is reachable on port `8888`. Verify it with [mcstatus](https://github.com/py-mine/mcstatus) (see its docs for installation) or by connecting with a Minecraft Java client:
   ```
   mcstatus localhost:8888 status
   ```

## Usage

### Environment Variables

Configuration is passed via a `.env` file (see `example.env` for a template). All variables map directly to `docker-compose.yaml`.

| Variable               | Required | Default | Description |
|-------------------------|----------|---------|--------------|
| `EULA`                  | Yes      | `false` | Must be set to `true` to accept [Mojang's EULA](https://aka.ms/MinecraftEULA). The server refuses to start otherwise. |
| `JAVA_OPTS`              | No       | *(empty)* | Extra JVM flags (e.g. heap size, garbage collector tuning). Passed through unquoted, so multiple flags can be space-separated. |

### Networking

The Minecraft server listens on port `25565` inside the container. `docker-compose.yaml` maps this to host port `8888`:

```yaml
ports:
  - "8888:25565"
```

To change the externally visible port, adjust the host side of this mapping (the part before the colon).

### Persistence

World data, `server.properties`, and logs are stored in `/data` inside the container, which is backed by a Docker-managed named volume (`mc-data`). This means:
- Data survives container restarts and recreation (`docker compose down && docker compose up`).
- The volume is created and owned automatically with the correct permissions for the container's non-root user — no manual setup needed on the host.

### Restart Behavior

The service uses `restart: on-failure`, meaning the container is restarted automatically if the server process exits with an error, but not after a manual `docker compose stop` or `docker compose down`.
