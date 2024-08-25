build:
	docker-compose -f docker-compose.yml up --build -d
run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_13_db
cli:
	docker exec -it hw_13-db-1 //bin//bash