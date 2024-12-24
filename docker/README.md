# Autoware Open AD Kit - Planning Visualizer Demo

A containerized setup for Autoware Open AD Kit providing simulation, planning/control, and visualization capabilities.

## Quick Start

1. Start the containers:

    ```bash
    ./run.sh
    ```

2. Access visualization at the following URLs:
   - Local: <http://localhost:6080/vnc.html>
   - Remote: Via <http://your-public-ip:6080/vnc.html> (if you have a static public ip)

> **Note** *(Optional)*
>
> If you do not have a static public ip and still want to access the visualizer remotely via WEB, set environment variable `NGROK_AUTHTOKEN`
>
>```bash
> export NGROK_AUTHTOKEN=#Your ngrok auth token via https://dashboard.ngrok.com/get-started/your-authtoken
>```
>
>If you have a paid ngrok account, you can set `NGROK_URL` to your ngrok url:
>
>```bash
> export NGROK_URL=#Your ngrok url via https://dashboard.ngrok.com/domains
>```
>
> Then you can access the visualizer via WEB at <http://your-ngrok-public-url:6080/vnc.html>

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
