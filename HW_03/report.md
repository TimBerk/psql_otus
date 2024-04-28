# Установка и настройка PostgreSQL

<p align="left">
    <a href="https://www.postgresql.org/" target="blank">
        <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/>
    </a>
</p>

В качестве рабочего окружения используется Yandex Cloud. 
Дополнительно устанавливается решение [asciinema](https://asciinema.org/) - для составления интерактивного отчета.

Каждый этап имеет следующую структуру:
 * Номера затрагиваемых задач
 * Краткий отчет о том, что было сделано
 * Пример выполнения команд

## Оглавление

- [Задание](#задание)
- [Практика](#практика)
- [Дополнительная информация](#дополнительная-информация)


### Задание

1. создайте виртуальную машину c Ubuntu 20.04/22.04 LTS в GCE/ЯО/Virtual Box/докере
2. поставьте на нее PostgreSQL 15 через sudo apt
3. проверьте что кластер запущен через `sudo -u postgres pg_lsclusters`
4. зайдите из под пользователя postgres в psql и сделайте произвольную таблицу с произвольным содержимым

   ```bash
   postgres=# create table test(c1 text);
   postgres=# insert into test values('1');
   \q
   ```
5. остановите postgres например через `sudo -u postgres pg_ctlcluster 15 main stop`
6. создайте новый диск к ВМ размером 10GB
7. добавьте свеже-созданный диск к виртуальной машине - надо зайти в режим ее редактирования и дальше выбрать пункт attach existing disk
8. проинициализируйте диск согласно инструкции и подмонтировать файловую систему, только не забывайте менять имя диска на актуальное, в вашем случае это скорее всего будет /dev/sdb - https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
9. перезагрузите инстанс и убедитесь, что диск остается примонтированным (если не так смотрим в сторону fstab)
10. сделайте пользователя postgres владельцем /mnt/data - `chown -R postgres:postgres /mnt/data/`
11. перенесите содержимое /var/lib/postgres/15 в /mnt/data - `mv /var/lib/postgresql/15 /mnt/data`
12. попытайтесь запустить кластер - `sudo -u postgres pg_ctlcluster 15 main start`
13. напишите получилось или нет и почему
14. задание: найти конфигурационный параметр в файлах расположенных в /etc/postgresql/15/main который надо поменять и поменяйте его
15. напишите что и почему поменяли
16. попытайтесь запустить кластер - `sudo -u postgres pg_ctlcluster 15 main start`
17. напишите получилось или нет и почему
18. зайдите через psql и проверьте содержимое ранее созданной таблицы
19. задание со звездочкой *: не удаляя существующий инстанс ВМ сделайте новый, поставьте на его PostgreSQL, удалите файлы с данными из `/var/lib/postgres`, перемонтируйте внешний диск который сделали ранее от первой виртуальной машины ко второй и запустите PostgreSQL на второй машине так, чтобы он работал с данными на внешнем диске, расскажите как вы это сделали и что в итоге получилось.

### Практика

<details>
  <summary> ✔️ Установка и подготовка PostgreSQL</summary>

**Затрагиваемые задачи**: 1 - 6

**Выполнение задания**:

* В ходе выполнения задания, было настроено окружение в Yandex Cloud(Ubuntu 20.04 LTS OS Login).
* После подготовки образа, согласно материалам из лекции 3(Установка PostgreSQL) был установлен PostgreSQL 15 версии.
* После установки PostgreSQL, была создана таблица и вставлена тестовая запись.
* Дополнительно были проверены доступные диски для ВМ.

**Установка PostgreSQL**:

[![asciicast](https://asciinema.org/a/1DHpYJAYpHzOoMl2uvPJVtU7a.svg)](https://asciinema.org/a/1DHpYJAYpHzOoMl2uvPJVtU7a)

**Подготовка PostgreSQL**:

[![asciicast](https://asciinema.org/a/fuoV8DVVQSQdSpVHUyTEdZ94Q.svg)](https://asciinema.org/a/fuoV8DVVQSQdSpVHUyTEdZ94Q)

</details>

<details>
  <summary> ✔️ Работа с дополнительным диском</summary>

**Затрагиваемые задачи**: 7 - 13

**Выполнение задания**:

* Согласно приложенной инструкции, в Yandex Cloud был создан диск - disc2:
  * **Размер 20 ГБ**: (минимальный размер)
  * **Размер блока**:  4 КБ
  * **Тип**: HDD
  * **Макс. IOPS (чтение / запись)**: 300 / 300
  * **Макс. bandwidth (чтение / запись)**: 30 МБ/с / 30 МБ/с
* После создания диск был подключен к ВМ и настроен согласно инструкции из [официальной документации](https://yandex.cloud/ru/docs/compute/operations/vm-control/vm-attach-disk#mount). Ввиду того, что все действия были повторены из инструкции, в интерактивном отчете команд нет.
* После настроек диска, его раздел был примонтирован к директории `/mnt/data`, владельцем которой был назначен пользователь `postgres`.
* Содержимое папки `/var/lib/postgres/15` было перемещено в `/mnt/data`.
* При попытке запустить кластер возникла ошибка, согласно которой директория `/var/lib/postgres/15` не доступна или не существует.

**Пример**:

[![asciicast](https://asciinema.org/a/sBoMkXR51npCnaFPb2oKzU6I3.svg)](https://asciinema.org/a/sBoMkXR51npCnaFPb2oKzU6I3)

</details>

<details>
  <summary> ✔️ Решение проблемы с запуском кластера</summary>

**Затрагиваемые задачи**: 14 - 18

**Выполнение задания**:

* На прошлом этапе данные для PostgreSQL были перемещены в новую директорию `/mnt/data`, но при этом настройки не были изменены.
* В файле `/etc/postgresql/15/main/postgresql.conf` была внесена правка: `data_directory = '/mnt/data/15/main'`.
* После изменения каталога, хранящего данные, кластер запустился.
* Также дополнительно была проверена тестовая таблица.

**Пример**:

[![asciicast](https://asciinema.org/a/eVmqpZsxw2xy5BLKMNyy1zX1v.svg)](https://asciinema.org/a/eVmqpZsxw2xy5BLKMNyy1zX1v)

</details>

<details>
  <summary> ❌ Задание со звездочкой </summary>

**Затрагиваемые задачи**: 19

Ввиду отсутствия навыков работы с монтированием и настройкой дисков, дополнительное задание не было выполнено.

</details>


#### Дополнительная информация
* [DBA1-13. 10. Табличные пространства](https://www.youtube.com/watch?v=uPfM74fKm9o)
* [Разметка пустого диска в YandexCloud](https://yandex.cloud/ru/docs/compute/operations/vm-control/vm-attach-disk#mount)