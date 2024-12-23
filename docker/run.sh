#!/bin/bash

# Configure the environment variables
export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CONF_FILE_PASS=$SCRIPT_DIR/etc/simulation/config/pass_static_obstacle_avoidance.param.yaml
export CONF_FILE_FAIL=$SCRIPT_DIR/etc/simulation/config/fail_static_obstacle_avoidance.param.yaml
export CONF_FILE=$CONF_FILE_FAIL
export COMMON_FILE=$SCRIPT_DIR/etc/simulation/config/common.param.yaml
export NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN #your-auth-token via https://dashboard.ngrok.com/get-started/your-authtoken
export NGROK_URL=$NGROK_URL #If you have paid account, your-ngrok-url via https://dashboard.ngrok.com/domains


# Start visualizer and show logs
docker compose -f "$SCRIPT_DIR/docker-compose.yml" up visualizer -d
echo "Waiting 10 seconds for visualizer to start..."
sleep 10
docker compose -f "$SCRIPT_DIR/docker-compose.yml" logs visualizer

# Start planning-control and simulator
while true; do
    echo "Updating planning container.."
    echo "Running planning v1.."
    TIMEOUT=70 CONF_FILE=$CONF_FILE_FAIL docker compose -f "$SCRIPT_DIR/docker-compose.yml" up planning-control simulator --abort-on-container-exit
    echo "Updating planning container.."
    echo "Running planning v2.."
    TIMEOUT=120 CONF_FILE=$CONF_FILE_PASS docker compose -f "$SCRIPT_DIR/docker-compose.yml" up planning-control simulator --abort-on-container-exit
done
