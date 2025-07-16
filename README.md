# Open AD Kit

[Open AD Kit](https://autoware.org/open-ad-kit/) is a set of containers for Autoware to make development and deployment easier on various platforms.

- [autoware](./docker/autoware/README.md): Autoware container for development and deployment.
- [scenario-simulator](./docker/scenario-simulator/README.md): Simulation container for Autoware scenario testing.
- [visualizer](./docker/visualizer/README.md): RViz-based remote operation and visualization container for Autoware.
- **bridge**: Bridge container to create efficient DDS messaging pipeline between edge and cloud (WIP).
- **controller**: Control container to send an receive messages between Autoware and the vehicle (WIP).

![oadkit](https://github.com/user-attachments/assets/0172eed1-c2cf-4f8d-b94c-91ed092e421c)

## Demo

To run the demo, you need to have Docker installed. Which you can install by using the following command:

```bash
./setup-dev-env.sh -y docker --no-nvidia
```

**Note: If you are using a non-root user, you need logout/login or refresh user groups by:**

```bash
newgrp docker
```

cd into the demo directory:

```bash
cd demo
```

Then, you can run the demo by using the following command:

```bash
docker compose up
```

To stop the demo, you can use the following command:

```bash
docker compose down
```

**The visualizer Rviz is accessible through the URL provided in the terminal using any modern browser.**
