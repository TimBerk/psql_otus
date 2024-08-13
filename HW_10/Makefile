ver ?= master_01

build:
	docker-compose up --build
run:
	docker-compose -f docker-compose.yml up -d
stop:
	docker-compose -f docker-compose.yml stop
clear:
	docker-compose -f docker-compose.yml down
	docker volume rm hw_10_master_01
	docker volume rm hw_10_master_02
	docker volume rm hw_10_slave_01
	#docker volume rm hw_10_slave_02
cli:
	docker exec -it hw_10-$(ver)-1 //bin//bash
init:
	docker exec -it hw_10-master_01-1 //bin//bash -c "/home/scripts/init.sh"
	docker exec -it hw_10-master_02-1 //bin//bash -c "/home/scripts/init.sh"
	docker exec -it hw_10-slave_01-1 //bin//bash -c "/home/scripts/init.sh"
init_hot:
	docker exec -it hw_10-master_01-1 //bin//bash -c "/home/scripts/init_m_hot.sh"
	docker exec -it hw_10-master_02-1 //bin//bash -c "/home/scripts/init_m_hot.sh"
	docker exec -it hw_10-slave_01-1 //bin//bash -c "/home/scripts/init_m_hot.sh"
	docker exec -it hw_10-slave_02-1 //bin//bash -c "/home/scripts/init_s_hot.sh"