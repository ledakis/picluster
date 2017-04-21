#!/usr/bin/env bash
# generates the inventory file for ansible

#sh -c '(echo [nodes]; cat /home/pi/picluster/ip/* ) 2>/dev/null ' > /home/pi/picluster/inventory

#sh -c 'cat /home/pi/picluster/ip/* 2>/dev/null ' > /home/pi/picluster/inventory
echo "[main]" > inventory
cat ip/* 2>/dev/null >> inventory

echo "
[main:vars]
ansible_user=root" >> inventory


