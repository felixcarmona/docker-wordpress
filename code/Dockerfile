ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache curl

RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

WORKDIR /code