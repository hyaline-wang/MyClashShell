# 在ubuntu中使用

## 硬件支持

- amd64
- armv8
- armv7a
  

## 安装

**本教程默认你已经会使用clash在某个平台上使用魔法了，否则请先学会如何使用clash。**

1. ```bash
   git clone https://github.com/hyaline-wang/MyClashShell.git
   cd MyClashShell
   ```

2. 安装: 
   ```bash
   cd ubuntu
   sudo ./install.sh amd64
   source /etc/bash.bashrc ;source ~/.bashrc
   ```
3. 修改 myclash 目录下生成的 config.yaml
   ```yaml
   shell_proxy_default: 'ON'  ##  ON  / OFF
   subscribes:
     <your_proxy_name>: "<you_proxy_url>"
   default_subscribe: "DEFAULT"
   ```
   - <your_proxy_name>和<you_proxy_url>分别指 自己为这个代理设定的名字 以及 订阅链接，
   - shell_proxy_default: 选择是否自动在命令行开启代理
   - default_subscribe： 这是默认使用的代理，你可以填subscribe_urls中的任意名字,DEFAULT 是指使用 subscribe_urls 中的第一个

3. 更新订阅
   ```bash
      myclash service update_subcribe 
   ```
4. 使用 `myclash` 命令查看软件信息
4. 通过`myclash help` 查看帮助

# 多代理

针对有多个代理的情况,myclashshell允许同时添加多个代理
```yaml
shell_proxy_default: 'ON'  ##  ON  / OFF
subscribes:
    <your_proxy_name_1>: "<you_proxy_url_1>"
    <your_proxy_name_2>: "<you_proxy_url_2>"
    <your_proxy_name_3>: "<you_proxy_url_3>"
default_subscribe: "DEFAULT"
```



# Q&A

## Nvidia Omniverse

**Isaac Sim** 中一些 assets 可能需要访问 aws 下载，但是在使用代理时可能遇到一些资产无法下载的问题。

> 1. 添加一个规则直连aws (未测试)
> 2. 将 `shell_proxy_default` 改为 `OFF` (已测试)

## chatgpt

可以通过修改custom_configs解决
1. custom_configs中创建一个与所用代理名字相同的yaml文件，并复制example.yaml中的中的所有内容
1. 在 proxies-groups 中添加 GPT,proxies 中是可以正常访问GPT的节点(根据实际情况填)

    ```json
    - name: GPT 
        type: select
        proxies:
        - 🇭🇰 美国01-广港专线
        - 🇭🇰 美国02-广港专线
    ```

2. 添加四组 rules

    ```json
        - DOMAIN-SUFFIX,openai.com,GPT
        - DOMAIN-SUFFIX,auth0.com,GPT
        - DOMAIN-SUFFIX,bing.com,GPT
        - DOMAIN-SUFFIX,live.com,GPT
    ```
3. 使用 `myclash service update_subcribe` 完成更新 
4. 现在应该可以正常使用 chatgpt 了，你也可在尝试时通过 `myclash service get-logs` 监控openai的网站是否使用了设置的规则
