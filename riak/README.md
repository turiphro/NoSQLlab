Start with:

	docker-compose up -d --scale node=5

See status with:

    docker-compose exec node riak-admin cluster status

Run scripts with:

	docker-compose run scripts ./propagate.sh
	docker-compose run scripts ./aggregate.sh
