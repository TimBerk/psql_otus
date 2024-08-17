# Работа с join'ами, статистикой

<p align="left">
    <a href="https://www.docker.com/" target="blank">
        <img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white" />
    </a>
    <a href="https://www.postgresql.org/" target="blank">
        <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/>
    </a>
</p>

В качестве рабочего окружения используется PostgreSQL 16 версии установленный в Docker.

Дополнительно устанавливается решение [asciinema](https://asciinema.org/) - для составления интерактивного отчета.

Для работы с индексами используется демонстрационная база данных «Авиаперевозки».

Каждый этап имеет следующую структуру:

* Номера затрагиваемых задач
* Краткий отчет о том, что было сделано
* Пример выполнения команд

## Оглавление

- [Задание](#задание)
- [Практика](#практика)
- [Используемые источники](#используемые-источники)

### Задание

1. Реализовать прямое соединение двух или более таблиц
2. Реализовать левостороннее (или правостороннее) соединение двух или более таблиц
3. Реализовать кросс соединение двух или более таблиц
4. Реализовать полное соединение двух или более таблиц
5. Реализовать запрос, в котором будут использованы разные типы соединений
6. Сделать комментарии на каждый запрос
7. К работе приложить структуру таблиц, для которых выполнялись соединения
8. *Придумайте 3 своих метрики на основе показанных представлений

### Практика

<details>
  <summary> ✔️ Реализовать прямое соединение двух или более таблиц</summary>

**Затрагиваемые задачи**: 1,6

**Выполнение задания**:

* Для таблицы полеты дополнительно вывести читабельные названия аэропортов и самолета.
* Работа осуществляется посредствам join к 2 таблицам `airports` и `aircrafts_data`. `airports` используется дважды для отображения аэропортов отправления и прибытия.

[![asciicast](https://asciinema.org/a/xM67E8SeoRf3sDqJg2DpIAT69.svg)](https://asciinema.org/a/xM67E8SeoRf3sDqJg2DpIAT69)

</details>

<details>
  <summary> ✔️ Реализовать левостороннее (или правостороннее) соединение двух или более таблиц</summary>

**Затрагиваемые задачи**: 2,6

**Выполнение задания**:

* Вывести 5 аэропортов с наибольшей суммой броней за лето 2017 года, при отсутствии записей вывести ноль.
* Так как нужно рассчитать полную сумму бронирований, то необходимо реализовать следующую цепочку связей `airports` -> `flights` -> `boarding_passes` -> `tickets` -> `bookings`;
* После указания всех связей, достаточно сгруппировать данные по коду, названию и городу аэропорта и указать сортировку по убыванию суммы.

[![asciicast](https://asciinema.org/a/P3MwOqJA5OGFKj1llXg8GjYqS.svg)](https://asciinema.org/a/P3MwOqJA5OGFKj1llXg8GjYqS)

</details>

<details>
  <summary> ✔️ Реализовать кросс соединение двух или более таблиц</summary>

**Затрагиваемые задачи**: 3,6

**Выполнение задания**:

* Вывести комбинацию названия моделей самолетов и названия аэропортов.

[![asciicast](https://asciinema.org/a/5b6tMgqsJdz9eQOp9AFxJiTYY.svg)](https://asciinema.org/a/5b6tMgqsJdz9eQOp9AFxJiTYY)

</details>

<details>
  <summary> ✔️ Реализовать полное соединение двух или более таблиц</summary>

**Затрагиваемые задачи**: 4,6

**Выполнение задания**:

* Найти модели самолетов, которые не осуществляли вылеты.
* Для удобства работы, запрос с полным соединением вынесен в выражение `with`

[![asciicast](https://asciinema.org/a/wZiKxa5HOCiCDvjdYtVFbPQRU.svg)](https://asciinema.org/a/wZiKxa5HOCiCDvjdYtVFbPQRU)

</details>

<details>
  <summary> ✔️ Реализовать запрос, в котором будут использованы разные типы соединений</summary>

**Затрагиваемые задачи**: 5,6

**Выполнение задания**:

* Определить максимальное/минимальное количество посадочных талонов для вылетевших рейсов из аэропорта Шереметьево;
* `join` используется для полного соединение таблиц полетов и данных аэропортов;
* `left join` используется для расчета количества посадочных талонов, в случае их отсутствия будет выведен 0;

[![asciicast](https://asciinema.org/a/QzI9ITi1RDwgyjwRpl3wcov84.svg)](https://asciinema.org/a/QzI9ITi1RDwgyjwRpl3wcov84)

</details>

<details>
  <summary> ✔️ К работе приложить структуру таблиц, для которых выполнялись соединения</summary>

**Затрагиваемые задачи**:7

**Выполнение задания**:

[Объекты схемы](https://postgrespro.ru/docs/postgrespro/16/demodb-schema-objects)

![Schema database](https://repo.postgrespro.ru/doc//std/15.8.1/ru/html/demodb-bookings-schema.svg)

</details>

<details>
  <summary> ✔️ * Придумайте 3 своих метрики на основе показанных представлений</summary>

**Затрагиваемые задачи**:8

**Выполнение задания**:

Предварительно убедиться, что включено решение `pg_stat_statements`:
```sql
show shared_preload_libraries;
create extension pg_stat_statements;
```

### 1. Среднее Количество Строк, Обрабатываемых Запросом (Average Rows Processed per Query)

Эта метрика показывает, сколько строк в среднем обрабатывается каждым запросом. Она может помочь выявить запросы, которые работают с большими объемами данных.

```math
Среднее Количество Строк, Обрабатываемых Запросом = Сумма Строк, Обрабатываемых Всеми Запросами / Количество Запросов
```

```sql
WITH row_counts AS (
    SELECT query, (rows / calls) AS avg_rows FROM pg_stat_statements
)
SELECT AVG(avg_rows) AS average_rows_processed_per_query FROM row_counts;

-- Example result
 average_rows_processed_per_query 
----------------------------------
               35901.562500000000
(1 row)
```

### 2. Среднее Количество Подключений (Average Number of Connections)

Эта метрика показывает среднее количество активных подключений к базе данных. Высокое значение может указывать на необходимость увеличения ресурсов или оптимизации подключений.

```math
Среднее Количество Подключений = Сумма Подключений за Период / Количество Интервалов
```

```sql
SELECT AVG(numbackends) AS average_number_of_connections FROM pg_stat_database;

-- Example result
 average_number_of_connections 
-------------------------------
        0.20000000000000000000
(1 row)
```

### 3. Процент Сканирований Индексов (Index Scan Percentage)
Эта метрика показывает, сколько процентов сканирований используют индексы.

```math
Процент Сканирований Индексов = (Количество Сканирований Индексов / Общее Количество Сканирований) * 100
```

```sql
WITH scan_stats AS (
    SELECT idx_scan AS index_scans, (idx_scan + seq_scan) AS total_scans
    FROM pg_stat_user_tables
)

SELECT (index_scans / total_scans) * 100 AS index_scan_percentage FROM scan_stats;

-- Example result
 index_scan_percentage 
-----------------------
(0 rows)
```

### 4. Процент Использования Буфера (Buffer Utilization Percentage)

Эта метрика показывает, насколько используется буфер базы данных.

```math
Процент Использования Буфера = (Количество Попаданий в Буфер / Общее Количество Операций Ввода-Вывода) * 100
```

```sql
WITH buffer_stats AS (
    SELECT
        buffers_clean AS buffer_hits,
        (buffers_clean + buffers_backend) AS total_io
    FROM pg_stat_bgwriter
)

SELECT (buffer_hits / total_io) * 100 AS buffer_utilization_percentage
FROM buffer_stats;

-- Example result
 buffer_utilization_percentage 
-------------------------------
                             0
(1 row)
```

### 5. Процент Использования ЦП на Запрос (CPU Utilization per Query Percentage)

Эта метрика показывает, насколько используется процессор на каждый запрос

```sql
WITH cpu_query_stats AS (
    SELECT
        query,
        (total_exec_time + total_plan_time) AS total_query_time,  -- Total query execution time (execution + planning)
        calls AS total_queries,
        (total_exec_time + total_plan_time) / calls AS avg_query_time_per_query  -- Average query time per query
    FROM
        pg_stat_statements
)
SELECT
    query,
    avg_query_time_per_query,
    (avg_query_time_per_query / total_query_time) * 100 AS cpu_utilization_per_query_percentage
FROM cpu_query_stats;

-- Example result
                              query                               | avg_query_time_per_query | cpu_utilization_per_query_percentage 
------------------------------------------------------------------+--------------------------+--------------------------------------
 ALTER DATABASE demo SET bookings.lang = ru                       |                 0.084503 |                                  100
 ALTER DATABASE demo SET search_path = bookings, public           |                 0.214409 |                                  100
 ALTER SEQUENCE flights_flight_id_seq OWNED BY flights.flight_id  |                   0.1376 |                                  100
```

</details>

### Используемые источники

[9.27. Функции для системного администрирования](https://postgrespro.ru/docs/postgrespro/16/functions-admin)