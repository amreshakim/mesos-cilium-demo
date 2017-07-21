#!/bin/bash

echo "Starting mesos master..."
nohup sudo mesos-master --ip=$HOST_IP --work_dir=/var/lib/mesos &> ~/mesos-master.log &
sleep 1
echo "Done"
echo ""

echo "Starting mesos agent..."
nohup sudo mesos-agent --logging_level=INFO --docker_socket=/var/run/docker.sock --containerizers=docker,mesos --image_providers=docker --isolation=filesystem/linux,docker/runtime --master=$HOST_IP:5050 --ip=$HOST_IP --work_dir=/var/lib/mesos --network_cni_plugins_dir=/opt/cni/bin --network_cni_config_dir=/etc/cni/net.d &> ~/mesos-agent.log &
sleep 1
echo "Done"
echo ""


echo "Starting marathon..."
./marathon/bin/start --master $HOST_IP:5050 &> ~/marathon.log &
echo "Done"
