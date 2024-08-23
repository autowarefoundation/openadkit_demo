FROM ghcr.io/autowarefoundation/autoware:latest-runtime AS planning-control
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/etc/simulation/ /autoware/scenario-sim/

# Create entrypoint
COPY docker/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]