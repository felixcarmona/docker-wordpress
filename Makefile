up:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose up -d --build

purge:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose down -v

restart:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose restart

sh-nginx:
	docker exec -ti $(DOMAIN)_nginx sh

sh-php:
	docker exec -ti $(DOMAIN)_php sh

sh-mysql:
	docker exec -ti $(DOMAIN)_mysql sh

backup: backup-code backup-mysql

backup-code:
	mkdir -p backups
	docker exec -ti $(DOMAIN)_php tar -zcvf /tmp/code.tar.gz /code
	docker cp $(DOMAIN)_php:/tmp/code.tar.gz backups/
	docker exec -ti $(DOMAIN)_php rm -rf /tmp/code.tar.gz

backup-mysql:
	mkdir -p backups
	docker exec -ti $(DOMAIN)_mysql sh -c 'mysqldump -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} $${MYSQL_DATABASE} | gzip -c > /tmp/dump.sql.gz'
	docker cp $(DOMAIN)_mysql:/tmp/dump.sql.gz backups/
	docker exec -ti $(DOMAIN)_mysql rm -rf /tmp/dump.sql.gz