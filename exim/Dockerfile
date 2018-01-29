ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache exim

COPY exim.conf /etc/exim/exim.conf

EXPOSE 25

VOLUME ["/var/log/exim"]

ENTRYPOINT ["exim"]

CMD ["-bdf", "-v", "-q30m"]