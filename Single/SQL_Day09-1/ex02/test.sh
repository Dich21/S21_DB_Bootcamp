#!/bin/bash
HOST="localhost"
PORT="5432"
USER="data"
DATABASE="data"
DURATION="180"
FILES=("plpgsql_bench.sql" "sql_bench.sql")
CLIENTS="5"

echo -e "\033[1;36mStarting performance comparison...\033[0m"

for file in "${FILES[@]}"; do
    echo -e "\033[1;33mTesting $file with $CLIENTS clients\033[0m"
    pgbench -h $HOST -p $PORT -U $USER $DATABASE \
            -T $DURATION -c $CLIENTS -r -n -f $file
    echo -e "\033[1;32mTest $file completed.\033[0m\n"
done

echo -e "\033[1;35mAll benchmarks executed!\033[0m"