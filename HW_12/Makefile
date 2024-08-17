build:
	docker-compose -f docker-compose.yml up --build -d
run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_12_db
cli:
	docker exec -it hw_12-db-1 //bin//bash