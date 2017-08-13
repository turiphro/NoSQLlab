#!/bin/bash

# Save some queries
http $COORDINATOR_NODE:8098/riak/functions/map_capacity < map1_code.js
http $COORDINATOR_NODE:8098/riak/functions/reduce_capacity < reduce1_code.js

# Run aggregation
http $COORDINATOR_NODE:8098/mapred < mapreduce1.json
