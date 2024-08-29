FROM ghcr.io/autowarefoundation/autoware:20240823-runtime AS visualizer
ARG LIB_DIR
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=ghcr.io/tier4/scenario_simulator_v2:humble-4.0.2 /home/ubuntu/Desktop/scenario_simulator_ws/install /opt/simulator/install
COPY --from=ghcr.io/tier4/scenario_simulator_v2:humble-4.0.2 /home/ubuntu/Desktop/scenario_simulator_ws/src /opt/simulator/src
COPY --from=ghcr.io/tier4/scenario_simulator_v2:humble-4.0.2 /home/ubuntu/Desktop/scenario_simulator_ws/build /opt/simulator/build

# Install rosdep dependencies of scenario simulator
RUN cd /opt/simulator && rosdep install -y -r -i --from-paths src --ignore-src --rosdistro humble \
    && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoremove -y \
    && find /usr/lib/$LIB_DIR-linux-gnu -name "*.a" -type f -delete \
    && find / -name "*.o" -type f -delete \
    && find / -name "*.h" -type f -delete \
    && find / -name "*.hpp" -type f -delete 

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/etc/simulation/ /autoware/scenario-sim/
RUN chmod +x /autoware/scenario-sim/rviz/launch_rviz.sh

# Install VNC server and dependencies
# GUI fluxbox may not be necessary for simulation
RUN apt-get update && apt-get install -y --no-install-recommends \
    x11vnc \
    xvfb \
    fluxbox \
    && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoremove -y \
    && find /usr/lib/$LIB_DIR-linux-gnu -name "*.a" -type f -delete \
    && find / -name "*.o" -type f -delete \
    && find / -name "*.h" -type f -delete \
    && find / -name "*.hpp" -type f -delete 

# Set up VNC password
RUN mkdir ~/.vnc && x11vnc -storepasswd 1234 ~/.vnc/passwd

# Create VNC startup script
RUN echo '#!/bin/bash\nXvfb :1 -screen 0 1280x720x16 &\nfluxbox &\nx11vnc -forever -usepw -create -display :1' > /start_vnc.sh \
    && chmod +x /start_vnc.sh

# Create entrypoint
COPY docker/etc/ros_entrypoint_sim.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

# Expose VNC port
EXPOSE 5900

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]