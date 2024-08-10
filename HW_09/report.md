# Резервное копирование и восстановление 

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

Каждый этап имеет следующую структуру:

* Номера затрагиваемых задач
* Краткий отчет о том, что было сделано
* Пример выполнения команд

## Оглавление

- [Задание](#задание)
- [Практика](#практика)
- [Используемые источники](#используемые-источники)

### Задание

1. Создаем ВМ/докер c ПГ.
2. Создаем БД, схему и в ней таблицу.
3. Заполним таблицы автосгенерированными 100 записями.
4. Под линукс пользователем Postgres создадим каталог для бэкапов
5. Сделаем логический бэкап используя утилиту `COPY`
6. Восстановим в 2 таблицу данные из бэкапа.
7. Используя утилиту `pg_dump` создадим бэкап в кастомном сжатом формате двух таблиц
8. Используя утилиту `pg_restore` восстановим в новую БД только вторую таблицу!

### Практика

<details>
  <summary> ✔️ Работа с логическим бэкапом</summary>

**Затрагиваемые задачи**: 1-6

**Выполнение задания**:

* Создан каталог `/home/backups/` с установленным владельцем `postgres`.
* Создана БД `base`, схема `backup` и таблица `publications` с автосгенерированными 100 записями.
* Сделан логический бэкап посредствам утилиты `COPY`.
* Создана пустая таблица `publications_backup`, далее она заполнена данными из файла логического бэкапа.

[![asciicast](https://asciinema.org/a/Q2l5EfoPlwObx0wfQ4R7FMbyo.svg)](https://asciinema.org/a/Q2l5EfoPlwObx0wfQ4R7FMbyo)

</details>

<details>
  <summary> ✔️ Работа с бэкапом посредствам pg_dump и pg_restore</summary>

**Затрагиваемые задачи**: 7-8

**Выполнение задания**:

* Используя утилиту `pg_dump` был создан бэкап в кастомном сжатом формате двух таблиц `/home/backups/backup_dump.gz`;
* Была создана новая БД - `homework` и схема `backup`;
* Используя утилиту `pg_restore` была восстановлена только вторая таблица `publications_backup` в БД `homework`.

[![asciicast](https://asciinema.org/a/mpUPdfg0KV8jxuZMVq1i6cMJq.svg)](https://asciinema.org/a/mpUPdfg0KV8jxuZMVq1i6cMJq)

</details>

### Используемые источники

* [createdb](https://postgrespro.ru/docs/postgresql/16/app-createdb)
* [dropdb](https://www.postgresql.org/docs/current/app-dropdb.html)
* [COPY](https://www.postgresql.org/docs/current/sql-copy.html)
* [pg_restore](https://postgrespro.ru/docs/postgresql/16/app-pgrestore)