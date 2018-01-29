ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

# install utils
RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
            vim \
            curl \
        ;

# install the PHP extensions
RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
            libjpeg-turbo-dev \
            libpng-dev \
        ;\
    \
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache;

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


RUN apk add --no-cache ssmtp

RUN { \
		echo 'sendmail_path = /usr/sbin/ssmtp -t'; \
	} > /usr/local/etc/php/conf.d/smtp.ini

# root:  The person who gets all mail for userids < 1000 (Empty to disable rewriting.
# mailhub: The MTA container
# FromLineOverride: Are users allowed to set their own From: address? (YES/NO)
RUN { \
		echo 'root='; \
		echo 'mailhub=exim'; \
		echo 'FromLineOverride=YES'; \
	} > /etc/ssmtp/ssmtp.conf

WORKDIR /code

CMD ["php-fpm"]