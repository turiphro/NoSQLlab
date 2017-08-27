require 'java'
require './utils'
import 'org.apache.hadoop.hbase.HBaseConfiguration'
import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.HTableDescriptor'
import 'org.apache.hadoop.hbase.HColumnDescriptor'
import 'org.apache.hadoop.hbase.client.Put'
import 'org.apache.hadoop.hbase.util.Bytes'

def jbytes( *args )
    return args.map { |arg| arg.to_s.to_java_bytes }
end

def drop_and_create( admin, table_name, families )
    table = HTableDescriptor.new( table_name )
    for family_name in families
        family = HColumnDescriptor.new( family_name )
        table.addFamily( family )
    end
    if admin.tableExists( table_name )
        admin.disableTable( table_name )
        admin.deleteTable( table_name )
    end
    admin.createTable( table )
    HTable.new( admin.getConfiguration(), table_name )
end

def insert( table, row, column_values )
    p = Put.new( *jbytes( row ) )
    for key, value in column_values
        family, column = key.split(':')
        p.add( *jbytes( family, column, value ) )
    end
    table.put( p )
end

