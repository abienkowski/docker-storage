#!/bin/sh
# -- run devicemapper help script to setup the device
if [[ ! -f /dev/${CONVOY_DEVICE}1 ]]; then
  echo "Creating new partition on the storage device..."
  /bin/sh /dm_dev_partition.sh --write-to-disk /dev/${CONVOY_DEVICE}
fi
# -- configure docker volume plugin
echo "Adding entry to docker/plugins..."
mkdir -p /etc/docker/plugins
echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec
# --
# -- NOTE: by default volume size is 100G; you can override with--driver-opts dm.defaultvolumesize
# --
CONVOY_OPTS="--drivers devicemapper --driver-opts dm.datadev=/dev/${CONVOY_DEVICE}1 --driver-opts dm.metadatadev=/dev/${CONVOY_DEVICE}2"
echo "Starting convoy with options: $CONVOY_OPTS"
# -- start convoy in daemon mode
exec /usr/local/bin/convoy daemon $CONVOY_OPTS
