# linkedmink/wireguard

A base image for processes that need to connect to a WireGuard VPN before running the main process

## Usage

This is mostly meant for building other images where the `ENTRYPOINT` will startup the WireGuard tunnel and execute the primary application.

```Dockerfile
FROM docker.io/linkedmink/wireguard AS application

# ... 

CMD  ["my-program-with-tunnelled-traffic"]
```

You can run arbitrary commands with tunneled traffic.

```sh
docker run `
    -v ./wg0.conf:/etc/wireguard/wg0.conf:ro `
    -e WIREGUARD_CONFIG_PATH="/etc/wireguard/wg0.conf" `
    --cap-add NET_ADMIN `
    --sysctl net.ipv4.conf.all.src_valid_mark=1 `
    -it linkedmink/wireguard /bin/sh
```
