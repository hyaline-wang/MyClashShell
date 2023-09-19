#!/bin/bash

# echo "功能已失效，勿用"
# exit
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

echo "删除 之前的 配置文件 "
rm ../clash/configs/config.yaml
sleep 1
echo "download new config"
wget $(cat ../config_urls/default.txt) -O ../clash/configs/config.yaml
echo "重新启动clash"
sudo systemctl restart clash
sleep 1
