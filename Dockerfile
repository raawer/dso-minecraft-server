ARG JAVA_VERSION=25
FROM eclipse-temurin:${JAVA_VERSION}-jre

ARG MINECRAFT_JAR_URL="https://piston-data.mojang.com/v1/objects/823e2250d24b3ddac457a60c92a6a941943fcd6a/server.jar"
ARG MINECRAFT_JAR_SHA256="cdacdfb25898de5e4b4b0e5ddcc2722f77067e46605709c2d886c000ebb63ec5"

RUN groupadd -g 1001 minecraft \
    && useradd -u 1001 -g minecraft -d /data -s /usr/sbin/nologin minecraft \
    && mkdir -p /data \
    && chown minecraft:minecraft /data

ADD --chown=minecraft:minecraft --checksum=sha256:${MINECRAFT_JAR_SHA256} ${MINECRAFT_JAR_URL} /opt/minecraft/server.jar

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV EULA=false

WORKDIR /data
VOLUME ["/data"]
EXPOSE 25565/tcp
USER minecraft
STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nogui"]



