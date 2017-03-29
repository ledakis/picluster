#!/usr/bin/env bash

set -e
# will immediately exit if any command fails

git -C /home/pi/picluster/ status 1>/dev/null 2>&1

#if $(echo $?); then
#	exit "This is not a valid repository!"
#fi

git -C /home/pi/picluster/ fetch origin master
git -C /home/pi/picluster/ reset --hard FETCH_HEAD
git -C /home/pi/picluster/ clean -df



git -C /home/pi/picluster/ add /home/pi/picluster/ip/$(cat /sys/class/net/eth0/address | tr -d ":")
git -C /home/pi/picluster/ commit -m 'new ip for $(cat /sys/class/net/eth0/address | tr -d ":")'
git -C /home/pi/picluster/ push


sleep 10
