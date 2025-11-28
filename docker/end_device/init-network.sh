#!/bin/sh

# Disable IPv4 or IPv6 entirely
[ "$DISABLE_IPV4" = "1" ] && ip -4 addr flush dev eth0
[ "$DISABLE_IPV6" = "1" ] && {
    ip -6 addr flush dev eth0
    sysctl -w net.ipv6.conf.eth0.disable_ipv6=1 >/dev/null 2>&1
}

# DHCP logic
if [ "$DHCPV4" = "1" ] && [ "$DHCPV6" = "1" ]; then
    # Flush everything for dual DHCP
    ip addr flush dev eth0
elif [ "$DHCPV4" = "1" ]; then
    ip -4 addr flush dev eth0
elif [ "$DHCPV6" = "1" ]; then
    ip -6 addr flush dev eth0
fi

###########################################
# Prevent unwanted SLAAC when IPv6 is static
###########################################
if [ "$DHCPV6" != "1" ] && [ "$DISABLE_IPV6" != "1" ]; then
    # Disable IPv6 autoconf + RA
    sysctl -w net.ipv6.conf.eth0.autoconf=0 >/dev/null 2>&1
    sysctl -w net.ipv6.conf.eth0.accept_ra=0 >/dev/null 2>&1
fi

exec "$@"
