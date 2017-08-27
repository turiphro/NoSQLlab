#!/bin/bash
# Designed to be run inside container 'scripts'
# Note: this will run inside a node that joins the cluster itself.
# Alternatively, one could run Ruby/Python/etc natively, and
# connect over the network via the Thrift protocol.

hbase org.jruby.Main generate_data.rb
