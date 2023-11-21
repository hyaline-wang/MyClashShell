#!/bin/bash

echo "delete old config "
rm ${MYCLASH_ROOT_PWD}/clash/configs/*.yaml
sleep 1
echo "download new config"

# get config.yaml
echo "下载配置文件"
echo ${MYCLASH_ROOT_PWD}
cd ${MYCLASH_ROOT_PWD}

x=0
subscribe_url=$(/usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/read_yaml.py subscribe_urls 0)
echo subscribe_url $subscribe_url

while [ "${subscribe_url}" != "failed" ]
do
    curl ${subscribe_url} -o clash/configs/raw_config_${x}.yaml
    echo "Downlaods ${x}th config"
    x=$(( $x + 1 ))
    subscribe_url=$(/usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/read_yaml.py subscribe_urls ${x})
done

/usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/yaml_merge.py 0

# echo "Reload"
# /usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/update_proxy.py
# sleep 1
echo "Restart,need password"
sudo systemctl restart clash