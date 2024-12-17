#!/bin/bash

# Configure the environment variables
export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CONF_FILE_PASS=$SCRIPT_DIR/etc/simulation/config/pass_static_obstacle_avoidance.param.yaml
export CONF_FILE_FAIL=$SCRIPT_DIR/etc/simulation/config/fail_static_obstacle_avoidance.param.yaml
export CONF_FILE=$CONF_FILE_FAIL
export COMMON_FILE=$SCRIPT_DIR/etc/simulation/config/common.param.yaml
export NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN #your-auth-token via https://dashboard.ngrok.com/get-started/your-authtoken
export NGROK_URL=$NGROK_URL #your-ngrok-url via https://dashboard.ngrok.com/domains

if [ -z "$NGROK_AUTHTOKEN" ]; then
    echo "Skipping NGROK setup as NGROK_AUTHTOKEN is not set."
    echo "Visualizer running on http://localhost:6080/vnc.html"
else
    if [ -n "$NGROK_URL" ]; then
        echo "Visualizer will be accessible via web at https://$NGROK_URL/vnc.html"
    else
        echo "NGROK_URL is not set, visualizer will be accessible via web at ngrok specific URL"
    fi
fi

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
