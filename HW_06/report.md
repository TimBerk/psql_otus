# Работа с журналами

<p align="left">
    <a href="https://yandex.cloud/ru/" target="blank">
        <img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" />
    </a>
    <a href="https://www.postgresql.org/" target="blank">
        <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/>
    </a>
</p>

В качестве рабочего окружения используется PostgreSQL 15 версии установленный в Yandex Cloud.

Дополнительно устанавливается решение [asciinema](https://asciinema.org/) - для составления интерактивного отчета.

Каждый этап имеет следующую структуру:

* Номера затрагиваемых задач
* Краткий отчет о том, что было сделано
* Пример выполнения команд

## Оглавление

- [Задание](#задание)
- [Практика](#практика)
- [Используемые источники](#используемые-источники)

### Задание

1. Настройте выполнение контрольной точки раз в 30 секунд.
2. 10 минут c помощью утилиты pgbench подавайте нагрузку.
3. Измерьте, какой объем журнальных файлов был сгенерирован за это время. Оцените, какой объем приходится в среднем на
   одну контрольную точку.
4. Проверьте данные статистики: все ли контрольные точки выполнялись точно по расписанию. Почему так произошло?
5. Сравните tps в синхронном/асинхронном режиме утилитой pgbench. Объясните полученный результат.
6. Создайте новый кластер с включенной контрольной суммой страниц. Создайте таблицу. Вставьте несколько значений.
   Выключите кластер. Измените пару байт в таблице. Включите кластер и сделайте выборку из таблицы. Что и почему
   произошло? как проигнорировать ошибку и продолжить работу?

### Практика

<details>
  <summary> ✔️ Работа с контрольными точками</summary>

**Затрагиваемые задачи**: 1 - 4

**Выполнение задания**:

* В ходе выполнения задания, был установлен PostgreSQL 15 в Yandex Cloud.
* Перед запуском теста объем журнальных файлов был равен **17M**.
* Была создана база для проведения тестирования посредствам `pgbench`.
* Был запущен тест производительности, подающий нагрузку в течение **10 минут**.
* В результате работы, объем журнальных файлов вырос до **65M**.
* Статистика представлена ниже:
    
    | param                 |                         value |
    |-----------------------|------------------------------:|
    | checkpoints_timed     |                            22 |
    | checkpoints_req       |                             1 |
    | checkpoint_write_time |                        537602 |
    | checkpoint_sync_time  |                           523 |
    | buffers_checkpoint    |                         39876 |
    | buffers_clean         |                             0 |
    | maxwritten_clean      |                             0 |
    | buffers_backend       |                          3742 |
    | buffers_backend_fsync |                             0 |
    | buffers_alloc         |                          4555 |
    | stats_reset           | 2024-05-23 18:06:49.204361+00 |

Посредствам [cкрипта](https://gist.github.com/lesovsky/4587d70f169739c01d4525027c087d14) на одну контрольную точку
приходится: **5,28 MB**. *К сожалению, выполнение скрипта не попало в отчет*

В результате применимых настроек, видно наложение контрольных точек, что говорит об отсутствии необходимости в их частом запуске.

[![asciicast](https://asciinema.org/a/9qyfNDOyLzsz1Yof7wJN9rCnm.svg)](https://asciinema.org/a/9qyfNDOyLzsz1Yof7wJN9rCnm)

</details>

<details>
  <summary> ✔️ Сравнение режимов работы</summary>

**Затрагиваемые задачи**: 5

**Выполнение задания**:

* В ходе выполнения задания, были запущены 2 теста в разных режимах работы, статистика представлена ниже:

| param                                     | on         | off         |
|-------------------------------------------|------------|-------------|
| number of transactions actually processed | 13258      | 53887       |
| latency average                           | 2.263 ms   | 0.557 ms    |
| initial connection time                   | 3.433 ms   | 3.744 ms    |
| tps                                       | 441.966275 | 1796.429144 |

Из таблицы видно, что работа в асинхронном режиме обеспечивает более высокую производительность по количеству транзакций. Данный результат объясняется отсутствие ожидания записи в WAL.

[![asciicast](https://asciinema.org/a/GPyiZiynGFY92SR8uHpZzzDub.svg)](https://asciinema.org/a/GPyiZiynGFY92SR8uHpZzzDub)

</details>


<details>
  <summary> ✔️ Контрольная сумма страниц</summary>

**Затрагиваемые задачи**: 6

**Выполнение задания**:

* В ходе выполнения задания, был создан тестовый кластер с включенной контрольной суммой страниц и таблицей `test`.
* По средства утилиты `dd` были изменены байты в записи таблицы `test`.
* При попытке прочитать данные из таблицы было возвращено 0 записей. Данное поведение объясняется тем, при создании кластера был использован флаг `--data-checksums`, который гарантирует целостность данных на уровне байтов в файлах.

Способы решения:
* использование флага `ignore_checksum_failure`, который предупредит о несовпадении контрольной суммы данных, но позволит выполнить запрос;
* очистка таблицы посредствам команды `vacuum full`.

P.s. Использование данных методов не сможет восстановить битые данные.

[![asciicast](https://asciinema.org/a/yMS8zNz4Z8uEZCyCeI34BxWQu.svg)](https://asciinema.org/a/yMS8zNz4Z8uEZCyCeI34BxWQu)

</details>

### Используемые источники

* [CHECKPOINT](https://postgrespro.ru/docs/postgrespro/15/sql-checkpoint)
* [28.5. Настройка WAL](https://postgrespro.ru/docs/postgrespro/15/wal-configuration)
* [checkpoint_timeout](https://postgrespro.ru/docs/postgrespro/15/runtime-config-wal#GUC-CHECKPOINT-TIMEOUT)
* [Таблица 26.23. Представление pg_stat_bgwriter](https://postgrespro.ru/docs/postgrespro/15/monitoring-stats#MONITORING-PG-STAT-BGWRITER-VIEW)
* [Deep dive into postgres stats: pg_stat_bgwriter reports](https://dataegret.com/2017/03/deep-dive-into-postgres-stats-pg_stat_bgwriter-reports/)
* [28.2. Контрольные суммы данных](https://postgrespro.ru/docs/postgrespro/15/checksums)
* [data-checksums](https://postgrespro.ru/docs/postgrespro/15/app-initdb#APP-INITDB-DATA-CHECKSUMS)
* [Нюансы работы с PostgreSQL в 3 кейсах от DBA](https://habr.com/ru/companies/slurm/articles/574724/) - 2-ой кейс