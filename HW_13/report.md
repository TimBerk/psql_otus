# Секционирование таблицы

<p align="left">
    <a href="https://www.docker.com/" target="blank">
        <img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white" />
    </a>
    <a href="https://www.postgresql.org/" target="blank">
        <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/>
    </a>
</p>

В качестве рабочего окружения используется PostgreSQL 13 версии установленный в Docker.

Дополнительно устанавливается решение [asciinema](https://asciinema.org/) - для составления интерактивного отчета.

Для работы используется демонстрационная база данных «Авиаперевозки».

Каждый этап имеет следующую структуру:

* Номера затрагиваемых задач
* Краткий отчет о том, что было сделано
* Пример выполнения команд

## Оглавление

- [Задание](#задание)
- [Практика](#практика)
- [Используемые источники](#используемые-источники)

### Задание

1. Секционировать большую таблицу из демо базы `flights`.

### Практика

Все запросы партиционирования приводятся с частичным копированием структуры исходной таблицы в целях сокращения время. В рабочем проекте происходило бы пересоздание индексов с последующим созданием партиций.

<details>
  <summary> ✔️ Создание новой партиционированной таблицы по списку</summary>

**Затрагиваемые задачи**: 1

**Выполнение задания**:

Работа осуществлялась с копией таблицы `ticket_flights`, разбиение было по колонке `fare_conditions`.

[![asciicast](https://asciinema.org/a/yueeiqgZ0LDTVBjJ5BZkSNQG1.svg)](https://asciinema.org/a/yueeiqgZ0LDTVBjJ5BZkSNQG1)

</details>

<details>
  <summary> ✔️ Создание новой партиционированной таблицы по диапозону</summary>

**Затрагиваемые задачи**: 1

**Выполнение задания**:

Работа осуществлялась с копией таблицы `bookings`(3-ая по размеру таблица), разбиение было по месяцам с апреля по август 2017 года.

[![asciicast](https://asciinema.org/a/EMWFBUEqNeol8OVJsl0Be9EJV.svg)](https://asciinema.org/a/EMWFBUEqNeol8OVJsl0Be9EJV)

</details>

<details>
  <summary> ✔️ Создание новой партиционированной таблицы по хэшу</summary>

**Затрагиваемые задачи**: 1

**Выполнение задания**:

Работа осуществлялась с копией таблицы `boarding_passes`(2-ая по размеру таблица), разбиение было по вычислению хеша от номера посадочного талона `ticket_no`.

[![asciicast](https://asciinema.org/a/bSpeR1aEBfFZsZwiFURCGLyyP.svg)](https://asciinema.org/a/bSpeR1aEBfFZsZwiFURCGLyyP)

</details>

<details>
  <summary> ✔️ Создание новой партиционированной таблицы с помощью pg_pathman</summary>

**Затрагиваемые задачи**: 1

**Выполнение задания**:

Работа осуществлялась с копией таблицы `bookings`(3-ая по размеру таблица), разбиение осуществлялось посредствам `pg_pathman` - с апреля по август 2017 года.

Предварительно нужно указать настройку в `postgresql.conf`:
```conf
shared_preload_libraries = 'pg_pathman'
```

[![asciicast](https://asciinema.org/a/30umSguh6dUi9KhMej8cFJHdD.svg)](https://asciinema.org/a/30umSguh6dUi9KhMej8cFJHdD)

P.s. В отличие от ручного задания запросов, использование `pg_pathman` предоставляет больше удобства. К сожалению решение не получилось установить на Postgres 15 и 16 версий.

</details>

### Используемые источники

[pg_pathman](https://github.com/postgrespro/pg_pathman)
