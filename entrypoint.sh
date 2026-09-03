#!/usr/bin/env bash
set -euo pipefail

if [[ "${EULA}" != "true" ]]; then
    echo "EULA not accepted. Set EULA=true (https://aka.ms/MinecraftEULA)." >&2
    exit 1
fi
echo "eula=true" > /data/eula.txt

exec java ${JAVA_OPTS:-} -jar /opt/minecraft/server.jar "$@"