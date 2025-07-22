FROM docker.io/alpine:3 AS application

LABEL net.linkedmink.author="Harlan Sang" \
    net.linkedmink.repository="https://github.com/LinkedMink/base-images"

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        qbittorrent-nox wireguard-tools iptables sudo curl

COPY ./docker-entrypoint.sh ./wg-post-up.sh ./wg-pre-down.sh /usr/local/bin/

RUN adduser -D torrent && \
    sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick

COPY --chown=torrent:torrent ./qBittorrent.example.conf /home/torrent/.config/qBittorrent/qBittorrent.conf
VOLUME [ "/home/torrent" ]

WORKDIR /downloads

EXPOSE 8080/tcp 51820/udp
HEALTHCHECK --interval=1m --timeout=3s --retries=2 \
    CMD netstat -an | grep 8080
# TODO public IP check
# HEALTHCHECK --interval=2m --timeout=35s --start-period=3s --start-interval=10s --retries=2 \
#     CMD netstat -an | grep 8080

ENTRYPOINT ["docker-entrypoint.sh"]
