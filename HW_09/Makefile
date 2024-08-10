build:
	docker-compose -f docker-compose.yml up --build
run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_09_db
cli:
	docker exec -it hw_09-db-1 //bin//bash