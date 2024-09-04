#!/usr/bin/env bash

set -e

# Function to print help message
print_help() {
    echo "Usage: build.sh [OPTIONS]"
    echo "Options:"
    echo "  --help            Display this help message"
    echo "  -h                Display this help message"
    echo "  --single-machine  Build the simulator and planning-control images for this platform"
    echo "Note: By default planning-control built for arm64 and simulator built for amd64"
    echo "      If you want to build both images for the amd64 platform use --single-machine"
}

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/.."

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

# Build images
build_images() {
    # https://github.com/docker/buildx/issues/484
    export BUILDKIT_STEP_LOG_MAX_SIZE=10000000

    set -x
    # Build images
    if [ -n "$option_single_machine" ]; then
        echo "Building images for platform: amd64(x86_64)"
        docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
            --set "*.context=$WORKSPACE_ROOT" \
            --set "*.ssh=default" \
            --set "*.platform=linux/amd64" \
            --set "*.args.ARCH=amd64" \
            --set "planning-control.tags=ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-planning-before-amd64" \
            --set "simulator.tags=ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-simulator-amd64" \
            simulator planning-control
    else
        echo "Building planning-control for platform: linux/arm64 and simulator for platform: linux/amd64"
        docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
            --set "*.context=$WORKSPACE_ROOT" \
            --set "*.ssh=default" \
            --set "*.platform=linux/arm64" \
            --set "*.args.ARCH=arm64" \
            --set "planning-control.tags=ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-planning-before-arm64" \
            planning-control

        docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
            --set "*.context=$WORKSPACE_ROOT" \
            --set "*.ssh=default" \
            --set "*.platform=linux/amd64" \
            --set "*.args.ARCH=amd64" \
            --set "simulator.tags=ghcr.io/autowarefoundation/openadkit_demo.autoware:ces-simulator-amd64" \
            simulator
    fi
    set +x
}

# Remove dangling images
remove_dangling_images() {
    docker image prune -f
}

# Main script execution
parse_arguments "$@"
build_images
remove_dangling_images