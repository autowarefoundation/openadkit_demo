# Autoware Open AD Kit - Planning Visualizer Demo

A containerized setup for Autoware Open AD Kit providing simulation, planning/control, and visualization capabilities.

## Quick Start

1. Set required ngrok variables if you want to access the visualizer remotely via WEB:

    ```bash
    export NGROK_AUTHTOKEN=#Your ngrok auth token via https://dashboard.ngrok.com/get-started/your-authtoken
    export NGROK_URL=#Your ngrok URL via https://dashboard.ngrok.com/domains
    ```

2. Start the containers:

    ```bash
    ./run.sh
    ```

3. Access visualization at:
   - Local: <http://localhost:6080>
   - Remote: Via Ngrok URL (if configured)

## Container Overview

### Simulator

- Runs scenario-based simulations
- Mounts scenarios from `./etc/simulation`

### Planning/Control

- Handles Autoware's planning and control stack
- Configurable via mounted parameter files
- Depends on simulator container

### Visualizer

- Provides VNC/NoVNC-based visualization
- Default VNC password: "openadkit"
- Optional Ngrok integration for remote access

## Development

Build containers locally:

    ./build.sh

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2.0+
- 16GB RAM recommended

For detailed documentation, visit [Open AD Kit Documentation](https://autowarefoundation.github.io/autoware-documentation/main/installation/autoware/docker-installation/).
