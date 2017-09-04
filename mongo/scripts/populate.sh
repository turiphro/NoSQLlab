#!/bin/bash
# Designed to be run inside container 'scripts'

# Check for healthy cluster - if not, need to run initiate script
HEALTHCHECK="mongo --host $COORDINATOR_NODE --port $COORDINATOR_PORT geography --eval 'db.healthy.insert({})'"

while [ eval $HEALTHCHECK | grep -E "writeError|failed" ]; do
    echo ">>>> Init cluster (once)"
    ./initiate.sh
done
echo ">>>> Cluster is initialised"

echo ">>>> Importing data.."
# Simple JSON importer
mongoimport --host $COORDINATOR_NODE --port $COORDINATOR_PORT --db geography --collection cities --file mongo_cities1000.json
# Or custom scripts
mongo --host $COORDINATOR_NODE --port $COORDINATOR_PORT < populate.js

if [ $? -ne 0 ]; then
    echo "Looks like this script failed. Please try running it again."
fi
