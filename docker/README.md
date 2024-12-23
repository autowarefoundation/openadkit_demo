# Autoware Open AD Kit - Planning Visualizer Demo

A containerized setup for Autoware Open AD Kit providing simulation, planning/control, and visualization capabilities.

## Quick Start

1. Start the containers:

    ```bash
    ./run.sh
    ```

2. Access visualization at:
   - Local: <http://localhost:6080/vnc.html>
   - Remote: Via <http://public-ip:6080/vnc.html> if you have a static public ip

> **Note** *(Optional)*
>
> If you do not have a static public ip and still want to access the visualizer remotely via WEB, set environment variable `NGROK_AUTHTOKEN` to your ngrok auth token:
>
>```bash
> export NGROK_AUTHTOKEN=#Your ngrok auth token via https://dashboard.ngrok.com/get-started/your-authtoken
>```

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
