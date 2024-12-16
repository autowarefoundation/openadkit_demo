#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONF_FILE_PASS=$SCRIPT_DIR/etc/simulation/config/pass_static_obstacle_avoidance.param.yaml
CONF_FILE_FAIL=$SCRIPT_DIR/etc/simulation/config/fail_static_obstacle_avoidance.param.yaml
COMMON_FILE=$SCRIPT_DIR/etc/simulation/config/common.param.yaml
source ./simulator.env

# Start visualizer
TIMEOUT=60 COMMON_FILE=$COMMON_FILE CONF_FILE=$CONF_FILE_PASS docker compose -f "$SCRIPT_DIR/docker-compose.yml" up web-visualizer -d

# Start planning-control and simulator
while true; do
    echo "Updating planning container.."
    echo "Running planning v1.."
    TIMEOUT=70 COMMON_FILE=$COMMON_FILE CONF_FILE=$CONF_FILE_FAIL docker compose -f "$SCRIPT_DIR/docker-compose.yml" up planning-control simulator --abort-on-container-exit
    echo "Updating planning container.."
    echo "Running planning v2.."
    TIMEOUT=120 COMMON_FILE=$COMMON_FILE CONF_FILE=$CONF_FILE_PASS docker compose -f "$SCRIPT_DIR/docker-compose.yml" up planning-control simulator --abort-on-container-exit
done
