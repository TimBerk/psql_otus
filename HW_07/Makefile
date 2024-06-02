run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_07_db
shell:
	winpty docker exec -it hw_07-db-1 //bin//bash
psql:
	winpty docker exec -it hw_07-db-1 psql -U postgres