#!/bin/bash
# Designed to be run inside container 'scripts'

export DB_HOST=$COORDINATOR_NODE

echo "-> Adding some test data"
redis-cli -h $DB_HOST SET name "Martijn"
redis-cli -h $DB_HOST SET eyes "blue" EX 60
redis-cli -h $DB_HOST GET name
redis-cli -h $DB_HOST SET databases:todo 1
redis-cli -h $DB_HOST SET databases:done 6
redis-cli -h $DB_HOST < commands.redis
sleep 1
redis-cli -h $DB_HOST TTL eyes

# or via TCP (telnet, nc)
echo -e "GET eyes\r\n" | nc $DB_HOST 6379 -q 0

echo "-> Async queues"
redis-cli -h $DB_HOST BRPOP comments 10 &  # blocking, background task
sleep 1
redis-cli -h $DB_HOST LPUSH comments "This is a great comment"

echo "-> Adding ISBN database to *replicas*"
# NOTE: I reduced the original isbn.tsv file to 10%;
#       you can extract the original from a Freebase dump.
ruby importer_isbn.rb isbn_small.tsv

echo "-> Adding ISBN database to *shards*"
# NOTE: I reduced the original isbn.tsv file to 10%;
#       you can extract the original from a Freebase dump.
ruby importer_isbn_sharded.rb isbn_small.tsv
