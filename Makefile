.PHONY: start logs stop
start:
	docker-compose up -d
logs-migration:
	docker-compose logs --follow flyway
logs-data:
	docker-compose logs --follow  db
stop:
	docker-compose down
