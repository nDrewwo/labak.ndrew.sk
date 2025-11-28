FROM alpine:latest

RUN apk add --no-cache curl nano dhcpcd bash iproute2

COPY init-network.sh /usr/local/bin/init-network.sh
RUN chmod +x /usr/local/bin/init-network.sh

CMD ["/bin/sh"]
