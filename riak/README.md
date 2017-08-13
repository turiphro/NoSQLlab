Start with:

	docker-compose up -d --scale member=5

See status with:

    docker-compose exec member riak-admin cluster status

Run scripts with:

	docker-compose run scripts ./propagate.sh
	docker-compose run scripts ./aggregate.sh
