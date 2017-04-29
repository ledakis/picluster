#!/usr/bin/env bash
# generates the inventory file for ansible

#sh -c '(echo [nodes]; cat /home/pi/picluster/ip/* ) 2>/dev/null ' > /home/pi/picluster/inventory

#sh -c 'cat /home/pi/picluster/ip/* 2>/dev/null ' > /home/pi/picluster/inventory

PI_conffile=/home/pi/.piclusterrc
PI_local_repo_dir=/home/pi/picluster

echo "[master]" > $PI_local_repo_dir/inventory
cat $PI_local_repo_dir/ip/$(cat $PI_local_repo_dir/master) 2>/dev/null >> $PI_local_repo_dir/inventory
rm $PI_local_repo_dir/ip/$(cat $PI_local_repo_dir/master)

echo "[nodes]" >> $PI_local_repo_dir/inventory
cat $PI_local_repo_dir/ip/* 2>/dev/null >> $PI_local_repo_dir/inventory

echo "
[nodes:vars]
ansible_user=pi

[master:vars]
ansible_ssh_user=pi
" >> $PI_local_repo_dir/inventory

cp $PI_local_repo_dir/inventory /home/pi/inventory
