#!/bin/bash

export DB_HOST=http://admin:secret@$COORDINATOR_NODE:5984

## Save some views
# Map only:
http PUT $DB_HOST/music/_design/artists < view_map_artists.json
# Map + Reduce:
http PUT $DB_HOST/music/_design/tags < view_map_reduce_tags.json
echo "Views:"
http GET $DB_HOST/music/_design/artists
http GET $DB_HOST/music/_design/tags

## Run aggregations
echo "Aggregations:"
http GET "$DB_HOST/music/_design/artists/_view/by-name?limit=5"
# second time is quicker due to caching
http GET "$DB_HOST/music/_design/artists/_view/by-name?limit=5&descending=true"
# Map-reduce job is pretty slow
http GET "$DB_HOST/music/_design/tags/_view/counts?limit=5&reduce=true&group=true"

## Changes API
echo "Recent changes:"
http GET "$DB_HOST/music/_changes?limit=3&include_docs=false"  # docs are large

