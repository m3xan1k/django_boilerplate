ifneq (,$(wildcard ./envs/prod.env))
    include envs/prod.env
    export
endif

ifeq ($(COMPOSE_PROJECT_NAME),)
  $(error COMPOSE_PROJECT_NAME is not set)
endif

build:
	docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env build

rebuild:
	docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env down && docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env up -d --build

deploy:
	docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env up -d
	@echo "Running initialization script..."
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "sleep 10"
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "python manage.py migrate"
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "python manage.py createsuperuser --noinput"
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "yes | python manage.py collectstatic"

init:
	docker exec -i $(COMPOSE_PROJECT_NAME)_django bash < init.sh

migrate:
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "python manage.py migrate"

collectstatic:
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "yes | python manage.py collectstatic"

dump:
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "python manage.py dumpdata --exclude=auth.permission --exclude=contenttypes --indent=4 > dump.json"
	docker cp $(COMPOSE_PROJECT_NAME)_django:/usr/src/app/dump.json dump_$(shell date +%Y-%m-%d_%H-%M-%S).json
	docker exec -it $(COMPOSE_PROJECT_NAME)_django bash -c "rm dump.json"

stop:
	docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env down

start:
	docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env up -d

restart:
	docker-compose  -f docker-compose.prod.yml --env-file ./envs/prod.env down && docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env up -d

vanish:
	docker-compose -f docker-compose.prod.yml --env-file ./envs/prod.env down -v
	sudo rm -rf pgdata
