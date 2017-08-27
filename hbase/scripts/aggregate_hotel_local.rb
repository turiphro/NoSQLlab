# JRuby example
# To be run inside a node in the cluster.
# Alternatively, import Thrift and connect to the Hadoop
# cluster via the network (over the Thrift protocol): see aggregate_hotel.rb

require 'java'
require './utils'

import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'
import 'org.apache.hadoop.hbase.client.Scan'
import 'org.apache.hadoop.hbase.util.Bytes'
import 'org.apache.hadoop.hbase.HBaseConfiguration'
import 'org.apache.hadoop.hbase.client.HBaseAdmin'

hotels = HTable.new( HBaseConfiguration.new, 'hotel' )
scanner = hotels.getScanner( Scan.new )

# Ideally, we would dispatch a MapReduce job for
# aggregation here, see: org.apache.hadoop.hbase.mapreduce.*
# But for now, just iterate within this single thread.
count = 0
iter = 0
while (result = scanner.next())

  title = Bytes.toString( result.getRow() )
  capacity = Bytes.toString( result.getValue( *jbytes( 'properties', 'capacity' ) ) )
  style = Bytes.toString( result.getValue( *jbytes( 'visuals', 'style' ) ) )

  count += capacity.to_i

  puts "[sample] #{title} - #{style}" if iter % 1000 == 0
  iter += 1

end

puts
puts "Total capacity: #{count}"
