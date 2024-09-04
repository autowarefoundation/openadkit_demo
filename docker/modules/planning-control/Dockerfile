ARG ARCH
FROM ghcr.io/autowarefoundation/autoware:20240904-runtime-${ARCH} AS planning-control
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
LABEL org.opencontainers.image.source https://github.com/autowarefoundation/openadkit_demo.autoware

# Copy simulation files
COPY docker/etc/simulation/ /autoware/scenario-sim/
RUN chmod +x /autoware/scenario-sim/rviz/launch_rviz.sh

# Create entrypoint
COPY docker/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["ros2 launch autoware_launch planning_simulator.launch.xml map_path:=/autoware/scenario-sim/map/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit scenario_simulation:=true use_foa:=false perception/enable_traffic_light:=false rviz:=false"]