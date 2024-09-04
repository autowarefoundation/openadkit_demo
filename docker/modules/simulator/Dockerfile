FROM ghcr.io/autowarefoundation/autoware:20240823-runtime AS simulator
ARG LIB_DIR
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=ghcr.io/tier4/scenario_simulator_v2:humble-4.0.2 /home/ubuntu/Desktop/scenario_simulator_ws/install /home/ubuntu/Desktop/scenario_simulator_ws/install
COPY --from=ghcr.io/tier4/scenario_simulator_v2:humble-4.0.2 /home/ubuntu/Desktop/scenario_simulator_ws/src /home/ubuntu/Desktop/scenario_simulator_ws/src
COPY --from=ghcr.io/tier4/scenario_simulator_v2:humble-4.0.2 /home/ubuntu/Desktop/scenario_simulator_ws/build /home/ubuntu/Desktop/scenario_simulator_ws/build

# Install rosdep dependencies of scenario simulator
RUN cd /home/ubuntu/Desktop/scenario_simulator_ws && rosdep install -y -r -i --from-paths src --ignore-src --rosdistro humble \
    && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoremove -y \
    && find /usr/lib/$LIB_DIR-linux-gnu -name "*.a" -type f -delete \
    && find / -name "*.o" -type f -delete \
    && find / -name "*.h" -type f -delete \
    && find / -name "*.hpp" -type f -delete 

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/etc/simulation/ /autoware/scenario-sim/

# Create entrypoint
COPY docker/etc/ros_entrypoint_sim.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["ros2 launch scenario_test_runner scenario_test_runner.launch.py architecture_type:=awf/universe record:=false scenario:=/autoware/scenario-sim/yield_maneuver_demo.yaml sensor_model:=sample_sensor_kit vehicle_model:=sample_vehicle map_path:=/autoware/scenario-sim/map/ global_timeout:=240 initialize_duration:=90 launch_autoware:=false rviz:=true"]