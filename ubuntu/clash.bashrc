#!/bin/bash
myclash()
{
    case $1 in
    'service')
        if [ $2 = "on" ]; then
            sudo systemctl start clash
        elif [ $2 = "off" ]; then
            sudo systemctl stop clash
        elif [ $2 = "restart" ]; then
            sudo systemctl restart clash
        elif [ $2 = "status" ]; then
            sudo systemctl status clash
        elif [ $2 = "get_logs" ]; then
            echo RUNNING
            curl --location 'http://127.0.0.1:9090/logs'
        else
            echo command $1 $2 not exist
        fi
        ;;
    'window')
        if [ $2 = "on" ]; then
            # Anaconda /bin 也有叫做 gsettings 的程序,所以给了绝对路径
            # 以下设置也适用于 unity 桌面
            /usr/bin/gsettings set org.gnome.system.proxy.http host 127.0.0.1
            /usr/bin/gsettings set org.gnome.system.proxy.http port 7890
            /usr/bin/gsettings set org.gnome.system.proxy.https host 127.0.0.1
            /usr/bin/gsettings set org.gnome.system.proxy.https port 7890
            /usr/bin/gsettings set org.gnome.system.proxy mode manual
            echo "start proxy in Gnome Desktop"
        elif [ $2 = "off" ]; then
            gsettings set org.gnome.system.proxy mode none
            echo "close proxy in Gnome Desktop"
        else
            echo command $1 $2 not exist
        fi
        ;;
    'shell')
        if [ $2 = "on" ]; then
            export http_proxy=http://127.0.0.1:7890
            export https_proxy=http://127.0.0.1:7890
            echo "start proxy in Terminal"
        elif [ $2 = "off" ]; then
            unset http_proxy;unset https_proxy
            echo "close proxy in Terminal"
        else
            echo command $1 $2 not exist
        fi
        ;;
    'ping_test')
        bash ${MY_CLASH_BASH_PWD}/../tools/test_proxy_status.sh
        ;;
    'update')
        bash ${MY_CLASH_BASH_PWD}update_proxy_config.sh
        ;;
    'help')
        echo "myclash [command] [option*]"
        echo "command:"
        echo "      service [ on/off/restart/status ]"
        echo "              默认情况下,myclash将会开机自启,但你可以手动开启，关闭或重启服务"
        echo "      window [ on/off ]"
        echo "              图形化应用(如 chrome )是否开启代理"
        echo "      shell [ on/off ]"
        echo "              在 当前 命令行是否开启代理,default:on"
        echo "      ping_test"
        echo "              测试代理连通性,必须 myclash shell on后才能使用"
        echo "      update"
        echo "              更新代理" 
        ;;
    *)
        echo Myclash V1.0
        echo use
        myclash help
    esac
    
}
_myclash()
{
    local cur=${COMP_WORDS[COMP_CWORD]};
    local cmd=${COMP_WORDS[COMP_CWORD-1]};
    # echo ">>>>>>>"
    # echo cur $cur
    # echo ">>>>>>>"
    # echo cmd $cmd
    case $cmd in
    'myclash')
        COMPREPLY=( $(compgen -W 'service window shell ping_test help update' -- $cur) ) 
        ;;
    'service')
        COMPREPLY=( $(compgen -W 'on off restart status get_logs' -- $cur) ) 
        ;;
    'window')
        COMPREPLY=( $(compgen -W 'on off' -- $cur) ) 
        ;;
    'shell')
        COMPREPLY=( $(compgen -W 'on off' -- $cur) ) 
        ;;
    '*')
        ;;
    esac
}
complete -F _myclash myclash

export apt_proxy='-o Acquire::http::proxy=http:127.0.0.1:7890'

# alias clash_ctl_on='sudo systemctl start clash'
# alias clash_ctl_off='sudo systemctl stop clash'
# alias clash_ctl_restart='sudo systemctl restart clash'
# alias clash_ctl_status='systemctl status clash'
# # Anaconda /bin 也有叫做 gsettings 的程序,所以给了绝对路径
# # 以下设置也适用于 unity 桌面
# alias clash_window_on='
# /usr/bin/gsettings set org.gnome.system.proxy.http host 127.0.0.1
# /usr/bin/gsettings set org.gnome.system.proxy.http port 7890
# /usr/bin/gsettings set org.gnome.system.proxy.https host 127.0.0.1
# /usr/bin/gsettings set org.gnome.system.proxy.https port 7890
# /usr/bin/gsettings set org.gnome.system.proxy mode manual
# echo "start proxy in Gnome Desktop"
# '

# alias clash_window_off='gsettings set org.gnome.system.proxy mode none
# echo "close proxy in Gnome Desktop"
# '
# alias clash_shell_on='export http_proxy=http://127.0.0.1:7890;export https_proxy=http://127.0.0.1:7890
# echo "start proxy in Terminal"
# '
# # clash_shell_on
# alias clash_shell_off='unset http_proxy;unset https_proxy
# echo "close proxy in Terminal"
# '
# # alias clash_manage='firefox http://clash.razord.top'


# alias clash_ok="source ${CLASH_PWD}/tools/test_proxy_status.sh "
