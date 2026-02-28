FROM alpine:latest

RUN apk add --no-cache curl nano dhcpcd bash iproute2 nginx

COPY init-network.sh /usr/local/bin/init-network.sh
COPY entrypoint.sh /tmp/entrypoint.sh

# add a default nginx index page
RUN mkdir -p /var/lib/nginx/html \
    && echo '<h1>Web server response OK!</h1>' > /var/lib/nginx/html/index.html

# replace nginx default configuration
COPY default.conf /etc/nginx/http.d/default.conf

RUN chmod +x /usr/local/bin/init-network.sh /tmp/entrypoint.sh

CMD ["/bin/sh"]
ENTRYPOINT ["/tmp/entrypoint.sh"]