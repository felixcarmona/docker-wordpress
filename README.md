# docker-wordpress
NGINX-PROXY(SSL) + VARNISH + NGINX + PHP-FPM + MYSQL

[![Build Status](https://travis-ci.org/felixcarmona/docker-wordpress.svg?branch=master)](https://travis-ci.org/felixcarmona/docker-wordpress)

## Build
- `DOMAIN=example.com make up`
- `DOMAIN=example.com make down`
- `DOMAIN=example.com make restart`
- `DOMAIN=example.com make destroy` # CAUTION: will destroy all the containers and volumes.

*Note: don't prefix the domain with `www.`*

## Shell
- `DOMAIN=example.com make sh-nginx`
- `DOMAIN=example.com make sh-php`
- `DOMAIN=example.com make sh-mysql`
- `DOMAIN=example.com make sh-varnish`
- `DOMAIN=example.com make sh-exim`

## Configuration
`.env` configurable/default values:
```
WORDPRESS_VERSION=4.9.2
W3_TOTAL_CACHE_VERSION=0.9.6
PHP_VERSION=7.2
MYSQL_VERSION=5.7
NGINX_VERSION=1.13
ALPINE_VERSION=3.7

MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=username
MYSQL_PASSWORD=password

VARNISH_MEMORY=100M

EXIM_DNS=8.8.8.8
```

## nginx-proxy
This `docker-wordpress` project supports having multiple wordpress instances with different domain names.

`nginx-proxy` serves as HTTP Proxy + DNS server in order to dispatch the HTTP request to right the wordpress instance (based on the domain)

- `make nginx-proxy-start`
- `make nginx-proxy-stop`
- `make nginx-proxy-restart`

*Note: These commands will only work on Linux hosts (won't work on MacOS/Windows).*

*Tip: If you are using MacOS as host server, consider using [dinghy](https://github.com/codekitchen/dinghy) (which includes the adapted implementation [dinghy-http-proxy](https://github.com/codekitchen/dinghy-http-proxy)) instead of Docker for Mac.*

### SSL
`nginx-proxy` is in front of Varnish and will receive the https requests, decrypt them, and send them to Varnish converted as http requests.

Finally will encrypt the response before sending it to the client.

Put your cert files `.crt` and `.key` in the path `./certs/{DOMAIN}.crt` and `./certs/{DOMAIN}.key`

For example: `./certs/one.example.com.crt` and `./certs/one.example.com.key`

**Note: remember to restart the `nginx-proxy` after any cert modification**

## Varnish
Varnish is a web application accelerator also known as a caching HTTP reverse proxy.

It's in front of the nginx server and caches the HTTP responses:

It receives requests from clients and tries to answer them from the cache.
If it cannot answer from the cache it will forward it to the nginx server + php-fpm, fetch the response, store it in cache and deliver it to the client.

When Varnish has a cached response ready, it is typically delivered in a matter of microseconds

The `wordpress` container includes a [wordpress plugin (W3 Total Cache)](https://wordpress.org/plugins/w3-total-cache/) to invalidate the cache after any content change.

You should enable the plugin after the installation (`Plugins` → `Installed Plugins`) pressing the `Activate` button under the `W3 Total Cache` row.
Then press on the `Settings` under the same plugin row and search the `Reverse Proxy` section.
Enable the checkbox `Enable reverse proxy caching via varnish` and in the `Varnish servers` text area just type `varnish` and press the `Save all settings` button.

**Note: It requires having permalinks enabled (`Settings` → `Permalinks`). Choose one that is not the first (`Plain`)**

## Backups
- `DOMAIN=example.com make backup` 
- `DOMAIN=example.com make backup-code`
- `DOMAIN=example.com make backup-mysql`

will generate in `backups/` the files`code.tar.gz` and `dump.sql.gz`

- `DOMAIN=example.com make recover` 
- `DOMAIN=example.com make recover-code`
- `DOMAIN=example.com make recover-mysql`

will recover the backups from `backups/` with the files `code.tar.gz` and `dump.sql.gz`

## Install docker + docker_compose
- ubuntu: `make docker-install-ubuntu`
