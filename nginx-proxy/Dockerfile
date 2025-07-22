FROM docker.io/alpine:3 AS application

LABEL net.linkedmink.author="Harlan Sang" \
    net.linkedmink.repository="https://github.com/LinkedMink/base-images"

RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked \
    apk add --update-cache \
        nginx nginx-mod-http-brotli nginx-mod-http-zstd

WORKDIR /usr/share/nginx/html

COPY ./default.conf /etc/nginx/http.d/default.conf

EXPOSE 80/tcp 443/tcp
HEALTHCHECK --interval=1m --timeout=3s --retries=2 \
    CMD netstat -an | grep 443

CMD ["nginx", "-g", "daemon off;"]
