run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker rm hw_01-db-1
	docker volume rm hw_01_db
rebuild:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose.yml up --build
