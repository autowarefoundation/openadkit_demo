#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2124
# Function to print help message
print_help() {
    echo "Usage: run.sh [OPTIONS] user@ip_address_of_target_machine"
    echo "Options:"
    echo "  --help            Display this help message"
    echo "  -h                Display this help message"
    echo "  --single-machine  Run the simulator and planning-control images for amd64 platform"
}

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")

set -e

# Parse arguments
parse_arguments() {
    while [ "$1" != "" ]; do
        case "$1" in
            --help | -h)
                print_help
                exit 1
                ;;
            --single-machine)
                option_single_machine="true"
                ;;
            *)
                echo "Unknown option: $1"
                print_help
                exit 1
                ;;
        esac
        shift
    done
}

parse_arguments "$@"

if [ "$option_single_machine" = "true" ]; then
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" up
else
    echo "Hybrid mode is not supported yet (WIP), please use --single-machine option"
fi