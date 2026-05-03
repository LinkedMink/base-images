FROM docker.io/alpine:3 AS application

LABEL net.linkedmink.author="Harlan Sang" \
    net.linkedmink.repository="https://github.com/LinkedMink/base-images"

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        nginx nginx-mod-http-brotli nginx-mod-http-zstd \
        openssl

WORKDIR /usr/share/nginx/html

COPY ./nginx.conf ./location-*.conf /etc/nginx/

# Generate persistent key for quic connection migration
COPY ./docker-entrypoint.sh /usr/local/bin/
VOLUME ["/etc/nginx/keys"]
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80/tcp 443/tcp 443/udp
HEALTHCHECK --interval=1m --timeout=3s --retries=2 --start-period=45s --start-interval=3s \
    CMD netstat -t -l -n | grep 443

CMD ["nginx", "-g", "daemon off;"]
