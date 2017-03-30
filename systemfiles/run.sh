#!/usr/bin/env bash

# init vars
PI_check_master=1
PI_init_repo=0
PI_install_git=1

PI_conffile=/home/pi/.piclusterrc

# init keys, conffile
if [ ! -f "$PI_conffile" ]; then
	cp -f /boot/picluster/conffile.sh $PI_conffile
	if [[ ! -d "/home/pi/.ssh" ]]; then
		mkdir /home/pi/.ssh
	fi
	cp -f /boot/picluster/priv.key /home/pi/.ssh/id_rsa
	chmod 600 /home/pi/.ssh/id_rsa
	cp -f /boot/picluster/pub.key /home/pi/.ssh/id_rsa.pub
	PI_init_repo=1
fi
# conffile exists by now
source $PI_conffile
if [[ $PI_install_git ]]; then
	sudo apt update
	sudo apt -y install git ansible vim
	PI_install_git=0
fi

# init repo
if [[ $PI_init_repo ]]; then
	if [[ -d /home/pi/picluster ]]; then
		rm -rf /home/pi/picluster
	fi
	git clone -q $PI_repo_addr /home/pi/picluster
fi

# init master, master runs ansible scripts
if [[ $PI_check_master ]]; then
	bash /home/pi/picluster/node-master.sh
fi

# ip update
bash /home/pi/picluster/up2git.sh

# by now this should end, saving vars
export -p | grep PI_ > $PI_conffile