# Cоздание и тестирование высоконагруженного отказоустойчивого кластера PostgreSQL на базе Patroni

### Задача
В рамках дипломного проекта необходимо было построить и настроить кластер из 10 машин:

* HaProxy: 1 инстантс
* PgBouncer: 2 инстантса
* ETCD: 3 инстантса
* Patroni: 4 инстантса(мастер + 3 реплики)

![otus_schema.jpeg](files%2Fotus_schema.jpeg)

В ходе работы были установлены все необходимые программные приложения.

Детальный ход установки и настройки описан в [файле](progress.md).

### Тестирование
Было выполнено 2 нагрузочных теста:

**1 тест**

[![asciicast](https://asciinema.org/a/WIBJHc528rnfomHaxvckx6hQO.svg)](https://asciinema.org/a/WIBJHc528rnfomHaxvckx6hQO)

Нагрузка в дашбордах(системные метрики, Postgres):

![otus_dash_system_1.png](files/otus_dash_system_1.png)

![otus_dash_postgres_1.png](files/otus_dash_postgres_1.png)

---
**2 тест**

[![asciicast](https://asciinema.org/a/tD08ru6mFVumKckFW3ODZDfu7.svg)](https://asciinema.org/a/tD08ru6mFVumKckFW3ODZDfu7)

Нагрузка в дашбордах(системные метрики, Postgres):

![otus_dash_system_2.png](files/otus_dash_system_2.png)

![otus_dash_postgres_2.png](files/otus_dash_postgres_2.png)


### Планы на будущее

- [ ] настроить репликацию: 1 — в синхронном режиме, 2 — в асинхронном режиме, 3 — в ждущем режиме — резерв;
- [ ] в случае падения мастера сделать переход на реплику с синхронной репликацией;
- [ ] если в течение 3 минут не поднялся мертвый инстанс предыдущего мастера, то ввести резервную реплику.
- [ ] донастроить работу балансировщиков;
- [ ] донастроить дашборд для PosgtreSQL(сейчас отображается лишь часть метрик)ж
- [ ] провести нагрузочное тестирование: 5000 конкурентных клиентов, убитый мастер во время теста.
