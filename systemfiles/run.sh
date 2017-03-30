#!/usr/bin/env bash

# init vars
PI_check_master=1
PI_init_repo=0

PI_conffile=/home/pi/.piclusterrc

if [ ! -f "$PI_conffile" ]; then
	cp -f /boot/picluster/conffile.sh $PI_conffile
	if [[ ! -d "/home/pi/.ssh" ]]; then
		mkdir /home/pi/.ssh
	fi
	cp -f /boot/picluster/priv.key /home/pi/.ssh/id_rsa
	cp -f /boot/picluster/priv.key.pub /home/pi/.ssh/id_rsa.pub
	PI_init_repo=1
fi
# conffile exists by now
source $PI_conffile

if [[ $PI_init_repo ]]; then
	if [[ -d /home/pi/picluster ]]; then
		rm -rf /home/pi/picluster
	fi
	git clone $PI_repo_addr /home/pi/picluster
fi

if [[ $PI_check_master ]]; then
	bash /home/pi/picluster/node-master.sh
fi

bash /home/pi/picluster/up2git.sh

export -p | grep PI_ > $PI_conffile