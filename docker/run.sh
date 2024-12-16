#!/bin/bash

# Configure the environment variables
export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CONF_FILE_PASS=$SCRIPT_DIR/etc/simulation/config/pass_static_obstacle_avoidance.param.yaml
export CONF_FILE_FAIL=$SCRIPT_DIR/etc/simulation/config/fail_static_obstacle_avoidance.param.yaml
export CONF_FILE=$CONF_FILE_FAIL
export COMMON_FILE=$SCRIPT_DIR/etc/simulation/config/common.param.yaml
export NGROK_AUTHTOKEN=2guulYxBHQKJpe37Qp4PexfzXQm_3HSWKfiUgtKyxKmz2PJBo #your-auth-token via https://dashboard.ngrok.com/get-started/your-authtoken
export NGROK_URL=simviz.openadkit.ngrok.app #your-ngrok-url via https://dashboard.ngrok.com/domains

echo "COMMON_FILE: $COMMON_FILE"
echo "CONF_FILE_PASS: $CONF_FILE_PASS"
echo "CONF_FILE_FAIL: $CONF_FILE_FAIL"
echo "NGROK_AUTHTOKEN: $NGROK_AUTHTOKEN"
echo "NGROK_URL: $NGROK_URL"

if [ -z "$NGROK_AUTHTOKEN" ] || [ -z "$NGROK_URL" ]; then
    echo "NGROK_AUTHTOKEN and NGROK_URL are not set. Skipping NGROK setup."
    echo "Visualizer will not be accessible via web."
fi

# Start visualizer
docker compose -f "$SCRIPT_DIR/docker-compose.yml" up visualizer -d

# Start planning-control and simulator
while true; do
    echo "Updating planning container.."
    echo "Running planning v1.."
    TIMEOUT=70 CONF_FILE=$CONF_FILE_FAIL docker compose -f "$SCRIPT_DIR/docker-compose.yml" up planning-control simulator --abort-on-container-exit
    echo "Updating planning container.."
    echo "Running planning v2.."
    TIMEOUT=120 CONF_FILE=$CONF_FILE_PASS docker compose -f "$SCRIPT_DIR/docker-compose.yml" up planning-control simulator --abort-on-container-exit
done
