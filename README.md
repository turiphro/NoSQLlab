NoSQL Database lab
------------------

This is a collection of ready-to-go experiments with databases.

Every database has a Hello World setup with
[Docker compose](https://docs.docker.com/compose/) to run on any OS,
usually in a distributed (multi-host) fashion.
Start any database with:
    `docker-compose up`

Some databases might need to scale to multiple nodes (`--scale node=N`).

All databases have some example scripts that try to highlight some of the
strengths and peculiarities:

- `docker-compose run scripts ./propagate.sh`: (big) data generation, to have some data
- `docker-compose run scripts ./aggregate.sh`: perform some exemplar aggregation on the data

Read the corresponding README for the database for specific instructions.

This database lab was inspired by the "7 Databases in 7 Weeks" book, but will
grow in database scope over time. I tried to pin all Docker containers to
specific versions; feel free to update or expand the examples where desired!
