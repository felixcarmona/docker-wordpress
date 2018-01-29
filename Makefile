up:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose up -d --build

down:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose down

destroy:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose down -v

restart:
	COMPOSE_PROJECT_NAME=$(DOMAIN) docker-compose restart

sh-nginx:
	docker exec -ti $(DOMAIN)_nginx sh

sh-php:
	docker exec -ti $(DOMAIN)_php sh

sh-mysql:
	docker exec -ti $(DOMAIN)_mysql sh

sh-varnish:
	docker exec -ti $(DOMAIN)_varnish sh

sh-exim:
	docker exec -ti $(DOMAIN)_exim sh

backup: backup-code backup-mysql

backup-code:
	mkdir -p backups
	docker exec -ti $(DOMAIN)_php tar -zcvf /tmp/code.tar.gz /code
	docker cp $(DOMAIN)_php:/tmp/code.tar.gz backups/$(DOMAIN)_code.tar.gz
	docker exec -ti $(DOMAIN)_php rm -rf /tmp/code.tar.gz

backup-mysql:
	mkdir -p backups
	docker exec -ti $(DOMAIN)_mysql sh -c 'mysqldump -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} --databases $${MYSQL_DATABASE} --add-drop-database | gzip -c > /tmp/dump.sql.gz'
	docker cp $(DOMAIN)_mysql:/tmp/dump.sql.gz backups/$(DOMAIN)_dump.sql.gz
	docker exec -ti $(DOMAIN)_mysql rm -rf /tmp/dump.sql.gz

recover: recover-code recover-mysql

recover-code:
	docker cp backups/$(DOMAIN)_code.tar.gz $(DOMAIN)_php:/tmp/code.tar.gz
	docker exec -ti $(DOMAIN)_php sh -c 'rm -rf /code/* && tar -zxvf /tmp/code.tar.gz --strip-components=1 -C /code && rm /tmp/code.tar.gz'

recover-mysql:
	docker cp backups/$(DOMAIN)_dump.sql.gz $(DOMAIN)_mysql:/tmp/dump.sql.gz
	docker exec -ti $(DOMAIN)_mysql sh -c 'zcat /tmp/dump.sql.gz | mysql -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} && rm /tmp/dump.sql.gz'

nginx-proxy-start:
	docker run -d --net=host -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

nginx-proxy-stop:
	docker rm $$(docker stop $$(docker ps -a -q --filter ancestor=jwilder/nginx-proxy --format="{{.ID}}"))

docker-install-ubuntu:
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

test-clean:
	DOMAIN=one.example.com make destroy
	DOMAIN=two.example.com make destroy

test-setup:
	DOMAIN=one.example.com make up
	DOMAIN=two.example.com make up
	sleep 10

test:
	bats ./tests.bats

test-run:
	make test-clean
	make test-setup
	make test
