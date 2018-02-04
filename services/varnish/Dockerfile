ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

RUN apk --no-cache add varnish

COPY default.vcl /etc/varnish/default.vcl

EXPOSE 80

ARG VARNISH_MEMORY
CMD varnishd -j unix,user=varnish -F -f /etc/varnish/default.vcl -s malloc,${VARNISH_MEMORY}