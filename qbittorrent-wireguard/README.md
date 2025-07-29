# linkedmink/qbittorrent-wireguard

This runs [qBittorrent-nox](https://github.com/qbittorrent/qBittorrent/wiki/Running-qBittorrent-without-X-server-(WebUI-only,-systemd-service-set-up,-Ubuntu-15.04-or-newer)) in a container with WireGuard configured to block all traffic not going through the WireGuard tunnel. It checks that your public IP has changed before starting qBittorrent and runs with sensible default settings for privacy.

## Usage

Create a WireGuard config file that uses the bundled start scripts.

```conf
[Interface]
PrivateKey = <private key for container>
Address = 192.0.2.3/32
ListenPort = 51820
DNS = 1.1.1.1,1.0.0.1
PostUp = wg-post-up.sh "%i"
PreDown = wg-pre-down.sh "%i"

[Peer]
PublicKey = <public key for public-server1.example-vpn.dev>
Endpoint = public-server1.example-vpn.dev:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

Run the container however you see fit, but this compose file example shows the required parameters.

```yaml
secrets:
  wireguard-config:
    file: ./wg0.conf

volumes:
  qbittorrent-home:

services:
  torrent:
    image: ${DOCKER_REGISTRY:-docker.io}/linkedmink/qbittorrent-wireguard
    restart: unless-stopped
    ports:
      # You could use a reverse proxy to access the instance.
      - "8080:8080/tcp"
      - "51820:51820/udp"
    # Maybe have a shared network for a reverse proxy
    # networks:
    #   - ingress-tls
    cap_add:
      - NET_ADMIN
    environment:
      # This could be more restrictive, but for example, allow non-VPN traffic from the default internal
      # Docker CIDR ranges and typical home network ranges (Either for reverse proxy or access from home network).
      INTERNAL_CIDRS: "172.16.0.0/12 192.168.0.0/16"
      # Defaults to the same path
      # WIREGUARD_CONFIG_PATH: /run/secrets/wg0.conf
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    volumes:
      # This contains the persistent configuration set through the qBittorrent UI.
      - type: volume
        source: qbittorrent-home
        target: /home/torrent
      # The contents of the log will be forwarded to stdout, so there's no need to keep it around.
      - type: tmpfs
        target: /var/log/torrent
        tmpfs:
          size: 1M
          mode: 0o01777
      - type: bind
        source: /path/for/download/output
        target: /downloads
    secrets:
      - source: wireguard-config
        target: wg0.conf
```

You will see your initial admin password in the log output.

```ShellSession
# ...
******** Information ********
To control qBittorrent, access the WebUI at: http://localhost:8080⁠
The WebUI administrator username is: admin
The WebUI administrator password was not set. A temporary password is provided for this session: *********
You should set your own password in program preferences.
# ...
```
