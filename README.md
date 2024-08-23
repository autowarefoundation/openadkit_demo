# Autoware Open AD Kit on AutoTech Detroit

## Running the demo

To run the containers on the target machine in this case AADP platform or an EC2-Graviton instance

```bash
docker/run.sh
```

To visualize the simulation on a remote platform which is on the same network with the target machine Run:

```bash
docker/run-visualizer.sh
```

### Building the containers from scratch

To build the container images from scratch Run:

```bash
docker/build.sh
```

## Further Documentation

To learn more technical details about Autoware,SOAFEE refer to the [Autoware documentation site](https://autowarefoundation.github.io/autoware-documentation/main/), [SOAFEE documentation site](https://gitlab.com/soafee/blueprints).

## Useful resources
- [Autoware Foundation homepage](https://www.autoware.org/)
- [AVA Developer Platform](https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/AVA_Developer_Platform)
- [ARM Software Defined Vehicle](https://www.arm.com/blogs/blueprint/software-defined-vehicle)
