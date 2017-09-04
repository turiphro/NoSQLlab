require 'mongo'

client = Mongo::Client.new(
    [ ENV['COORDINATOR_NODE'] + ":" + ENV['COORDINATOR_PORT'] ], :database => 'geography'
)

db = client.database
print(db.collection_names)

collection = client[:phones]
collection.find({
    'components.number' => {'$gt' => 5599999},
    'display' => {'$exists' => true}
}).limit(5).each do |doc|
    puts doc[:display]
end

# For advanced aggregation/MapReduce, have a look at the aggregation.js script.
