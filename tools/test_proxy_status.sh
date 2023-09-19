#!/bin/bash
source ${MY_CLASH_BASH_PWD}/../tools/common_func.sh
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
echo "测试Google连接"
timeout 1 curl https://www.google.com > /dev/null 2>/dev/null
if [ $? = 0 ] 
then
    echo_G "连接正常"
else
    echo_R "连接失败"
fi