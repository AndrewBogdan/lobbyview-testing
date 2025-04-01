FROM postgres:latest

# The data used to initialize the database.
COPY data /data/

# This entrypoint is only run when the pgdata volume is empty.
# That means, if it errors and you want to re-run it, you need to clear the volume.
COPY init.sql /docker-entrypoint-initdb.d/
