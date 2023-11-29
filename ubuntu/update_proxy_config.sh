#!/bin/bash

if [ "${MYCLASH_ROOT_PWD}" = "" ]; then
    echo "[ERROR] 找不到 MYCLASH_ROOT_PWD" 
    echo "请尝试 source /etc/bash.bashrc ;source ~/.bashrc 然后重新运行"
    exit
fi

source ${MYCLASH_ROOT_PWD}/tools/common_func.sh



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
    if [ "${subscribe_url}" = "url1" ]; then
        echo_R "请先将 custom_config.yaml中的 url1 替换掉" 
        exit
    fi
    # 开始前必须关掉代理
    unset http_proxy;unset https_proxy
    curl ${subscribe_url} -o clash/configs/raw_config_${x}.yaml
    echo "Downlaods ${x}th config"
    x=$(( $x + 1 ))
    subscribe_url=$(/usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/read_yaml.py subscribe_urls ${x})
done

# touch ${MYCLASH_ROOT_PWD}/clash/configs/config.yaml
/usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/yaml_merge.py 0
# chmod 666 ${MYCLASH_ROOT_PWD}/clash/configs/config.yaml

# echo "Reload"
# /usr/bin/python3 ${MYCLASH_ROOT_PWD}/tools/update_proxy.py
# sleep 1
echo "Restart,may need password"
sudo systemctl restart clash.service