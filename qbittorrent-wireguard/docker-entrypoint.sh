#!/bin/sh

IP_CHANGE_RETRY_LIMIT="${IP_CHANGE_RETRY_LIMIT:-5}"

set -e

ORIGINAL_IP=$(curl --no-progress-meter "https://ipinfo.io/ip")
export ORIGINAL_IP
echo "ORIGINAL_IP: ${ORIGINAL_IP}"

wg-quick up /run/secrets/wg0.conf

retries=0
currentIp=$ORIGINAL_IP
while [ "$currentIp" = "$ORIGINAL_IP" ]
do
  if [ "$retries" -gt "$IP_CHANGE_RETRY_LIMIT" ]; then
    echo "Retry limit exceeded: ${IP_CHANGE_RETRY_LIMIT}"
  fi
  sleep 1

  currentIp=$(curl --no-progress-meter "https://ipinfo.io/ip")

  retries=$((retries+1))
done

echo "currentIp: ${currentIp}"

# touch /tmp/torrent/qbittorrent.log
# ln -sf /dev/stdout /tmp/torrent/qbittorrent.log
# chown -R torrent:torrent /var/log/torrent
# tail -f /tmp/torrent/qbittorrent.log > /dev/stdout &
# tail -F /tmp/torrent/qbittorrent.log > /dev/stdout 2>&1 &

exec su -c "tail -F /var/log/torrent/qbittorrent.log & qbittorrent-nox --confirm-legal-notice" -- torrent
