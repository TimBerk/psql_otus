build:
	docker-compose -f docker-compose.yml up --build -d
run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_11_db
cli:
	docker exec -it hw_11-db-1 //bin//bash