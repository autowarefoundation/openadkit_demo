#!/bin/bash

xhost +

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Use the script directory to make the docker-compose.yml path relative
docker compose -f "$SCRIPT_DIR/docker-compose-before.yml" up &

sleep 100

echo "terminating containers"

docker container stop $(docker ps -aq)

sleep 3

echo "terminated containers"
