ARG PLATFORM
FROM ghcr.io/autowarefoundation/autoware:universe-devel AS aws-reinvent-simulator-devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG ROS_DISTRO
ENV CCACHE_DIR="/root/.ccache"

COPY src /autoware/src

# Set up rosdep
RUN --mount=type=ssh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && rosdep update \
  && rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO \
  && apt-get autoremove -y && rm -rf "$HOME"/.cache

# Build simulator
RUN  source /opt/ros/"$ROS_DISTRO"/setup.bash \
&& source /opt/autoware/setup.bash \
&& colcon build --cmake-args \
  " -Wno-dev" \
  " --no-warn-unused-cli" \
  --merge-install \
  --mixin release compile-commands ccache \
  --base-paths /autoware/src/simulator

RUN find /autoware/install/lib -type f -name "*.py" -exec chmod +x {} \;
RUN find /autoware/install/share -type f -name "*.py" -exec chmod +x {} \;

FROM ghcr.io/autowarefoundation/autoware:universe AS aws-reinvent-simulator

# Copy simulator from simulator-devel
COPY src /autoware/src
COPY --from=aws-reinvent-simulator-devel /autoware/install /autoware/install

# Set up rosdep
RUN --mount=type=ssh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y curl unzip \
  && rosdep update \
  && cd /autoware \
  && rosdep install -y --from-paths src --ignore-src --dependency-types=exec --rosdistro $ROS_DISTRO \
  && apt-get autoremove -y && rm -rf "$HOME"/.cache

RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

# Copy simulation scenario and map
COPY docker/etc/simulation /autoware/scenario-sim
COPY docker/etc/simulation/rviz/autoware.rviz /opt/autoware/share/autoware_launch/rviz/autoware.rviz

# Create entrypoint
# COPY docker/etc/aws_entrypoint.sh /aws_entrypoint.sh
# RUN chmod +x /aws_entrypoint.sh
# ENTRYPOINT ["/aws_entrypoint.sh"]
# CMD ["/bin/bash"]

FROM ghcr.io/autowarefoundation/autoware:universe AS aws-reinvent-planning-control

RUN --mount=type=ssh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y curl unzip \
  && apt-get autoremove -y && rm -rf "$HOME"/.cache

# Create entrypoint
COPY docker/etc/aws_entrypoint.sh /aws_entrypoint.sh
RUN chmod +x /aws_entrypoint.sh
ENTRYPOINT ["/aws_entrypoint.sh"]
CMD ["/bin/bash"]
