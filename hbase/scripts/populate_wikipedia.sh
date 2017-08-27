#!/bin/bash

# wikipedia: ~20GB
#DUMP_URL="https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2"
# wiktionary: 0.5GB
DUMP_URL="https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2"
FILENAME="/wikipedia.xml.bz2"

if [ ! -f $FILENAME ]; then
    echo "Downloading wikipedia dump (this might take a while*100)"
    wget $DUMP_URL -O $FILENAME
else
    echo "Using cached $FILENAME"
fi

echo "Importing into HBase"
bzcat $FILENAME | hbase shell import_from_wikipedia.rb
