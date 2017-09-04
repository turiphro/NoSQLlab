#!/bin/bash
# Designed to be run inside container 'scripts'

# Run commands inside the Mongo client:
echo "----------- MONGO SHELL -----------"
mongo --host $COORDINATOR_NODE --port $COORDINATOR_PORT < aggregate.js

# Or connect from your favourite language:
echo "----------- RUBY SCRIPT -----------"
ruby aggregate.rb
