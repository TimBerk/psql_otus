# Нагрузочное тестирование и тюнинг PostgreSQL

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

1. развернуть виртуальную машину любым удобным способом
2. поставить на неё PostgreSQL 15 любым способом
3. настроить кластер PostgreSQL 15 на максимальную производительность не обращая внимание на возможные проблемы с
   надежностью в случае аварийной перезагрузки виртуальной машины
4. нагрузить кластер через утилиту через утилиту pgbench (https://postgrespro.ru/docs/postgrespro/15/pgbench)
5. написать какого значения tps удалось достичь, показать какие параметры в какие значения устанавливали и почему
6. Задание со *: аналогично протестировать через утилиту https://github.com/Percona-Lab/sysbench-tpcc (требует установки
   https://github.com/akopytov/sysbench)

### Практика

<details>
  <summary> ✔️ Работа с PgBench</summary>

**Затрагиваемые задачи**: 1-5

**Выполнение задания**:

* В ходе выполнения задания, был использован Docker-контейнер с предварительной установкой SysBench.
* Для тестирования были подготовлены 4 файла конфигураций(исходные файлы размещены в папке conf):
  1. Предлагаемая конфигурация PGTune для web-приложений
  2. Предлагаемая конфигурация PGTune для oltp-приложений
  3. Кастомная конфигурация для достижения максимального количества транзакций в секунду (TPS).
  4. Кастомная конфигурация для достижения максимального количества транзакций в секунду (TPS), не принимая во внимание безопасные настройки.
* Результаты тестов приведены в таблице:

| Параметры                                 | Базовые настройки | Conf 1(web) | Conf 2(oltp) | Conf 3     | Conf 4     |
|-------------------------------------------|-------------------|-------------|--------------|------------|------------|
| number of transactions actually processed | 37264             | 36730       | 36871        | 36953      | 37104      |
| latency average                           | 160.967 ms        | 163.375 ms  | 162.642 ms   | 162.373 ms | 161.741 ms |
| latency stddev                            | 267.496 ms        | 326.003 ms  | 285.113 ms   | 405.516 ms | 304.079 ms |
| initial connection time                   | 108.419 ms        | 80.363 ms   | 121.281 ms   | 110.915 ms | 82.823 ms  |
| tps                                       | 620.327856        | 611.160849  | 613.964569   | 614.845781 | 617.308537 |
| tps(max)                                  | 625.3             | 618.3       | 620.0        | 639.1      | 623.7      |
| tps(sysbench max)                         | 889.81            | 858.20      | 901.60       | 924.69     | 911.81     |

 **Base Configuration**

[![asciicast](https://asciinema.org/a/qTILDhrBelVrRzLfoOsnp5e44.svg)](https://asciinema.org/a/qTILDhrBelVrRzLfoOsnp5e44)

 **Configuration 1(web)**

[![asciicast](https://asciinema.org/a/3e8ABL5TeHCTQritfzinTzAoE.svg)](https://asciinema.org/a/3e8ABL5TeHCTQritfzinTzAoE)

**Configuration 2(oltp)**
[![asciicast](https://asciinema.org/a/XExyrVgEXK9irzFuuOO5qtv8l.svg)](https://asciinema.org/a/XExyrVgEXK9irzFuuOO5qtv8l)

**Configuration 3**

[![asciicast](https://asciinema.org/a/iZdsJajvYZdMxyoMJbJi0Pr4T.svg)](https://asciinema.org/a/iZdsJajvYZdMxyoMJbJi0Pr4T)

**Configuration 4**

[![asciicast](https://asciinema.org/a/15eEflPSoMmz9xNPEnhKHDf91.svg)](https://asciinema.org/a/15eEflPSoMmz9xNPEnhKHDf91)

В результате проведенных тестов видно, что большого смысла в редактировании стандартных настроек для предложенного образа PostgreSQL нет. Изменяемы параметры:

* **work_mem**: для обеспечения достаточной памяти для всех подключений, был уменьшен во 2 конфигурации.
* **synchronous_commit**: для максимального TPS он отключен, что означает, что транзакции фиксируются асинхронно, что может привести к снижению надежности.
* **wal_level**: для максимальной производительности установлено минимальное значение, что уменьшит объем журналирования.
* **full_page_writes**: отключен, чтобы уменьшить накладные расходы WAL.
* **checkpoint_timeout**: для максимальной производительности установлено 15 минут, чтобы уменьшить частоту контрольных точек.

</details>

<details>
  <summary> ✔️ Работа с SysBench</summary>

**Затрагиваемые задачи**: 6

**Выполнение задания**:

* Предварительно в папку tmp был распакован архив с последней версией SysBench.
* В ходе выполнения задания использовались вспомогательные bash-скрипты для подготовки, запуска и очистки окружения.
* Результаты тестирования представлены в таблице(дополнительная информация с указанием tps указана в следующей секции):

| Параметры                   | Базовые настройки       | Конфигурация 1(web)    | Конфигурация 2(oltp)    | Конфигурация 3          |                           |
|-----------------------------|-------------------------|------------------------|-------------------------|-------------------------|---------------------------|
| **SQL statistics:**         |                         |                        |                         |                         |                           |
| queries performed:          |                         |                        |                         |                         |                           |
| read                        | 712306                  | 686084                 | 711004                  | 734202                  | 687162                    |
| write                       | 203516                  | 196024                 | 203144                  | 209772                  | 196332                    |
| other                       | 101758                  | 98012                  | 101572                  | 104886                  | 98166                     |
| total                       | 1017580                 | 980120                 | 1015720                 | 1048860                 | 981660                    |
| transactions                | 50879  (847.87 p.s.)    | 49006  (816.63 p.s.)   | 50786  (846.35 p.s.)    | 52443  (873.98 p.s.)    | 49083  (817.97 p.s.)      |
| queries                     | 1017580 (16957.49 p.s.) | 980120 (16332.56 p.s.) | 1015720 (16926.94 p.s.) | 1048860 (17479.61 p.s.) | 981660 (16359.42 p.s.)    |
| ignored errors              | 0                       | 0                      | 0                       |                         |                           |
| reconnects                  | 0                       | 0                      | 0                       |                         |                           |
|                             |                         |                        |                         |                         |                           |
| **Throughput:**             |                         |                        |                         |                         |                           |
| events/s (eps):             | 847.8743                | 816.6278               | 846.3469                | 873.9804                | 817.9709                  |
| time elapsed                | 60.0077s                | 60.0102s               | 60.0061s                | 60.0048s                | 60.0058s                  |
| total number of events      | 50879                   | 49006                  | 50786                   | 52443                   | 49083                     |
|                             |                         |                        |                         |                         |                           |
| **Latency (ms)**            |                         |                        |                         |                         |                           |
| min                         | 3.66                    | 3.56                   | 3.63                    | 3.60                    | 3.67                      |
| avg                         | 7.07                    | 7.34                   | 7.09                    | 6.86                    | 7.33                      |
| max                         | 671.91                  | 473.47                 | 493.58                  | 482.70                  | 473.19                    |
| 95th percentile             | 8.74                    | 9.22                   | 8.74                    | 8.28                    | 9.22                      |
| sum                         | 359921.75               | 359935.41              | 359923.12               | 359916.20               | 359907.12                 |
|                             |                         |                        |                         |                         |                           |
| **Threads fairness:**       |                         |                        |                         |                         |                           |
| events (avg/stddev)         | 8479.8333/34.45         | 8167.6667/31.00        | 8464.3333/14.60         | 8740.5000/28.37         | 8180.5000/21.12           |
| execution time (avg/stddev) | 59.9870/0.00            | 59.9892/0.00           | 59.9872/0.00            | 59.9860/0.00            | 59.9845/0.00              |

Единственное, весьма интересна разница tps между тестами PgBench и SysBench.
</details>

<details>
  <summary> Вывод работы SysBench</summary>

```sql
-- Common initialization information
sysbench 1.1.0 (using bundled LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 6
Report intermediate results every 10 second(s)
Initializing random number generator from current time
```

```sql
-- Base configuration
[ 10s ] thds: 6 tps: 862.78 qps: 17267.02 (r/w/o: 12087.34/3453.52/1726.16) lat (ms,95%): 7.84 err/s: 0.00 reconn/s: 0.00
[ 20s ] thds: 6 tps: 889.81 qps: 17796.24 (r/w/o: 12457.37/3559.25/1779.62) lat (ms,95%): 8.13 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 6 tps: 846.60 qps: 16929.92 (r/w/o: 11851.12/3385.60/1693.20) lat (ms,95%): 8.58 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 6 tps: 805.70 qps: 16113.54 (r/w/o: 11280.46/3221.69/1611.39) lat (ms,95%): 9.22 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 6 tps: 842.19 qps: 16839.64 (r/w/o: 11786.59/3368.67/1684.38) lat (ms,95%): 9.06 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 6 tps: 840.10 qps: 16802.75 (r/w/o: 11761.74/3360.81/1680.21) lat (ms,95%): 9.22 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            712306
        write:                           203516
        other:                           101758
        total:                           1017580
    transactions:                        50879  (847.87 per sec.)
    queries:                             1017580 (16957.49 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      847.8743
    time elapsed:                        60.0077s
    total number of events:              50879

Latency (ms):
         min:                                    3.66
         avg:                                    7.07
         max:                                  671.91
         95th percentile:                        8.74
         sum:                               359921.75

Threads fairness:
    events (avg/stddev):           8479.8333/34.45
    execution time (avg/stddev):   59.9870/0.00
```

```sql
-- Configuration 1
[ 10s ] thds: 6 tps: 775.59 qps: 15518.19 (r/w/o: 10863.45/3102.96/1551.78) lat (ms,95%): 9.39 err/s: 0.00 reconn/s: 0.00
[ 20s ] thds: 6 tps: 832.81 qps: 16655.19 (r/w/o: 11658.10/3331.46/1665.63) lat (ms,95%): 9.06 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 6 tps: 818.20 qps: 16369.66 (r/w/o: 11459.24/3274.01/1636.41) lat (ms,95%): 9.39 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 6 tps: 757.19 qps: 15138.66 (r/w/o: 10597.43/3026.85/1514.38) lat (ms,95%): 10.27 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 6 tps: 858.20 qps: 17166.43 (r/w/o: 12016.55/3433.39/1716.49) lat (ms,95%): 9.06 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 6 tps: 857.90 qps: 17154.20 (r/w/o: 12007.20/3431.30/1715.70) lat (ms,95%): 8.58 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            686084
        write:                           196024
        other:                           98012
        total:                           980120
    transactions:                        49006  (816.63 per sec.)
    queries:                             980120 (16332.56 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      816.6278
    time elapsed:                        60.0102s
    total number of events:              49006

Latency (ms):
         min:                                    3.56
         avg:                                    7.34
         max:                                  473.47
         95th percentile:                        9.22
         sum:                               359935.41

Threads fairness:
    events (avg/stddev):           8167.6667/31.00
    execution time (avg/stddev):   59.9892/0.00
```

```sql
-- Configuration 2
[ 10s ] thds: 6 tps: 704.01 qps: 14091.08 (r/w/o: 9864.40/2818.06/1408.63) lat (ms,95%): 11.24 err/s: 0.00 reconn/s: 0.00
[ 20s ] thds: 6 tps: 894.39 qps: 17884.58 (r/w/o: 12519.85/3575.96/1788.78) lat (ms,95%): 8.28 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 6 tps: 901.60 qps: 18030.57 (r/w/o: 12621.25/3606.21/1803.11) lat (ms,95%): 8.43 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 6 tps: 834.70 qps: 16696.88 (r/w/o: 11687.98/3339.40/1669.50) lat (ms,95%): 8.58 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 6 tps: 873.01 qps: 17461.93 (r/w/o: 12222.69/3493.23/1746.01) lat (ms,95%): 9.22 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 6 tps: 870.20 qps: 17403.09 (r/w/o: 12182.36/3480.32/1740.41) lat (ms,95%): 8.28 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            711004
        write:                           203144
        other:                           101572
        total:                           1015720
    transactions:                        50786  (846.35 per sec.)
    queries:                             1015720 (16926.94 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      846.3469
    time elapsed:                        60.0061s
    total number of events:              50786

Latency (ms):
         min:                                    3.63
         avg:                                    7.09
         max:                                  493.58
         95th percentile:                        8.74
         sum:                               359923.12

Threads fairness:
    events (avg/stddev):           8464.3333/14.60
    execution time (avg/stddev):   59.9872/0.00
```

```sql
-- Configuration 3
[ 10s ] thds: 6 tps: 832.40 qps: 16658.80 (r/w/o: 11661.80/3331.60/1665.40) lat (ms,95%): 9.22 err/s: 0.00 reconn/s: 0.00
[ 20s ] thds: 6 tps: 924.69 qps: 18490.38 (r/w/o: 12943.91/3697.08/1849.39) lat (ms,95%): 7.98 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 6 tps: 841.89 qps: 16841.96 (r/w/o: 11788.50/3369.67/1683.79) lat (ms,95%): 8.58 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 6 tps: 879.00 qps: 17574.56 (r/w/o: 12302.44/3514.11/1758.01) lat (ms,95%): 8.28 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 6 tps: 866.99 qps: 17341.77 (r/w/o: 12140.04/3467.75/1733.98) lat (ms,95%): 8.28 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 6 tps: 898.62 qps: 17975.29 (r/w/o: 12581.88/3596.18/1797.24) lat (ms,95%): 8.28 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            734202
        write:                           209772
        other:                           104886
        total:                           1048860
    transactions:                        52443  (873.98 per sec.)
    queries:                             1048860 (17479.61 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      873.9804
    time elapsed:                        60.0048s
    total number of events:              52443

Latency (ms):
         min:                                    3.60
         avg:                                    6.86
         max:                                  482.70
         95th percentile:                        8.28
         sum:                               359916.20

Threads fairness:
    events (avg/stddev):           8740.5000/28.37
    execution time (avg/stddev):   59.9860/0.00
```

```sql
-- Configuration 4
[ 10s ] thds: 6 tps: 799.59 qps: 16000.54 (r/w/o: 11201.12/3199.65/1599.77) lat (ms,95%): 8.43 err/s: 0.00 reconn/s: 0.00
[ 20s ] thds: 6 tps: 911.81 qps: 18235.23 (r/w/o: 12765.26/3646.35/1823.62) lat (ms,95%): 8.28 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 6 tps: 821.50 qps: 16430.42 (r/w/o: 11501.41/3286.00/1643.00) lat (ms,95%): 9.06 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 6 tps: 716.09 qps: 14320.83 (r/w/o: 10024.28/2864.37/1432.18) lat (ms,95%): 16.41 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 6 tps: 826.81 qps: 16539.74 (r/w/o: 11577.27/3308.85/1653.62) lat (ms,95%): 9.22 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 6 tps: 831.78 qps: 16635.51 (r/w/o: 11644.92/3327.02/1663.56) lat (ms,95%): 9.73 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            687162
        write:                           196332
        other:                           98166
        total:                           981660
    transactions:                        49083  (817.97 per sec.)
    queries:                             981660 (16359.42 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      817.9709
    time elapsed:                        60.0058s
    total number of events:              49083

Latency (ms):
         min:                                    3.67
         avg:                                    7.33
         max:                                  473.19
         95th percentile:                        9.22
         sum:                               359907.12

Threads fairness:
    events (avg/stddev):           8180.5000/21.12
    execution time (avg/stddev):   59.9845/0.00
```
</details>

### Используемые источники

* [PGTune](https://github.com/le0pard/pgtune)
* [sysbench - утилита тестирования производительности](https://redos.red-soft.ru/base/manual/utilites/hardware-stress-test/sysbench/)

