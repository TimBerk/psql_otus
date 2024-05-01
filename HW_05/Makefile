run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_05_db
clink:
	winpty docker exec -it hw_05-db-1 //bin//bash