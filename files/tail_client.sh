#!/bin/bash

tail -f `find /var/lib/mesos -name stdout | grep client`
