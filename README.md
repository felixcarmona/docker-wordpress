# docker-wordpress
NGINX + PHP-FPM + MYSQL

## Build
`DOMAIN=example.com make up`

## Purge
`DOMAIN=example.com make purge`

## Shell
- `DOMAIN=example.com make sh-nginx`
- `DOMAIN=example.com make sh-php`
- `DOMAIN=example.com make sh-msql`

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

## Backups
- `DOMAIN=example.com make backup` 
- `DOMAIN=example.com make backup-code`
- `DOMAIN=example.com make backup-mysql`

will generate in `backups/` the files`code.tar.gz` and `dump.sql.gz`

- `DOMAIN=example.com make recover` 
- `DOMAIN=example.com make recover-code`
- `DOMAIN=example.com make recover-mysql`

will recover the backups from `backups/` with the files `code.tar.gz` and `dump.sql.gz`
