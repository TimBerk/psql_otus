# Работа с уровнями изоляции транзакции в PostgreSQL

<p align="left">
    <a href="https://www.docker.com/" target="blank">
        <img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white" />
    </a>
    <a href="https://www.postgresql.org/" target="blank">
        <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/>
    </a>
</p>

В качестве рабочего окружения используется Docker-контейнер для PostgreSQL 16 версии.

Дополнительно устанавливается решение [asciinema](https://asciinema.org/) - для составления интерактивного отчета.

Каждое задание имеет следующую структуру:
 * SQL-скрипт для каждой сессии
 * Запись выполнения команд для каждой сессии
 * Вывод по выполненному заданию

## Оглавление
- [Подготовка](#подготовка)
- [1. Read committed isolation level](#1-read-committed-isolation-level)
- [2. Repeatable read isolation level](#2-repeatable-read-isolation-level)
- [Используемые источники](#используемые-источники)

### Подготовка

Используемые Make-команды:
* `run` - запуск контейнера
* `stop` - остановка контейнера
* `clear` - удаление контейнера и его volume
* `rebuild` - пересборка контейнера

Используемые консольные команды для окружения:
```bash
# Запуск командной строки в контейнере с PostgreSQL
winpty docker exec -it hw_01-db-1 //bin//bash
# Переход в рабочую директорию для сохранения отчетов
cd /home/caps
```

Подготовка консоли и таблицы для практики в `psql`:
```sql
-- Отключение и проверка autocommit
\set AUTOCOMMIT off
\echo :AUTOCOMMIT

-- Создание тестовых данных
create table persons( id serial, first_name text, second_name text);
insert into persons(first_name, second_name) values('ivan', 'ivanov'), ('petr', 'petrov');
commit;
```

[![asciicast](https://asciinema.org/a/QtfoMxhQbfVRXK0QXotWg3fqr.svg)](https://asciinema.org/a/QtfoMxhQbfVRXK0QXotWg3fqr)

### 1. Read committed isolation level

```sql
-- First session
\set AUTOCOMMIT off
show transaction isolation level;
insert into persons(first_name, second_name) values('sergey', 'sergeev');
-- Check result in second session
commit;
```

[![asciicast](https://asciinema.org/a/ZxobUp1Pxh0xNHs4G58uhf4Pz.svg)](https://asciinema.org/a/ZxobUp1Pxh0xNHs4G58uhf4Pz)

```sql
-- Second session
\set AUTOCOMMIT off
show transaction isolation level;
-- Check result after first session
select * from persons;
-- Check result after first session
select * from persons;
commit;
```

[![asciicast](https://asciinema.org/a/GnSJhX3Ne9J8HBAnfPi1Tkgr1.svg)](https://asciinema.org/a/GnSJhX3Ne9J8HBAnfPi1Tkgr1)

**Вывод**: После выполнения 1-й выборки данных новая запись не доступна для 2-ой сессии. После фиксации изменений в 1-ой сессии, во 2-ой сессии доступна новая запись. Данное поведение обусловлено тем, что при уровне изоляции `read committed` не допускается чтение незафиксированных данных.

### 2. Repeatable read isolation level

```sql
-- First session
\set AUTOCOMMIT off
set transaction isolation level repeatable read;
show transaction isolation level;
insert into persons(first_name, second_name) values('sveta', 'svetova');
-- Check result in second session
commit;
```

[![asciicast](https://asciinema.org/a/pC6F0VRQXKzWV1Tk1fu1WpXeh.svg)](https://asciinema.org/a/pC6F0VRQXKzWV1Tk1fu1WpXeh)

```sql
-- Second session
\set AUTOCOMMIT off
set transaction isolation level repeatable read;
show transaction isolation level;
-- Check result after command in first session
select * from persons;
-- Check result after commit in first session
select * from persons;

commit;
-- Check result after commit in second session
select * from persons;
```

[![asciicast](https://asciinema.org/a/tTFPu7uLyMXthTIfy1gA2ZkEI.svg)](https://asciinema.org/a/tTFPu7uLyMXthTIfy1gA2ZkEI)

**Вывод**: После выполнения 2-х выборок данных новая запись не доступна для 2-ой сессии. После фиксации транзакции во 2-ой сессии, ей доступна новая запись. Данное поведение обусловлено тем, что при уровне изоляции `repeatable read` не допускаются: феномен неповторяющегося чтения данных и чтение фантомных строк.

### Используемые источники
* [PostgreSQL. Основы языка SQL](https://postgrespro.ru/education/books/sqlprimer)