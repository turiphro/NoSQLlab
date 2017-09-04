NoSQL Database lab
------------------

This is a collection of ready-to-go experiments with databases.

Every database has a Hello World setup with
[Docker compose](https://docs.docker.com/compose/) to run on any OS,
usually in a distributed (multi-host) fashion. The hosts run in a local
Docker network, which is probably the closest you can get to a simulation
of an actual cluster of hosts on a local machine.

Start any database with:
    `docker-compose up`

Some databases might need to scale to multiple nodes (`--scale node=N`).

All databases have some example scripts that try to highlight some of the
strengths and peculiarities, and each database provides the following scripts:

- `docker-compose run scripts ./populate.sh`: (big'ish) data generation, to have some data
- `docker-compose run scripts ./aggregate.sh`: perform some exemplar aggregation on the data

Read the corresponding README's for the database for specific instructions.

This database lab was inspired by the "7 Databases in 7 Weeks" book, but might
grow in database scope over time. I tried to pin all Docker containers to
specific versions; feel free to update or expand the examples where desired!
