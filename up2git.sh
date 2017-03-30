#!/usr/bin/env bash

git -C /home/pi/picluster/ remote update
repo_update_needed=$(/home/pi/picluster/git_up2date_needed.sh)

if [ $repo_update_needed ]; then
	git -C /home/pi/picluster/ fetch origin master
	git -C /home/pi/picluster/ reset --hard FETCH_HEAD
	git -C /home/pi/picluster/ clean -df
fi

ip_changed=$(/home/pi/picluster/ip2file.sh)

if [ $ip_changed ]; then
	git -C /home/pi/picluster/ add /home/pi/picluster/ip/$(cat /sys/class/net/eth0/address | tr -d ":")
	git -C /home/pi/picluster/ commit -m "new ip for $(cat /sys/class/net/eth0/address | tr -d ':')"
	git -C /home/pi/picluster/ push origin master
fi


