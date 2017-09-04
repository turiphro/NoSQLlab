// Aggregate on data in MongoDB database
// Uses Mongo shell commands (not a standalone script)

use geography


/* Simple queries */

print("--------------------------")
print(".find(Amsterdam):")
db.cities.find({name: "Amsterdam"})

amsterdam = db.cities.find({name: /^Amst[aoeu]rdam$/, country: "NL"})[0]
print(".find(above amsterdam):")
db.cities.find({'location.longitude': {$gt: amsterdam.location.longitude}}).count()

var range = {}
range['$lt'] = 1e6
range['$gt'] = 1e5
print(".find(mid-size cities ^P):")
db.cities.find({name: /^P/, population: range}, {name: 1, _id: 0})

print("--------------------------")
print("Nested queries:")
db.cities.find(
    {
        $or: [
            {famous_for: /light/, 'mayor.party': {$exists: true}},
            {name: /^Londonder/}
        ],
        population: {$type: 'number'}
    },
    {name: 1, famous_for: 1, mayor: 1, population: 1, _id: 0}
)

print("--------------------------")
print("Updating")
db.cities.update(
    {_id: amsterdam['_id']},
    {
        $set: {'age': 550},
        $inc: {'population': 1000},
        $push: {'famous_for': "Anne Frankhuis"}
    }
)
db.cities.findOne({_id: amsterdam._id})

print("--------------------------")
print("Adding indices for speed improvements")

db.cities.createIndex({location: "2d"})
db.cities.find({location: {$near: [45.52, -122.67]}}).limit(5)

db.phones.dropIndexes()
// explain the plan, and include the results (executionStats)
explained_before = db.phones.find({display: "+1 867-5309000"}).explain("executionStats")
print(explained_before)
db.phones.createIndex(
    {display: 1},
    {unique: true, dropDups: true}
)
db.phones.createIndex(
    {'components.area': 1, 'components.number': 1},
    {background: 1} // async
)
print(db.phones.getIndices())
explained_after = db.phones.find({display: "+1 867-5309000"}).explain("executionStats")
print("Before: " + explained_before.executionStats.executionTimeMillis + "ms")
print("After: " + explained_after.executionStats.executionTimeMillis + "ms")


/* MapReduce & Aggregation */

// Simple aggregation built-ins
print("--------------------------")
print("Numbers before 5550005")
db.phones.distinct(
    'components.number', // field to return in array
    {'components.number': {$lt: 5550005}} // find
)
print("number of phones above 5599999 (slow, iterating on all)")
const start_grp = new Date()
db.phones.group({ // NOTE: officially doesn't work for sharded setups
    initial: {count: 0, max: 0}, // initial output
    reduce:  function(phone, output) {
                // function to run on each item (item, ongoing_result)
                output.count++;
                output.max = Math.max(output.max, phone.components.number);
             },
    cond:    {'components.number': {$gt: 5599999}}, // find
    key:     {'components.area': true} // group by
})
print("Query (group built-in) took " + (new Date() - start_grp) + "ms")

// Aggregation framework
// Same query as before, but much quicker (20x on this machine)
const start_aggr = new Date()
db.phones.aggregate([
    {$match: {'components.number': {$gt: 5599999}}},
    {$group: {
        _id: '$components.area',
        count: {$sum: 1},
        max: {$max: '$components.number'}
    }}
])
print("Query (aggregation framework) took " + (new Date() - start_aggr) + "ms")

// MapReduce framework
const start_mr = new Date()
load('map.js') // could also be saved server-side
load('reduce.js')
db.phones.mapReduce(
    map_count,
    reduce_count,
    {
        query: {'components.number': {$gt: 5599999}},
        out: {inline: 1}
    }
).results
print("Query (MapReduce framework) took " + (new Date() - start_mr) + "ms")
