#!/bin/bash


echo "delete old config "
rm ${MY_CLASH_BASH_PWD}../clash/configs/config.yaml
sleep 1
echo "download new config"
wget  $(cat ${MY_CLASH_BASH_PWD}../config_urls/default.txt) -O ${MY_CLASH_BASH_PWD}../clash/configs/config.yaml
echo "Reload"
python3 ${MY_CLASH_BASH_PWD}../tools/update_proxy.py
sleep 1
