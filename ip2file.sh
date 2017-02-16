#!/bin/sh

sudo ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' > ~/picluster/ip/$(cat /sys/class/net/eth0/address | tr -d ":")
