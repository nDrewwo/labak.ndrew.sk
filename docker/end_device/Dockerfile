FROM alpine:latest

RUN apk add --no-cache curl nano dhcpcd bash iproute2

COPY init-network.sh /usr/local/bin/init-network.sh
COPY entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /usr/local/bin/init-network.sh /tmp/entrypoint.sh

CMD ["/bin/sh"]
ENTRYPOINT ["/tmp/entrypoint.sh"]
