#!/usr/bin/env bash

set -e

# rviz-visulaizer
docker run -it --net=host -v /dev/shm:/dev/shm -e ROS_DOMAIN_ID=88 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix  ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-visualizer /autoware/scenario-sim/rviz/launch_rviz.sh