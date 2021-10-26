#!/bin/bash

echo "Running all PostgreSQL scripts and queries in postgres-container"
echo "----------------------------------------------------------------"
echo "[1/3] Running script_db.sql"
docker exec postgres-container psql -U airflow -f /scripts/script_db.sql
echo "----------------------------------------------------------------"
echo "[2/3] Running query_top_100_purchasers.sql"
docker exec postgres-container psql -U airflow -f /scripts/query_top_100_purchasers.sql
echo "----------------------------------------------------------------"
echo "[3/3] Running query_avg_time_delta.sql"
docker exec postgres-container psql -U airflow -f /scripts/query_avg_time_delta.sql
echo "----------------------------------------------------------------"
echo "Finished running all PostgreSQL scripts and queries"