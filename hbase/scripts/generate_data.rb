# JRuby example
# To be run inside a node in the cluster.
# Alternatively, import Thrift and connect to the Hadoop
# cluster via the network (over the Thrift protocol).

# Needs JRuby; mixes Java and (J)Ruby and runs as JRuby script on the hbase node
# Based on 7 databases in 7 weeks book and a lot of trying

require 'java'
require './utils'

import 'org.apache.hadoop.hbase.HBaseConfiguration'
import 'org.apache.hadoop.hbase.client.HBaseAdmin'


puts "(re)creating table 'hotel'"
conf = HBaseConfiguration.new
admin = HBaseAdmin.new( conf )
table = drop_and_create( admin, 'hotel', ['visuals', 'properties'] )


# Generate some data
STYLES = ['single', 'double', 'queen', 'king', 'suite']
FLOORS = 100
ROOMS_PER_FLOOR = 100

count = 0
for floor in 0...FLOORS
    start = floor * ROOMS_PER_FLOOR
    puts "Making rooms #{start} - #{start + ROOMS_PER_FLOOR - 1}"
    for room in 0..ROOMS_PER_FLOOR
        data = {
            "visuals:style" => STYLES[ rand(STYLES.length) ],
            "properties:capacity" => rand(8) + 1
        }
        puts "Storing #{start+room}: #{data}"
        insert( table, (start+room).to_s, data )
        count += 1
    end
end

puts
puts "Table now has #{count} rows."
