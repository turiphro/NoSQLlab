# Generate loads of rooms with random styles and capacities
require 'rubygems'
require 'riak'
STYLES = ['single', 'double', 'queen', 'king', 'suite']
FLOORS = 100
ROOMS_PER_FLOOR = 100

puts ENV['COORDINATOR_NODE']
client = Riak::Client.new(:host => ENV['COORDINATOR_NODE'])
bucket = client.bucket('rooms')

for floor in 0...FLOORS
    start = floor * ROOMS_PER_FLOOR
    puts "Making rooms #{start} - #{start + ROOMS_PER_FLOOR - 1}"
    for room in 0..ROOMS_PER_FLOOR
        ro = Riak::RObject.new(bucket, (start+room).to_s)
        ro.content_type = "application/json"
        ro.data = {
            'style' => STYLES[rand(STYLES.length)],
            'capacity' => rand(8) + 1
        }
        puts "Storing #{start+room}: #{ro.data}"
        begin
            ro.store()
        rescue
            puts "Failed; ignoring" # this happens often, somehow
        end
    end
end
