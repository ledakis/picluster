PI_conffile=/home/pi/.piclusterrc
PI_local_repo_dir=/home/pi/picluster
source $PI_conffile

bash $PI_local_repo_dir/inv-gen.sh 1>/dev/null 2>&1

ansible-playbook -i $PI_local_repo_dir/inventory $PI_local_repo_dir/play.yml 1>/dev/null 2>&1