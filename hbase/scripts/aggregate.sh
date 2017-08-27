#!/bin/bash
# Designed to be run inside container 'scripts'
# Note: this will run inside a node that joins the cluster itself.
# Alternatively, one could run Ruby/Python/etc natively, and
# connect over the network via the Thrift protocol.

echo "##########################################"
echo "######### RUNNING LOCAL EXAMPLE ##########"
echo "##########################################"
hbase org.jruby.Main aggregate_hotel_local.rb

echo "##########################################"
echo "######### RUNNING THRIFT EXAMPLE #########"
echo "##########################################"
if hash thrift 2>/dev/null; then
    echo "Thrift was installed. Running Thrift example."
    echo
    ruby aggregate_hotel.rb
else
    echo "! Thrift was not installed. Skipping."
fi

