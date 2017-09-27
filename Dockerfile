FROM busybox
# --
# -- NOTE: this image should be run with -v /etc/docker/plugins:/etc/docker/plugins
# --   so that the container can be responsible for setting itself up as a volume plugin
# --
# -- TODO: to expose the convoy binaries to at the host level need to run
# --   the docker image with -v /usr/local/bin:/usr/local/bin
# --
# -- environmnet variables used by container scripts
ENV CONVOY_DEVICE=sdb
# -- extract the released package onto the docker filesystem
ADD files/convoy.tar.gz /root/
# -- copy executables to executable path and remove temporary files
RUN mkdir -p /usr/local/bin \
 && cp /root/convoy/convoy /usr/local/bin/convoy \
 && cp /root/convoy/convoy-pdata_tools /usr/local/bin/convoy-pdata_tools \
 && rm -Rf /root/convoy
# -- add dm helper script
ADD files/dm_dev_partition.sh /
# -- set entrypoint to convoy executable so other options can be passed through CMD
# ENTRYPOINT /usr/loca/bin/convoy
# -- add the start script
ADD start.sh /