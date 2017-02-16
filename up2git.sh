#!/bin/sh

git -C /home/pi/picluster/ add /home/pi/picluster/ip/$(cat /sys/class/net/eth0/address | tr -d ":")
git -C /home/pi/picluster/ commit -m 'new ip for $(cat /sys/class/net/eth0/address | tr -d ":")'
git -C /home/pi/picluster/ push
