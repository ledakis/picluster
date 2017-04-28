#!/usr/bin/env bash
# generates the inventory file for ansible

#sh -c '(echo [nodes]; cat /home/pi/picluster/ip/* ) 2>/dev/null ' > /home/pi/picluster/inventory

#sh -c 'cat /home/pi/picluster/ip/* 2>/dev/null ' > /home/pi/picluster/inventory
echo "[main]" > /home/pi/picluster/inventory
cat ip/* 2>/dev/null >> /home/pi/picluster/inventory

echo "
[main:vars]
ansible_user=root" >> /home/pi/picluster/inventory


