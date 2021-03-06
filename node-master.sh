#!/usr/bin/env bash

# this will run the master tasks on boot
# if this node is not the master it will 
# give 60 seconds for the master to
# set itself up first

boot_master_file="/boot/picluster/master"
mac_addr=$(cat /sys/class/net/eth0/address | tr -d ":")


if [ -f $boot_master_file ]; then
	echo $mac_addr > /home/pi/picluster/master
	git -C /home/pi/picluster/ add /home/pi/picluster/master
	git -C /home/pi/picluster/ commit -m "new master"
	git -C /home/pi/picluster/ push origin master
	if ! crontab -upi -l | grep "masterRun.sh" >/dev/null; then
		(crontab -upi -l ; cat /boot/picluster/mastercron) | crontab -upi -
	fi
fi


