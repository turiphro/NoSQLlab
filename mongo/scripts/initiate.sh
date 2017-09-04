#!/bin/bash
# Based on:
# https://github.com/singram/mongo-docker-compose/blob/master/initiate
# This is pretty ugly, so I hope it's possible to write nice configs (or have
# auto-discovery of hosts) at some point.

echo "This scripts is going to take a minute or so."
echo "============================================="

sleep 5

for (( rs = 1; rs < 3; rs++ )); do
  echo "> Intializing replica ${rs} set (between mongorsNnM's)"
  command="rs.initiate(); sleep(1000); cfg = rs.conf(); cfg.members[0].host = \"mongors${rs}n1:27018\"; sleep(1000);rs.reconfig(cfg); rs.add(\"mongors${rs}n2:27018\"); rs.addArb(\"mongors${rs}n3:27018\"); rs.status();"
  echo ${command} | mongo --host mongors${rs}n1 --port 27018
  sleep 1
done

sleep 10

echo "> Intializing replica set for mongoconfig (between mongocfgN's)"
command="rs.initiate(); sleep(1000); cfg = rs.conf(); cfg.members[0].host = \"mongocfg1:27019\"; rs.reconfig(cfg); rs.add(\"mongocfg2:27019\"); rs.add(\"mongocfg3:27019\"); rs.status();"
echo "${command}" | mongo --host mongocfg1 --port 27019

sleep 15

echo "> Adding shards to mongos endpoints (mongosS -> mongorsNnM)"
echo "sh.addShard('mongors1/mongors1n1:27018,mongors1n2:27018'); sh.addShard('mongors2/mongors2n1:27018,mongors2n2:27018');sh.status()" | mongo --host mongos1 --port 27017
echo "sh.addShard('mongors1/mongors1n1:27018,mongors1n2:27018'); sh.addShard('mongors2/mongors2n1:27018,mongors2n2:27018');sh.status()" | mongo --host mongos2 --port 27017

sleep 10
