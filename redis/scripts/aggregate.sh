#!/bin/bash

export DB_HOST=$COORDINATOR_NODE

## Example queries
redis-cli -h $DB_HOST GET 9780387976921

# Replication
echo "-> Reading from replica(s)"
redis-cli -h ${NODE_BASENAME}_replica_1 GET name           # works
redis-cli -h ${NODE_BASENAME}_replica_1 SET name "reader"  # not allowed

# Sharding
echo "-> Reading from multiple masters (sharded by client)"
for key in $(shuf -n 5 isbn_small.tsv | cut -d$'\t' -f1); do
    echo -n "query $key in $DB_HOST: "
    redis-cli -h $DB_HOST GET "sharded-$key"
    echo -n "query $key in ${NODE_BASENAME}_shard_1: "
    redis-cli -h ${NODE_BASENAME}_shard_1 GET "sharded-$key"
done

## Run aggregations
