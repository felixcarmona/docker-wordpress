# docker-wordpress
NGINX + PHP-FPM + MYSQL

## Build
`DOMAIN=example.com make up`

## Purge
`DOMAIN=example.com make purge`

## Shell
- `DOMAIN=example.com make sh-nginx`
- `DOMAIN=example.com make sh-php`
- `DOMAIN=example.com make sh-mysql`

## Configuration
`.env` configurable/default values:
```
WORDPRESS_VERSION=4.9.2
PHP_VERSION=7.2
MYSQL_VERSION=5.7
NGINX_VERSION=1.13
ALPINE_VERSION=3.7

MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=username
MYSQL_PASSWORD=password
```

## nginx-proxy
This `docker-wordpress` project supports having multiple wordpress instances with different domain names.

`nginx-proxy` serves as HTTP Proxy + DNS server in order to dispatch the HTTP request to right the wordpress instance (based on the domain)

- `make nginx-proxy-start`
- `make nginx-proxy-stop`

*Note: These commands will only work on Linux hosts (won't work on MacOS/Windows).*

*Tip: If you are using MacOS as host server, consider using [dinghy](https://github.com/codekitchen/dinghy) (which includes the adapted implementation [dinghy-http-proxy](https://github.com/codekitchen/dinghy-http-proxy)) instead of Docker for Mac.*

## Backups
- `DOMAIN=example.com make backup` 
- `DOMAIN=example.com make backup-code`
- `DOMAIN=example.com make backup-mysql`

will generate in `backups/` the files`code.tar.gz` and `dump.sql.gz`

- `DOMAIN=example.com make recover` 
- `DOMAIN=example.com make recover-code`
- `DOMAIN=example.com make recover-mysql`

will recover the backups from `backups/` with the files `code.tar.gz` and `dump.sql.gz`
