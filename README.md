NoSQL Database lab
------------------

This is a collection of ready-to-go experiments with databases.

Every database has a Hello World setup with
[Docker compose](https://docs.docker.com/compose/) to run on any OS,
usually in a distributed (multi-host) fashion. The hosts run in a local
Docker network, which makes it easy to simulate an actual cluster of hosts,
running on a local machine. When desired, the containers can be reused with
more advanced container orchestration tools
(e.g., [Kubernetes](https://github.com/kubernetes/kompose)).

Start any database with:

    `docker-compose up`

Some databases allow dynamic scaling of the number of nodes (`--scale node=N`).

All databases have some example scripts that try to highlight some of the
strengths and peculiarities, and each database provides the following scripts:

- `docker-compose run scripts ./populate.sh`: (big'ish) data generation, to have some data
- `docker-compose run scripts ./aggregate.sh`: perform some exemplar aggregation on the data

Read the corresponding README's for the database for specific instructions.
The scripts usually include both local database shell commands, and an actual
client (in Ruby) connecting to the cluster.

This database lab was inspired by the "7 Databases in 7 Weeks" book, but might
grow in database scope over time. I tried to pin all Docker containers to
specific versions; feel free to update or expand the examples where desired!
