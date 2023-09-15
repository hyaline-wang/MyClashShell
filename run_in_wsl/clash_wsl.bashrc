alias clash_shell_on="export http_proxy=http://$clash_host_ip:7890;\
export https_proxy=http://$clash_host_ip:7890;
echo \"start proxy in Terminal\";
"
clash_shell_on
alias clash_shell_off='unset http_proxy;unset https_proxy
echo "close proxy in Terminal"
'

export apt_proxy="-o Acquire::http::proxy=http://$clash_host_ip:7890"

alias clash_ok="source ${CLASH_PWD}/test_proxy_status.sh "
