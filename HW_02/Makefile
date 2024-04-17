run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker rm hw_02-db-1
	docker rm hw_02-client-1
	rm -r ./postgres/*
	docker volume rm hw_02_client
rebuild:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose.yml up --build
