#!/bin/sh

if [ ! -f "/etc/nginx/keys/quic.key" ]; then
  echo "Generating persistent quic key file"
  openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp384r1 -out /etc/nginx/keys/quic.key
fi

exec "$@"
