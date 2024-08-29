FROM ghcr.io/autowarefoundation/autoware:20240823-runtime AS planning-control
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/etc/simulation/ /autoware/scenario-sim/

# Create entrypoint
COPY docker/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["ros2 launch autoware_launch planning_simulator.launch.xml map_path:=/autoware/scenario-sim/map/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit scenario_simulation:=true use_foa:=false perception/enable_traffic_light:=false rviz:=false"]