#!/bin/bash
argNums=$#
dependenciesUrl=https://gitee.com/wangdaochuan/resource_backup/releases/download/cat_dependencies

bashrcPath=$(echo $(pwd)/$0 | awk '{split($0,a,"install.sh"); print a[1]}')
myclashRootPath=$(realpath ${bashrcPath}/..)
source ${myclashRootPath}/tools/common_func.sh
echo ${myclashRootPath}


# root user check
if (( $EUID != 0 )); then
    failed_and_exit "Please run as root"
fi


# arch_list=("amd64","armv8","armv7a")

if [ $argNums -eq 0 ]
then
    echo_R "没有发现 架构 ，支持 amd64 armv8 armv7a"
    echo "使用示例:./config_clash.sh amd64"
    exit
fi

# 使用须知
sed -n '1, 6p' ${myclashRootPath}/ubuntu/PROMPT.txt
read -n 1 -s -r -p "Press any key to continue..." key

echo "安装依赖"
sudo apt install -y curl vim wget python3

if [ $? != 0 ]
then
    failed_and_exit "apt 安装失败,请检查网络连接"
fi

/usr/bin/python3 -m pip install pyyaml

# clear clash
arch=$1
echo "Clear previous clash" 
rm -rf ${myclashRootPath}/clash

# get clash
cp ${myclashRootPath}/config.yaml ${myclashRootPath}/config_custom.yaml
chmod 666 ${myclashRootPath}/config_custom.yaml

mkdir -p ${myclashRootPath}/clash
mkdir -p ${myclashRootPath}/clash/configs
cd ${myclashRootPath}/clash
if [ $arch = armv8 ]
then
echo "Arch:armv8"
clash_arch=clash-linux-armv8-v1.11.8.gz
elif [ $arch = armv7a ]
then
echo "Arch:ARMv7a"
clash_arch=clash-linux-armv7-v1.12.0.gz
elif [ $arch = amd64 ]
then
echo "Arch:amd64"
clash_arch=clash-linux-amd64-v3-v1.11.4.gz
else
failed_and_exit "Arch not exist [amd64 armv8 armv7a]"
fi
wget ${dependenciesUrl}/$clash_arch -O clash.gz
if [ $? != 0 ]
then
    failed_and_exit "Country.mmdb 下载失败"
fi
gunzip clash.gz
chmod +x clash

# get Country.mmdb
echo "下载Country.mmdb"
wget ${dependenciesUrl}/Country.mmdb -O ${myclashRootPath}/clash/configs/Country.mmdb 
if [ $? != 0 ]
then
    failed_and_exit "Country.mmdb 下载失败"
fi


touch ${myclashRootPath}/clash/configs/config.yaml 


# change permit 
cd ${myclashRootPath}
chmod 777  -R clash/
sleep 1

echo "设置systemd 服务"
clash_exec="${myclashRootPath}/clash/clash"
clash_config="${myclashRootPath}/clash/configs"
echo $clash_exec
echo $clash_config

echo remove old clash.service
# TODO:remove /etc/systemd/system/clash.service
rm -f ./clash.service >> /dev/null
rm -f /etc/systemd/system/clash.service >> /dev/null
echo -e "[unit]\n\
Description=clash\n\
After=multi-user.targe\n\
[Service]\n\
TimeoutStartSec=30\n\
ExecStart=$clash_exec -d $clash_config" >> clash.service
echo -e 'ExecStop=/bin/kill $MAINPID
Restart=always
RestartSec=10s
[Install]
WantedBy=multi-user.target
' >> clash.service


# echo -e "$colors_On_Red 注意这里需要密码 $colors_Normal"
mv clash.service /etc/systemd/system/clash.service
systemctl daemon-reload
# systemctl start clash
systemctl enable clash


echo "set Auto_start success!!"
# TODO,remove clash in bashrc
echo "remove clash in bashrc"
start_line=$(cat /etc/bash.bashrc|grep clash_env_set_start -n|head -n 1|cut -d: -f1)
end_line=$(cat /etc/bash.bashrc|grep clash_env_set_end -n|head -n 1|cut -d: -f1)
# echo "delete ${start_line}~${end_line}"
sed -i "${start_line},${end_line}d" /etc/bash.bashrc

echo "add clash in bashrc"
echo "
# clash_env_set_start
export MYCLASH_ROOT_PWD=$myclashRootPath
">> /etc/bash.bashrc
echo "
if [ -f \${MYCLASH_ROOT_PWD}/ubuntu/clash.bashrc ]; then
    source \${MYCLASH_ROOT_PWD}/ubuntu/clash.bashrc 
fi
">> /etc/bash.bashrc
echo "
# clash_env_set_end
">> /etc/bash.bashrc

echo_G "clash 安装完成，为了正常使用MyClashShell,还需要一些步骤"
echo_G "1.请修改MyClashShell目录下刚生成的custom_config.yaml，将url1 替换为您的订阅链接"
echo_G "2.在此窗口运行 source /etc/bash.bashrc ;source ~/.bashrc"
echo_G "3.在此窗口运行 ./update_proxy_config.sh"
echo_R "注意:此文件夹不能删除"

sed -n '8, 10p' $bashrcPath/PROMPT.txt
