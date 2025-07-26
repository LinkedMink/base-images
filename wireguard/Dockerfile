FROM docker.io/alpine:3 AS application

LABEL net.linkedmink.author="Harlan Sang" \
    net.linkedmink.repository="https://github.com/LinkedMink/base-images/wireguard"

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        wireguard-tools iptables sudo curl

COPY ./docker-entrypoint.sh ./wg-post-up.sh ./wg-pre-down.sh /usr/local/bin/

RUN sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick

EXPOSE 51820/udp
HEALTHCHECK --interval=1m --timeout=30s --retries=2 \
    CMD echo "$ORIGINAL_IP" && \
        [ $(curl --no-progress-meter "https://ipinfo.io/ip") != "$ORIGINAL_IP" ]

ENTRYPOINT ["docker-entrypoint.sh"]
