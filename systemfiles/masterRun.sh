#!/usr/bin/env bash

PI_conffile=/home/pi/.piclusterrc
PI_local_repo_dir=/home/pi/picluster
source $PI_conffile

bash $PI_local_repo_dir/inv-gen.sh 1>/dev/null 2>&1


pgrep ansible > /dev/null
sts=$?

if [ $sts -ne 0 ]; then
        ansible-playbook -i $PI_local_repo_dir/inventory $PI_local_repo_dir/play.yml > /home/pi/ansible.log
fi
