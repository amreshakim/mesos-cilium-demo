#!/bin/bash

export IP=`cilium endpoint list | grep web-server | awk '{print $6}'`

sed "s/__WEBSERVER_IP__/$IP/g" ./client-template.json > client.json
