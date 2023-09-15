#!/bin/bash
echo "测试Google连接"
timeout 1 curl https://www.google.com > /dev/null 2>/dev/null
if [ $? = 0 ] 
then
    echo "连接正常"
else
    echo "连接失败"
fi