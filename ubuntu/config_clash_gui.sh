#!/bin/bash
colors_On_Red='\033[41m' 
colors_Normal='\e[0m' 

echo "功能已失效，勿用"
exit
whiptail --title "Welcome to use Auto_clash_cli" --msgbox "您好，欢迎使用 Auto—Clash-CLI
此脚本的功能是在当前目录自动配置clash,并创建systemd服务,在创建systemd service 时需要sudo权限,按Enter键继续" 12 78

ARCH=$(whiptail --title "电脑架构选择" --radiolist "请选择您的电脑架构,空格选中" 20 78 4 \
"x86_64" "正常的AMD或Intel的处理器" ON \
"ARMv8" "Nvidia NX" OFF 3>&1 1>&2 2>&3)
echo Arch $ARCH

CLASH_URL=$(whiptail --inputbox "请填入Clash 代理地址" 8 80 --title "Input Clash url" 3>&1 1>&2 2>&3)
                                                                        # A trick to swap stdout and stderr.
# Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $CLASH_URL
else
    echo "User selected Cancel."
fi

echo "(Exit status was $exitstatus)"

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "Ready to install Auto_clash_cli" --yesno "即将开始配置Clash,请确认信息选择是否正确\n \
Arch:${ARCH} \n Clash Url: ${CLASH_URL} " 12 78 \
); then
    echo "User selected Yes, exit status was $?."
else
    echo "User selected No, exit status was $?."
fi

echo "删除之前的 clash"
rm -rf clash
mkdir -p clash/configs
cd clash
if [ $ARCH = ARMv8 ]
then
echo "下载 Clash armv8"
wget https://gitee.com/wangdaochuan/auto-clash-cli/releases/download/dependenciesv0.1/clash-linux-armv8-v1.11.8.gz -O clash.gz
elif [ $ARCH = x86_64 ]
then
echo "下载 Clash x86_64"
wget https://gitee.com/wangdaochuan/auto-clash-cli/releases/download/dependenciesv0.1/clash-linux-amd64-v3-v1.11.4.gz -O clash.gz
fi

gunzip clash.gz
chmod +x clash
echo "下载Country.mmdb"
wget https://gitee.com/wangdaochuan/auto-clash-cli/releases/download/dependenciesv0.1/Country.mmdb -O configs/Country.mmdb 
cd ..

echo "下载config.yaml"
wget ${CLASH_URL} -O clash/configs/config.yaml

sleep 1
clash_exec="$(pwd)/clash/clash"
clash_config="$(pwd)/clash/configs"
echo $clash_exec
echo $clash_config
# echo remove old clash.service
# rm clash.service >> /dev/null
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


echo -e "$colors_On_Red 注意这里需要密码 $colors_Normal"
sudo mv clash.service /etc/systemd/system/clash.service
sudo systemctl daemon-reload
sudo systemctl start clash
sudo systemctl enable clash


echo "set Auto_start success!!"

# {
#     for ((i = 0 ; i <= 100 ; i+=5)); do
#         sleep 0.1
#         echo $i
#     done
# } | whiptail --gauge "Please wait while we are sleeping..." 6 50 0

echo "
if [ -f $(pwd)/clash.bashrc ]; then
    source $(pwd)/clash.bashrc 
fi
">> ~/.bashrc

echo -e "alias clash_help='bash $(pwd)/clash_help.sh'">> ~/.bashrc


whiptail --title "Install Success" --msgbox "Have Fun!!!!" 8 78

echo "clash 配置完成，，请在新终端中使用"
sed -n '7, 8p' ./PROMPT.txt
bash ./clash_help.sh