# Local Ruby example
# To be run locally (or on a node outside of the cluster)
# Alternatively, run on a host in the cluster: see aggregate_hotel_local.rb

$:.push('./gen-rb') # should have been generate by Thrift
require 'thrift'
require 'hbase'

socket = Thrift::Socket.new( ENV['THRIFT_HOST'], ENV['THRIFT_PORT'] )
transport = Thrift::BufferedTransport.new( socket )
protocol = Thrift::BinaryProtocol.new( transport )
client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new( protocol )

transport.open()

client.getTableNames().sort.each do |table|
    puts "#{table}"
    columnFamilies = client.getColumnDescriptors( table ).map { |col, desc| desc.name }
    puts "COLUMNS: #{columnFamilies}"

    count = 0

    scanner = client.scannerOpen( table, "", [], {} )
    while true
        rowresult = client.scannerGetList( scanner, 1000 )
        if rowresult.length > 0
            puts "[sample] #{rowresult[0].row} - #{rowresult[0].columns['properties:capacity'].value}"
            count += rowresult.length
        else
            break # done
        end
    end

    puts
    puts "Total number of rows: #{count}"
end

transport.close()
