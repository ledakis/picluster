#!/usr/bin/env bash

#set -e
# will immediately exit if any command fails

#git -C /home/pi/picluster/ status 1>/dev/null 2>&1

git -C /home/pi/picluster/ remote update
repo_update_needed=$(./git_up2date_needed.sh)

#if $(echo $?); then
#	exit "This is not a valid repository!"
#fi
if [ $repo_update_needed ]; then
	git -C /home/pi/picluster/ fetch origin master
	git -C /home/pi/picluster/ reset --hard FETCH_HEAD
	git -C /home/pi/picluster/ clean -df
fi

. ./ip2file.sh

if [ $changed ]; then
	git -C /home/pi/picluster/ add /home/pi/picluster/ip/$(cat /sys/class/net/eth0/address | tr -d ":")
	git -C /home/pi/picluster/ commit -m 'new ip for $(cat /sys/class/net/eth0/address | tr -d ":")'
	git -C /home/pi/picluster/ push
fi



#sleep 10
