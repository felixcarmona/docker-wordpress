up:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose up -d --build

purge:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose down -v

sh-nginx:
	docker exec -ti $(DOMAIN)_nginx sh

sh-php:
	docker exec -ti $(DOMAIN)_php sh

sh-mysql:
	docker exec -ti $(DOMAIN)_mysql sh