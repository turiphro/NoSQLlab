#!/bin/bash
# Designed to be run inside container 'scripts'

export DB_HOST=http://admin:secret@$COORDINATOR_NODE:5984

http PUT  $DB_HOST/testdb
http POST $DB_HOST/testdb <item.json

echo "Populating database with data from Jamendo"
echo "Check results via the UI exposed to the host OS:"
echo "http://127.0.0.1:5984/_utils/#/_all_dbs"

zcat dbdump_artistalbumtrack.xml.gz | ruby import_from_jamendo.rb
