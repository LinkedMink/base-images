#!/bin/sh

set -e

interfaceName=$1

wgFwMark=$(wg show "$interfaceName" fwmark)
iptables -I OUTPUT ! -o "$interfaceName" -m mark ! --mark "$wgFwMark" -m addrtype ! --dst-type LOCAL -j REJECT
for cidr in ${INTERNAL_CIDRS}
do
    iptables -I OUTPUT -d "${cidr}" -j ACCEPT
    echo "Inserted ACCEPT: ${cidr}"
done
