#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2124
SCRIPT_DIR=$(readlink -f "$(dirname "$0")")

set -e
docker compose -f "$SCRIPT_DIR/docker-compose.yml" up