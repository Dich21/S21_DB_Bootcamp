#!/bin/bash
HOST="localhost"
PORT="5432"
USER="data"
DATABASE="data"
DURATION="180"
CLIENTS="5"

# Тестирование READ COMMITTED
echo -e "\033[1;33mTesting READ COMMITTED isolation level\033[0m"
pgbench -h $HOST -p $PORT -U $USER $DATABASE \
        -T $DURATION -c $CLIENTS -n -r -f read_committed.sql

# Тестирование SERIALIZABLE
echo -e "\033[1;33mTesting SERIALIZABLE isolation level\033[0m"
pgbench -h $HOST -p $PORT -U $USER $DATABASE \
        -T $DURATION -c $CLIENTS -n -r -f serializable.sql

echo -e "\033[1;32mBenchmarks completed. Results saved to:\033[0m"