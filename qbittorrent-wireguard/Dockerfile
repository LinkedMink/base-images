FROM docker.io/linkedmink/wireguard AS application

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        qbittorrent-nox python3

COPY ./qbittorrent-init.sh /usr/local/bin/

RUN adduser -D torrent && \
    mkdir /var/log/torrent && \
    chown torrent:torrent /var/log/torrent

COPY --chown=torrent:torrent ./qBittorrent.example.conf /home/torrent/.config/qBittorrent/qBittorrent.conf
VOLUME [ "/home/torrent", "/var/log/torrent" ]

WORKDIR /downloads

EXPOSE 8080/tcp
HEALTHCHECK --interval=1m --timeout=3s --retries=2 \
    CMD netstat -an | grep 8080

CMD  ["qbittorrent-init.sh"]
