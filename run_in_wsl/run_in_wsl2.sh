#!/bin/bash
colors_On_Red='\033[41m' 
colors_Normal='\e[0m'

# set varible
clash_bashrc_file="clash_wsl.bashrc"
clash_help_file="clash_wsl_help.sh"

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi


echo 'Warning:run_in_wsl.sh 是为了共享host的代理,因此在开始之前请确保host已经安装并配置好了clash for windows,并勾选了Allow Lan'
read -n 1 -s -r -p "Press any key to continue..."

echo "安装依赖"
sudo apt install -y curl python3-dev

echo "find old clash in bashrc"
start_line=$(cat /etc/bash.bashrc|grep clash_env_set_start -n|head -n 1|cut -d: -f1)
end_line=$(cat /etc/bash.bashrc|grep clash_env_set_end -n|head -n 1|cut -d: -f1)
# echo "delete ${start_line}~${end_line}"
sed -i "${start_line},${end_line}d" /etc/bash.bashrc

# get host ip 
host_ip=$(/bin/python3 $(pwd)/get_host_ip.py)
echo "get host ip >>>>"
echo "host ip:$host_ip"
echo ">>>>"
echo "write config to /etc/bash.bashrc"
echo "
# clash_env_set_start
export CLASH_PWD=$(pwd)
export clash_host_ip=${host_ip}
">> /etc/bash.bashrc
echo "
if [ -f $(pwd)/${clash_bashrc_file} ]; then
    source $(pwd)/${clash_bashrc_file} 
fi
">> /etc/bash.bashrc

echo -e "alias clash_help='bash $(pwd)/clash_wsl_help.sh'">> /etc/bash.bashrc
echo "
# clash_env_set_end
">> /etc/bash.bashrc



echo -e "$colors_On_Red clash in wsl 配置完成，请在使用 source/etc/bash.bashrc $colors_Normal"
# echo -e "你可以使用 ./uninstall_clash.sh 卸载配置"

bash ./clash_wsl_help.sh


