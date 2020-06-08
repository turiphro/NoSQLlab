NoSQL Database lab
------------------

This is a collection of ready-to-go experiments with various databases.

Every database is configured as a fully self-contained Hello World directory,
including [Docker compose](https://docs.docker.com/compose/) configuration,
scripts, and data.

The examples include non-trivial features that highlight some of the strengths
and peculiarities of the database. The databases are setup in a distributed
(multi-host) fashion. The hosts run in a local Docker network, which makes it
easy to simulate an actual cluster of hosts on a local machine. When desired,
the containers can be reused with more advanced container orchestration tools
(e.g., [Kubernetes](https://github.com/kubernetes/kompose)).

Start any database with:

    `docker-compose up`

Some databases allow dynamic scaling of the number of nodes (`--scale node=N`).

Each database provides the following scripts:

- `docker-compose run scripts ./populate.sh`: (big'ish) data generation, to have some data
- `docker-compose run scripts ./aggregate.sh`: perform some exemplar aggregation on the data

Read the corresponding README's for the database for specific instructions
(if any).
The scripts run in a separate container and usually include both local
database shell commands, and an actual client (in Ruby or JavaScript),
connecting to nodes in the cluster.

This database lab was inspired by the "7 Databases in 7 Weeks" book, but might
grow in database scope over time. I tried to pin all Docker containers to
specific versions; feel free to update or expand the examples where desired!
