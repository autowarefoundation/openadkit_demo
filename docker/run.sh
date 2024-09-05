#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2124
# Function to print help message
print_help() {
    echo "Usage: run.sh [OPTIONS] user@ip_address_of_target_machine"
    echo "Options:"
    echo "  --help            Display this help message"
    echo "  -h                Display this help message"
    echo "  --single-machine  Run the simulator and planning-control images for amd64 platform"
    echo "  --target-machine  user@ip_address_of_target_machine"
    echo "  --target-machine-port  port_number (default port is 22)"
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
            --target-machine)
                target_machine="$2"
                shift
                ;;
            --target-machine-port)
                target_machine_port="$2"
                shift
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
    # check if the target machine is valid
    if [ -z "$target_machine" ]; then
        echo "Target machine is not set, please set the target machine with --target-machine option"
        echo "Example: run.sh --target-machine user@192.168.1.1"
        exit 1
    fi

    # default port is 22
    if [ -z "$target_machine_port" ]; then
        target_machine_port=22
    fi
    
    # run the simulator image on the host machine
    docker run -it --net=host -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/shm:/dev/shm -v /etc/localtime:/etc/localtime:ro ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-simulator-amd64 ros2 launch scenario_test_runner scenario_test_runner.launch.py architecture_type:=awf/universe record:=false scenario:=/autoware/scenario-sim/yield_maneuver_demo.yaml sensor_model:=sample_sensor_kit vehicle_model:=sample_vehicle map_path:=/autoware/scenario-sim/map/ global_timeout:=240 initialize_duration:=90 launch_autoware:=false launch_rviz:=false &

    # login to the target machine and run the planning-control image
    echo "Login to the target machine: $target_machine"
    ssh "$target_machine" -p "$target_machine_port" "docker run --net=host -v /dev/shm:/dev/shm -v /etc/localtime:/etc/localtime:ro ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-planning-before-amd64 ros2 launch autoware_launch planning_simulator.launch.xml map_path:=/autoware/scenario-sim/map/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit scenario_simulation:=true use_foa:=false perception/enable_traffic_light:=false rviz:=false"
fi