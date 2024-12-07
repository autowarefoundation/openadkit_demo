#!/bin/bash

xhost +

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Use the script directory to make the docker-compose.yml path relative
$SCRIPT_DIR/run-before.sh

sleep 5

$SCRIPT_DIR/run-after.sh
