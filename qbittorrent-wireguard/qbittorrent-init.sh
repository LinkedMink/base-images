#!/bin/sh

set -e

touch /var/log/torrent/qbittorrent.log
chown -R torrent:torrent /var/log/torrent

exec su -c "tail -F /var/log/torrent/qbittorrent.log & qbittorrent-nox --confirm-legal-notice" -- torrent
