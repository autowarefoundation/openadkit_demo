FROM ghcr.io/autowarefoundation/autoware:universe as autoware

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY docker/autoware/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]