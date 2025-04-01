
To run the database, use `docker compose up`.

Note that `init.sql` will only be run if the data volume in the postgres docker image is empty.
See [here](https://hub.docker.com/_/postgres) for more details. To have a full fresh start of the database, use 
`docker compose down --volumes`.
