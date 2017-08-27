Start with:

    docker-compose up -d

Run scripts with:

    docker-compose exec scripts ./populate.sh
    docker-compose exec scripts ./aggregate.sh

	docker-compose run scripts ./populate_wikipedia.sh
	docker-compose run scripts ./aggregate_wikipedia.sh

hbase shell access:

    docker-compose run scripts hbase shell


To make clusters of different sizes, the easiest way is to regenerate docker-compose.yml.
See the README at https://github.com/smizy/docker-hbase
and copy-paste the 'scripts' host from the docker-compose.yml in this directory.

