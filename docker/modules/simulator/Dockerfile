FROM ghcr.io/autowarefoundation/autoware:latest-devel AS simulator-base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO
WORKDIR /autoware

COPY simulator.repos /autoware/

# Set up runtime environment
RUN --mount=type=ssh \
  vcs import src < simulator.repos \
  && apt-get update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --rosdistro "$ROS_DISTRO" --ignore-src --from-paths src 

# Build and change permission for runtime data conversion
RUN source /opt/ros/"$ROS_DISTRO"/setup.bash \
  && colcon build --packages-skip-build-finished --cmake-args -DCMAKE_BUILD_TYPE=Release --parallel-workers 8 \
  && find /autoware/install -type d -exec chmod 777 {} \; \
  && apt-get clean \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / \( -name "*.o" -o -name "*.h" -o -name "*.hpp" \) -type f -delete \
  && rm -rf /var/lib/apt/lists/* /autoware/src /autoware/autoware.repos /root/.local/pipx \
     /opt/ros/humble/include /etc/apt/sources.list.d/{cuda*,docker,nvidia-docker}.list \
     "$HOME"/.cache /usr/include /usr/share/doc /usr/lib/{gcc,jvm,llvm*}

FROM ghcr.io/autowarefoundation/autoware:latest-runtime AS simulator
ARG PLATFORM
ARG ROS_DISTRO

COPY simulator.repos /autoware/
COPY --from=simulator-base /autoware/install/ /autoware/install/

RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < simulator.repos \
  && apt-get update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --rosdistro "$ROS_DISTRO" --ignore-src --from-paths src \
  && apt-get clean \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / \( -name "*.o" -o -name "*.h" -o -name "*.hpp" \) -type f -delete \
  && rm -rf /var/lib/apt/lists/* /autoware/{src,autoware.repos} /root/.local/pipx \
     /opt/ros/humble/include /etc/apt/sources.list.d/{cuda*,docker,nvidia-docker}.list \
     "$HOME"/.cache /usr/include /usr/share/doc /usr/lib/{gcc,jvm,llvm*}

RUN chmod -R 777 /autoware/install/

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/etc/simulation/ /autoware/scenario-sim/

# Create entrypoint
COPY docker/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]