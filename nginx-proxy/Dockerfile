FROM docker.io/alpine:3 AS application

LABEL net.linkedmink.author="Harlan Sang" \
    net.linkedmink.repository="https://github.com/LinkedMink/base-images"

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        nginx nginx-mod-http-brotli nginx-mod-http-zstd

WORKDIR /usr/share/nginx/html

# COPY ./dh2048.pem ./nginx.conf ./location-*.conf /etc/nginx/
COPY ./nginx.conf ./location-*.conf /etc/nginx/

EXPOSE 80/tcp 443/tcp
HEALTHCHECK --interval=1m --timeout=3s --retries=2 --start-period=45s --start-interval=3s \
    CMD netstat -t -l -n | grep 443

CMD ["nginx", "-g", "daemon off;"]
