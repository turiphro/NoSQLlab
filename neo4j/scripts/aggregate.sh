#!/bin/bash

export DB_HOST=http://$COORDINATOR_NODE:7474

## Example queries
echo "Available relationship types:"
http GET "$DB_HOST/db/data/relationship/types"
echo "Some node:"
http GET "$DB_HOST/db/data/node/20"
http GET "$DB_HOST/db/data/node/20/properties"
http GET "$DB_HOST/db/data/node/20/relationships/all"

## Run aggregations
echo "Aggregations:"
CYPHER="db/data/cypher"
http POST "$DB_HOST/$CYPHER" query="MATCH (n) RETURN DISTINCT labels(n), count(n)"
http POST "$DB_HOST/$CYPHER" query="MATCH (p:Actor)-[:ACTED_IN]->(m:Movie {name: 'The Matrix'}) RETURN p" | jq ".data[][] | {label: .metadata.labels, name: .data.name}" -c

echo "Limited 'Kevin Bacon' number (here up til 3 degrees from Kevin Bacon = 6 hops)"
http POST "$DB_HOST/$CYPHER" query='MATCH (Actor {name:"Kevin Bacon"})-[:ACTED_IN*1..6]-(other:Actor) return COUNT(DISTINCT other)'

echo "A*:"
http POST "$DB_HOST/$CYPHER" query='MATCH (bacon:Actor {name: "Kevin Bacon"}), (neo:Actor {name: "Keanu Reeves"}), path=shortestPath((bacon)-[:ACTED_IN*]-(neo)) RETURN length(path)'  # 2 hops = same movie!
TOTAL=$(http POST "$DB_HOST/$CYPHER" query='MATCH (p:Actor) RETURN COUNT(DISTINCT p)' | jq ".data[][]")
echo "Reverse A* up to 2 hops (much slower):"
http POST "$DB_HOST/$CYPHER" query="MATCH paths=shortestPath((bacon:Actor {name: \"Kevin Bacon\"})-[:ACTED_IN*1..4]-(other:Actor)) WHERE bacon <> other RETURN COUNT(paths) / $TOTAL.0"  # 29% within 2 hops
echo "Any connection to Kevin Bacon (rest is islands; runtime ~30s):"
time http POST "$DB_HOST/$CYPHER" query="MATCH paths=shortestPath((bacon:Actor {name: \"Kevin Bacon\"})-[:ACTED_IN*]-(other:Actor)) WHERE bacon <> other RETURN COUNT(paths) / $TOTAL.0"  # 89.847% connected at all (89.838% connected within 6 degrees)
