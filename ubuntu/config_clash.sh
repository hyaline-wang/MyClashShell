#!/bin/bash
colors_On_Red='\033[41m' 

colors_Normal='\e[0m' 
argNums=$#
dependenciesUrl=https://gitee.com/wangdaochuan/resource_backup/releases/download/cat_dependencies

bashrcPath=$(echo $(pwd)/$0 | awk '{split($0,a,"config_clash.sh"); print a[1]}')


failed_and_exit()
{
    echo -e "$colors_On_Red $1 $colors_Normal"
    exit
}


# params check
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi
if [ $argNums -eq 0 ]
then
    echo "没有发现 架构 ，支持 AMD64 ARMv8 ARMv7a"
    echo "使用示例:./config_clash.sh AMD64"
    exit
fi
url=$(cat $bashrcPath/../config_urls/default.txt)
if [ -z $url ];then
    mkdir $bashrcPath/../config_urls
    touch $bashrcPath/../config_urls/default.txt
    echo "请先在创建config_urls中创建 default.txt,并将 链接放入txt中"
    exit
fi

# 使用须知
sed -n '1, 6p' $bashrcPath/PROMPT.txt
read -n 1 -s -r -p "Press any key to continue..." key


echo "安装依赖"
sudo apt install -y curl vim wget

if [ $? != 0 ]
then
    echo -e "$colors_On_Red apt 安装失败,请检查网络连接 $colors_Normal"
    exit
fi

# clear clash
arch=$1
echo "Clear previous clash" 
rm -rf $bashrcPath/../clash

# get clash
mkdir -p $bashrcPath/../clash
mkdir -p $bashrcPath/../clash/configs
cd $bashrcPath/../clash
if [ $arch = ARMv8 ]
then
echo "Arch:armv8"
clash_arch=clash-linux-armv8-v1.11.8.gz
elif [ $arch = ARMv7a ]
then
echo "Arch:ARMv7a"
clash_arch=clash-linux-armv7-v1.12.0.gz
elif [ $arch = AMD64 ]
then
echo "Arch:amd64"
clash_arch=clash-linux-amd64-v3-v1.11.4.gz
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
wget ${dependenciesUrl}/Country.mmdb -O configs/Country.mmdb 
if [ $? != 0 ]
then
    failed_and_exit "Country.mmdb 下载失败"
fi

# get config.yaml
cd ..
echo "下载配置文件"
curl $url -o clash/configs/config.yaml
if [ $? != 0 ]
then
    failed_and_exit "配置文件 下载失败"
fi

sleep 1

echo "设置systemd 服务"
clash_exec="$(bashrcPath)/../clash/clash"
clash_config="$(bashrcPath)/../clash/configs"
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
systemctl start clash
systemctl enable clash


echo "set Auto_start success!!"
# TODO,remove clash in bashrc
echo "find old clash in bashrc"
start_line=$(cat /etc/bash.bashrc|grep clash_env_set_start -n|head -n 1|cut -d: -f1)
end_line=$(cat /etc/bash.bashrc|grep clash_env_set_end -n|head -n 1|cut -d: -f1)
# echo "delete ${start_line}~${end_line}"
sed -i "${start_line},${end_line}d" /etc/bash.bashrc
echo "
# clash_env_set_start
export MY_CLASH_BASH_PWD=$bashrcPath
">> /etc/bash.bashrc
echo "
if [ -f \${MY_CLASH_BASH_PWD}/clash.bashrc ]; then
    source \${MY_CLASH_BASH_PWD}/clash.bashrc 
fi
">> /etc/bash.bashrc
echo "
# clash_env_set_end
">> /etc/bash.bashrc

echo -e "$colors_On_Red clash 配置完成，请在新终端中使用 $colors_Normal"
echo -e "$colors_On_Red 注意:此文件夹不能删除 $colors_Normal"

sed -n '8, 10p' $bashrcPath/PROMPT.txt
