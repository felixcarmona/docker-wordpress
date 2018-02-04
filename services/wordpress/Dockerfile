ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache curl

VOLUME /code

ARG WORDPRESS_VERSION
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG W3_TOTAL_CACHE_VERSION
RUN set -ex; \
  curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
  tar -xzf wordpress.tar.gz --strip-components=1 -C /code; \
  rm wordpress.tar.gz; \
  cp /code/wp-config-sample.php /code/wp-config.php; \
  sed -i "s/database_name_here/${MYSQL_DATABASE}/g" /code/wp-config.php; \
  sed -i "s/localhost/mysql/g" /code/wp-config.php; \
  sed -i "s/username_here/${MYSQL_USER}/g" /code/wp-config.php; \
  sed -i "s/password_here/${MYSQL_PASSWORD}/g" /code/wp-config.php; \
  curl -o w3-total-cache.zip -fSL "https://downloads.wordpress.org/plugin/w3-total-cache.${W3_TOTAL_CACHE_VERSION}.zip"; \
  unzip w3-total-cache.zip -d /code/wp-content/plugins/; \
  rm w3-total-cache.zip; \
  curl -o /code/wp-admin/wp-cli.phar -fSL "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar";

RUN set -x ; \
  addgroup -g 82 -S www-data; \
  adduser -u 82 -D -S -G www-data www-data; \
  chown -R www-data:www-data /code

WORKDIR /code