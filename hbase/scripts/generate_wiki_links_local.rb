#---
# Excerpted from "Seven Databases in Seven Weeks",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rwdata for more book information.
#---

require 'java'

import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'
import 'org.apache.hadoop.hbase.client.Scan'
import 'org.apache.hadoop.hbase.util.Bytes'

def jbytes( *args )
  return args.map { |arg| arg.to_s.to_java_bytes }
end

# Create aggregation table
create 'links',
    {NAME => 'to', VERSIONS => 1, BLOOMFILTER => 'ROWCOL'},
    {NAME => 'from', VERSIONS => 1, BLOOMFILTER => 'ROWCOL'}

wiki_table = HTable.new( @hbase.configuration, 'wiki' )
links_table = HTable.new( @hbase.configuration, 'links' )
links_table.setAutoFlush( false )

scanner = wiki_table.getScanner( Scan.new ) # (1)

linkpattern = /\[\[([^\[\]\|\:\#][^\[\]\|:]*)(?:\|([^\[\]\|]+))?\]\]/
max_from = nil
max_to = nil
max_count = 0
count = 0

while (result = scanner.next())

  title = Bytes.toString( result.getRow() ) # (2)
  text = Bytes.toString( result.getValue( *jbytes( 'text', '' ) ) )

  if text
    put_to = nil
    column_count = 0
    text.scan(linkpattern) do |target, label| # (3)
      unless put_to
        put_to = Put.new( *jbytes( title ) )
        put_to.setWriteToWAL( false )
      end

      target.strip!
      target.capitalize!

      label = '' unless label
      label.strip!

      target_bytes = jbytes(target)[0]
      if target_bytes.length > 0
          put_to.add( *jbytes( "to", target, label ) )
          column_count += 1
          put_from = Put.new( target_bytes )
          put_from.add( *jbytes( "from", title, label ) )
          put_from.setWriteToWAL( false )
          links_table.put( put_from ) # (4)
      end
    end
    links_table.put( put_to ) if put_to and column_count > 0 # (5)
    links_table.flushCommits()

  end
  count += 1
  puts "#{count} pages processed (#{title})" if count % 500 == 0

end
links_table.flushCommits()

# Show some results
get 'links', 'Dutch'

exit
