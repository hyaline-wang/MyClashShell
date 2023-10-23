#!/bin/bash


echo "delete old config "
rm ${MYCLASH_ROOT_PWD}/clash/configs/config.yaml
sleep 1
echo "download new config"
wget  $(cat ${MYCLASH_ROOT_PWD}/config_urls/default.txt) -O ${MYCLASH_ROOT_PWD}/clash/configs/config.yaml
echo "Reload"
python3 ${MYCLASH_ROOT_PWD}/tools/update_proxy.py
sleep 1
