#!/usr/bin/env bash
# generates the inventory file for ansible

sh -c '(echo [nodes]; cat /home/pi/picluster/ip/* )' > /home/pi/picluster/inventory
