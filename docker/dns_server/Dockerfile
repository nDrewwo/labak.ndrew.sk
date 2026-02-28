FROM alpine:latest

RUN apk add --no-cache curl nano dhcpcd bash iproute2 dnsmasq

COPY init-network.sh /usr/local/bin/init-network.sh
COPY entrypoint.sh /tmp/entrypoint.sh

#replace dnsmasq default configuration
COPY dnsmasq.conf /etc/dnsmasq.conf

RUN chmod +x /usr/local/bin/init-network.sh /tmp/entrypoint.sh

CMD ["/bin/sh"]
ENTRYPOINT ["/tmp/entrypoint.sh"]