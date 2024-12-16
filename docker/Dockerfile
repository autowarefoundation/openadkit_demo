ARG PLATFORM
ARG ROS_DISTRO

# Build Stage
FROM ghcr.io/autowarefoundation/autoware:universe-devel AS builder
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV CCACHE_DIR="/root/.ccache"

COPY src /autoware/src

# Install dependencies and build the simulator
RUN --mount=type=ssh \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && \
    rosdep update && \
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO && \
    source /opt/ros/"$ROS_DISTRO"/setup.bash && \
    source /opt/autoware/setup.bash && \
    colcon build --cmake-args \
      "-Wno-dev" \
      "--no-warn-unused-cli" \
      --install-base /opt/autoware \
      --merge-install \
      --mixin release compile-commands ccache \
      --base-paths /autoware/src/simulator && \
    find /opt/autoware/lib -type f -name "*.py" -exec chmod +x {} \; && \
    find /opt/autoware/share -type f -name "*.py" -exec chmod +x {} \; && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* "$HOME"/.cache

# Simulator
FROM ghcr.io/autowarefoundation/autoware:universe AS simulator
COPY src /autoware/src
COPY --from=builder /opt/autoware /opt/autoware
COPY docker/etc/simulation /autoware/scenario-sim

RUN --mount=type=ssh \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && \
    apt-get install -y curl unzip && \
    rosdep update && \
    cd /autoware && \
    rosdep install -y --from-paths src --ignore-src --dependency-types=exec --rosdistro $ROS_DISTRO && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* "$HOME"/.cache && \
    echo "source /opt/autoware/setup.bash" > /etc/bash.bashrc && \
    chmod +x /entrypoint.sh

COPY docker/etc/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

# Visualizer
FROM simulator AS visualizer
WORKDIR /autoware

# Install VNC server with NoVNC
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl unzip lxde tigervnc-standalone-server tigervnc-common \
    novnc websockify python3-numpy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC password
RUN mkdir -p ~/.vnc && \
    echo "openadkit" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Set up xstartup script
COPY docker/etc/xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

# Create SSL certificate for NoVNC
RUN openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout /etc/ssl/private/novnc.key \
    -out /etc/ssl/certs/novnc.crt \
    -days 365 \
    -subj "/O=Autoware-OpenADKit/CN=localhost"

# Install ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  gpg --dearmor -o /etc/apt/keyrings/ngrok.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" | \
  tee /etc/apt/sources.list.d/ngrok.list && \
  apt update && apt install ngrok

# Need to expose VNC and NoVNC ports when running the container
EXPOSE 5900 6080

# Copy entrypoint script
COPY docker/etc/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

# Planning Control
FROM ghcr.io/autowarefoundation/autoware:universe AS planning-control

RUN --mount=type=ssh \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && \
    apt-get install -y curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* "$HOME"/.cache && \
    chmod +x /entrypoint.sh

COPY docker/etc/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
