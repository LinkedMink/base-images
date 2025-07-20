FROM docker.io/alpine:3 AS application

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        qbittorrent-nox wireguard-tools iptables

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN adduser --disabled-login --disabled-password qbittorrent
USER qbittorrent:qbittorrent

WORKDIR /downloads

EXPOSE 8080/tcp
HEALTHCHECK CMD netstat -an | grep 8080

ENTRYPOINT ["docker-entrypoint.sh"]
