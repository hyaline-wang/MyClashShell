#!/bin/bash
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

echo "删除旧版本"
systemctl disable clash
echo remove old clash.service
# TODO:remove /etc/systemd/system/clash.service
rm -f ./clash.service >> /dev/null
rm -f /etc/systemd/system/clash.service >> /dev/null

systemctl stop clash.service
systemctl daemon-reload >> /dev/null

echo "remove config in /etc/bash.bashrc"
start_line=$(cat /etc/bash.bashrc|grep clash_env_set_start -n|head -n 1|cut -d: -f1)
end_line=$(cat /etc/bash.bashrc|grep clash_env_set_end -n|head -n 1|cut -d: -f1)
# echo "delete ${start_line}~${end_line}"
sed -i "${start_line},${end_line}d" /etc/bash.bashrc

