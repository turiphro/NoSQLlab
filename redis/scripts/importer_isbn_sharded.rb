#---
# Excerpted from "Seven Databases in Seven Weeks",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rwdata for more book information.
#---
LIMIT = 1.0 / 0

%w{rubygems time redis}.each{|r| require r}
require 'redis/distributed'


$redis = Redis::Distributed.new([
  "redis://" + ENV["DB_HOST"] + ":6379/",
  "redis://" + ENV["NODE_BASENAME"] + "_shard_1:6379/"
])
#$redis.flushall

count, start = 0, Time.now
File.open(ARGV[0], :encoding => 'UTF-8').each do |line|
  count += 1
  next if count == 1
  isbn, _, _, title = line.split("\t")
  next if isbn.empty? || title == "\n"

  $redis.set("sharded-" + isbn, title.strip)

  puts "#{count} items" if count % 1000 == 0

  # set the LIMIT value if you do not wish to populate the entire dataset
  break if count >= LIMIT
end

puts "#{count} items in #{Time.now - start} seconds"
