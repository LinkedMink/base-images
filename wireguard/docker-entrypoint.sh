#!/bin/sh

IP_CHANGE_RETRY_LIMIT="${IP_CHANGE_RETRY_LIMIT:-5}"

set -e

ORIGINAL_IP=$(curl --no-progress-meter "https://ipinfo.io/ip")
export ORIGINAL_IP
echo "ORIGINAL_IP=\"${ORIGINAL_IP}\"" >> /etc/environment

wg-quick up /run/secrets/wg0.conf

retries=0
currentIp=$ORIGINAL_IP
while [ "$currentIp" = "$ORIGINAL_IP" ]
do
  if [ "$retries" -gt "$IP_CHANGE_RETRY_LIMIT" ]; then
    echo "Retry limit exceeded: ${IP_CHANGE_RETRY_LIMIT}"
    exit 1
  fi
  sleep 1

  currentIp=$(curl --no-progress-meter "https://ipinfo.io/ip")

  retries=$((retries+1))
done

echo "currentIp: ${currentIp}"

exec "$@"
