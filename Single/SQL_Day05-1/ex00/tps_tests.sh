#!/bin/bash
HOST="localhost"
PORT="5432"
USER="data"
DATABASE="data"
DURATION="5"
FILES=("bench_view.sql" "bench_table.sql")
CLIENTS=(10 20 30 40)

run_tests() {
  local file=$1
  for c in "${CLIENTS[@]}"; do
    echo "Running test with -c $c for $file..."
    pgbench -h $HOST -p $PORT -U $USER -f $file -T $DURATION -c $c -r -n $DATABASE
    echo ""
    echo -e "\033[1;32mTest with -c $c for $file completed.\033[0m"
    echo ""
  done
}

for file in "${FILES[@]}"; do
  run_tests $file
done

echo "All tests completed!"