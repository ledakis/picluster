#!/usr/bin/env bash

# init vars
PI_check_master=1
PI_init_repo=0

PI_conffile=/home/pi/.piclusterrc

# init keys, conffile
if [ ! -f "$PI_conffile" ]; then
	cp -f /boot/picluster/conffile.sh $PI_conffile
	if [[ ! -d "/home/pi/.ssh" ]]; then
		mkdir /home/pi/.ssh
	fi
	cp -f /boot/picluster/priv.key /home/pi/.ssh/id_rsa
	chmod 600 /home/pi/.ssh/id_rsa
	cp -f /boot/picluster/ssh_config /home/pi/.ssh/config
	chmod 644 /home/pi/.ssh/config
	cp -f /boot/picluster/pub.key /home/pi/.ssh/id_rsa.pub
	chmod 644 /home/pi/.ssh/id_rsa.pub
	cp -f /boot/picluster/pub.key /home/pi/.ssh/authorized_keys
	chmod 600 /home/pi/.ssh/authorized_keys
	cp -f /boot/picluster/gitconfig /home/pi/.gitconfig
	chmod 644 /home/pi/.gitconfig
	PI_init_repo=1
fi
# conffile exists by now
source $PI_conffile

if [ ! $(which git) ]; then
	sudo apt update
	sudo apt -y install git ansible vim
fi

# init repo
if [ "$PI_init_repo" -eq "1" ]; then
	if [[ -d /home/pi/picluster ]]; then
		rm -rf /home/pi/picluster
	fi
	git clone -q $PI_repo_addr /home/pi/picluster
fi

# init master, master runs ansible scripts
if [ "$PI_check_master" -eq "1" ]; then
	bash /home/pi/picluster/node-master.sh
	PI_check_master=0
fi

# ip update
bash /home/pi/picluster/up2git.sh

# by now this should end, saving vars
export -p > $PI_conffile
chmod -x $PI_conffile
