#!/bin/sh

echo "[INFO] To create a DNS record inside the container, run:"
echo "echo \"address=/example.com/IPV4_OR_IPV6_ADDRESS\" >> /etc/dnsmasq.conf"
echo "[INFO] To start dnsmasq, run:"
echo "dnsmasq"
echo "[INFO] To kill dnsmasq, run:"
echo "pkill dnsmasq"
echo ""

exec sh