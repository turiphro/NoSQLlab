#!/bin/bash
# Designed to be run inside container 'scripts'

export DB_HOST=http://$COORDINATOR_NODE:7474

echo "Adding some test data (via REST)"
http POST "$DB_HOST/db/data/transaction/commit" < create_users.json

# Indices created up front dramatically speed up insertion
http POST "$DB_HOST/db/data/cypher" query="CREATE INDEX ON :Actor(name)"
http POST "$DB_HOST/db/data/cypher" query="CREATE INDEX ON :Movie(name)"

echo "Adding movie database (this will take a while)"
ruby importer.rb performance.tsv

