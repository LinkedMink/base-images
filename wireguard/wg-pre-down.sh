#!/bin/sh

set -e

interfaceName=$1

wgFwMark=$(wg show "$interfaceName" fwmark)
iptables -D OUTPUT ! -o "$interfaceName" -m mark ! --mark "$wgFwMark" -m addrtype ! --dst-type LOCAL -j REJECT
for cidr in ${INTERNAL_CIDRS}
do
    iptables -D OUTPUT -d "${cidr}" -j ACCEPT
    echo "Deleted ACCEPT: ${cidr}"
done
