#!/bin/bash
HOST="localhost"
PORT="5432"
USER="data"
DATABASE="data"
DURATION="10"
FILES=("tsquery_bench.sql")
CLIENTS=(1)

pgbench -h $HOST -p $PORT -U $USER -f $FILES -T $DURATION -c $CLIENTS -r -n $DATABASE
    echo ""
    echo -e "\033[1;32mTest with -c $c for $FILES completed.\033[0m"
    echo ""

echo "All tests completed!"