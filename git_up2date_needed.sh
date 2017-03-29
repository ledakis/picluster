#!/usr/bin/env bash

update_needed=0

local_repo=$(git rev-parse @)
remote_repo=$(git rev-parse origin/master)

if [ $local_repo != $remote_repo ]; then
	update_needed=1
fi
echo $update_needed
