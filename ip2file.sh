#!/usr/bin/env bash

# better version without sudo from 
# https://ubuntuforums.org/showthread.php?t=1665000&p=10346800#post10346800

curr_ip="$(ip address show | awk -F '[ /]+' '/inet / && $3 != "127.0.0.1" {print $3}')"
ip_file="/home/pi/picluster/ip/$(cat /sys/class/net/eth0/address | tr -d ":")"
changed=0
if [ ! -f $ip_file ]; then
        echo $curr_ip > $ip_file
	changed=1
elif [ "$curr_ip" != "$(cat $ip_file))" ]; then
        echo $curr_ip > $ip_file
	changed=1
fi

echo $changed
