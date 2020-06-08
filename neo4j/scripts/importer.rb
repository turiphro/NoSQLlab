# Notes by turiphro:
# - The tsv dataset from the first edition wasn't available anymore;
#   the neo4j dump is outdated and hard to import from a separate Docker container.
#   Therefore, I extracted an old version of the dataset from the 1GB+ archive (6GB+ data) at
#   https://archive.org/download/freebase-data-dump-2010-07-16/freebase-datadump-tsv.tar.bz2
# - Importer script inspired by importer.rb from 7DB in 7wks 1st edition,
#   but refactored to send Cypher to the node4j server (since the REST API was removed in 4.0+).

require "faraday"


REST_URL = ENV["DB_HOST"]
REST_CYPHER_ENDPOINT = "db/data/cypher"

puts REST_URL
conn = Faraday.new(:url => REST_URL) do |builder|
  builder.adapter :net_http
end


count = 0
File.open(ARGV[0], :encoding => 'UTF-8').each do |line|
  _, _, actor, movie = line.split("\t")
  next if actor.empty? || movie.empty?

  # add actor node, movie node, and relationship
  cypher_query = 
    "MERGE (actor:Actor {name:\"#{actor}\"})
     MERGE (movie:Movie {name:\"#{movie}\"})
     MERGE (actor)-[:ACTED_IN]->(movie)"

  conn.post(REST_CYPHER_ENDPOINT, "query=#{cypher_query}")

  puts "   #{count} relationships loaded" if (count += 1) % 1000 == 0
end
