# Minecraft Server

## Table of Contents
- [Description](#description)
- [Quickstart](#quickstart)
- [Usage](#usage)

## Description


## Quickstart


## Usage
### File Permissions

The container runs as a non-root user (`minecraft`, UID/GID 1001) for security reasons.
Before starting the container, ensure the host data directory has matching ownership:

    mkdir -p ./data
    chown 1001:1001 ./data

Without this step, the server will fail to write world data with a "Permission denied" error.
