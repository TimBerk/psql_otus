run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_04_db
rebuild:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose.yml up --build
clink:
	winpty docker exec -it hw_04-db-1 //bin//bash