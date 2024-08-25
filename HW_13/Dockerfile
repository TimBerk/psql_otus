FROM postgres:13

# Устанавливаем необходимые зависимости
RUN apt-get update && \
    apt-get install -y \
    git \
    asciinema \
    nano \
    build-essential \
    postgresql-server-dev-13 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Клонируем репозиторий pg_pathman
RUN git clone https://github.com/postgrespro/pg_pathman.git /pg_pathman

# Компилируем и устанавливаем расширение
WORKDIR /pg_pathman
RUN make USE_PGXS=1 && make USE_PGXS=1 install

# Устанавливаем рабочую директорию обратно в /
WORKDIR /
