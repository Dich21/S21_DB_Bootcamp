#!/bin/bash
HOST="localhost"
PORT="5432"
USER="data"
DATABASE="data"
DURATION="60"
FILES=("bench_view.sql" "bench_table.sql")
CLIENTS="10"

rm -f CSV/*.csv

run_tests() {
  local script_file="Scripts/$1"
  local csv_file="CSV/$1"
    echo "Running test with -c $c for $script_file..."

    pgbench -h $HOST -p $PORT -U $USER -f $script_file -T $DURATION -c $CLIENTS -n -l -r $DATABASE

    LOG_FILE=$(ls -t pgbench_log.* | head -n 1 2>/dev/null)
    if [ -z "$LOG_FILE" ]; then
      echo -e "\033[1;31mError: Log file not found!\033[0m"
      return 1
    fi

    LOG_FILE=$(ls -t pgbench_log.* | head -n 1)
    awk '{print $1","$2","$3","$4","$5","$6}' $LOG_FILE > "${csv_file}_log.csv"

    echo ""
    echo -e "\033[1;32mTest completed for $file. Data loaded to PostgreSQL.\033[0m\n"
    echo ""
}

for file in "${FILES[@]}"; do
  run_tests $file
done

rm -f pgbench_log.*

echo ""
echo "----------------------------------------"
echo "All tests completed!"
echo "----------------------------------------"