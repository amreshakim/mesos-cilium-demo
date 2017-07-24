#!/bin/bash

if [[ -z "$HOST_IP" ]]; then
    HOST_IP=192.168.100.10
fi

echo "Starting marathon..."
./marathon/bin/start --master $HOST_IP:5050 &> ~/marathon.log &
echo "Done"
