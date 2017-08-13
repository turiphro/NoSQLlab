psql --version

psql -h $POSTGRES_HOST -U postgres < install.sql
psql -h $POSTGRES_HOST -U postgres < create_movies.sql
psql -h $POSTGRES_HOST -U postgres < movies_data.sql
