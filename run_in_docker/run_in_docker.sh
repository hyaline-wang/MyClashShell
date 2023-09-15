#!/bin/bash
colors_On_Red='\033[41m' 
colors_Normal='\e[0m'

echo "Warning:run_in_docker.sh 是为了共享host的代理，因此在开始之前请确保host已经配置好了MyClashShell，且clash_ok为通过状态"
read -n 1 -s -r -p "Press any key to continue..." key

echo "安装依赖"
sudo apt install -y curl
# host ip 172.17.0.1
echo "find old clash in bashrc"
start_line=$(cat /etc/bash.bashrc|grep clash_env_set_start -n|head -n 1|cut -d: -f1)
end_line=$(cat /etc/bash.bashrc|grep clash_env_set_end -n|head -n 1|cut -d: -f1)
# echo "delete ${start_line}~${end_line}"
sed -i "${start_line},${end_line}d" /etc/bash.bashrc
echo "
# clash_env_set_start
export CLASH_PWD=$(pwd)
">> /etc/bash.bashrc
echo "
if [ -f $(pwd)/clash.bashrc ]; then
    source $(pwd)/clash_docker.bashrc 
fi
">> /etc/bash.bashrc

echo -e "alias clash_help='bash $(pwd)/clash_docker_help.sh'">> /etc/bash.bashrc
echo "
# clash_env_set_end
">> /etc/bash.bashrc

echo -e "$colors_On_Red clash in docker 配置完成，请在使用 source/etc/bash.bashrc $colors_Normal"
echo -e "你可以使用 ./uninstall_clash.sh 卸载配置"
sed -n '9, 10p' ./PROMPT.txt

bash ./clash_docker_help.sh


