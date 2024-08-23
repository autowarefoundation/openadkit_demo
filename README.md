# Autoware Open AD Kit on CES: A Planning Demonstration

The [Open AD Kit](https://autoware.org/open-ad-kit/) is a collaborative project developed by the [Autoware Foundation](https://www.autoware.org/) and its member companies and alliance partners. It aims to bring software-defined best practices to the [Autoware project](https://autowarefoundation.github.io/autoware-documentation/main/) and to enhance the [Autoware ecosystem](https://autoware.org/about/members/) and capabilities by partnering with other organizations that share the goal of creating software-defined vehicles.

The Open AD Kit utilizes Autoware components, which are built using the [ROS2 framework](https://docs.ros.org/en/humble/index.html. ROS2, with its nodes architecture, provides the foundation for having distinct functional containerized runtime modules. Open AD Kit can also communicate with other containerized applications to support various functionalities, such as providing a bi-directional data pipeline and providing up-to-date maps to be consumed within the Open AD Kit application.

To demonstrate Open AD Kit's modularity and convenience for the easy process of managing and updating distinct AD containers with OTA-enabled architecture, the planning stack of the Autoware will be deployed, managed, and updated. The reference diagram can be found as:

![Adsız](https://github.com/leo-drive/ces_autoware/assets/21222428/ebf46992-67a7-41f0-9abf-c17c9fe21c7b)

![ces](https://github.com/leo-drive/ces_autoware/assets/21222428/311452ed-6abb-4953-a8b6-fb5b1bb65d2b)

For the simulation environment **TierIV's** [Web.Auto](https://web.auto/) platform is used, the platform itself capable of running multiple scenarios at once to validate the functional safety of the algorithms in the cloud.

As a cloud service provider, **Amazon Web Services** is used both as a base cloud environment and for the virtual vehicle setup which is used to emulate the edge environment. **AWS EC2**'s equipped with the ARM Neoverse N1 architecture that has the full ISA parity with the edge platform.

Open AD Kit is also capable of getting OTA updates by using [eSync Alliance's](https://www.esyncalliance.org/) technology. eSync is a secure, scalable, and reliable OTA update solution that can be used to update the Open AD Kit application and its dependencies. eSync is also capable of updating the Open AD Kit application and its dependencies on the fly, which means that the Open AD Kit application can be updated without having to restart the vehicle.

 The demo built upon the [AADP](https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/AVA_Developer_Platform) from ADLINK, which is a high-performance, high-density, and high-reliability ARM Neoverse N1-based server carrier board. Both AVA Developer Platform and EWAOL lays the foundation for the Open AD Kit to be deployed as a lightweight and scalable software-defined vehicle platform.

## Running the demo

To run the containers on the target machine in this case AADP platform or an EC2-Graviton instance

```bash
docker/run-containers.sh
```

To visualize the simulation on a remote platform which is on the same network with the target machine Run:

```bash
docker/run-visualizer.sh
```

### Building the containers from scratch

To build the target container images from scratch Run:

```bash
docker/build-containers.sh
```

To build the visualizer container image from scratch Run:

```bash
docker/build-visualizer.sh
```

## Further Documentation

To learn more technical details about Autoware,SOAFEE refer to the [Autoware documentation site](https://autowarefoundation.github.io/autoware-documentation/main/), [SOAFEE documentation site](https://gitlab.com/soafee/blueprints).

## Useful resources
- [Autoware Foundation homepage](https://www.autoware.org/)
- [AVA Developer Platform](https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/AVA_Developer_Platform)
- [ARM Software Defined Vehicle](https://www.arm.com/blogs/blueprint/software-defined-vehicle)
