#!/usr/bin/bash

set -e

# Start a PostgreSQL server using Docker and map port 5434 on the host machine to port 5432 in the container
if ! docker run -d --name NoTraffic-server -p 5434:5432 -e POSTGRES_PASSWORD=notraffic postgres; then
    echo "Failed to start PostgreSQL server using Docker"
    exit 1
fi

# Wait for the server to start up
echo "Waiting for PostgreSQL server to start..."
until docker exec NoTraffic-server pg_isready &>/dev/null; do
    sleep 1
done

# Copy the sample data model and data files to the Docker container
if ! docker cp sample-model.sql NoTraffic-server:/sample-model.sql; then
    echo "Failed to copy sample-model.sql to Docker container"
    docker stop NoTraffic-server
    exit 1
fi

if ! docker cp sample-data.sql NoTraffic-server:/sample-data.sql; then
    echo "Failed to copy sample-data.sql to Docker container"
    docker stop NoTraffic-server
    exit 1
fi

# Log in to the Docker container and run the model and data scripts
if ! docker exec -it NoTraffic-server bash -c "psql -U postgres -c 'CREATE DATABASE sample_database;'" ; then
    echo "Failed to create sample_database"
    docker stop NoTraffic-server
    exit 1
fi

if ! docker exec -it NoTraffic-server bash -c "psql -U postgres -d sample_database -f sample-model.sql" ; then
    echo "Failed to execute sample-model.sql"
    docker stop NoTraffic-server
    exit 1
fi

if ! docker exec -it NoTraffic-server bash -c "psql -U postgres -d sample_database -f sample-data.sql" ; then
    echo "Failed to execute sample-data.sql"
    docker stop NoTraffic-server
    exit 1
fi

# start the Docker container
docker start NoTraffic-server

echo "Database created and populated successfully"
