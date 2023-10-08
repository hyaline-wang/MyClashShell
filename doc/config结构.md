
# Config 结构
## 结构
### 一级结构
- port: 7890
- socks-port: 7891
- allow-lan: true
- mode: Rule
- log-level: info
- external-controller: :9090
- proxies
  - 节点信息
- proxies-groups
  - 策略组
- rule
  - 代理规则，即每个域名设定使用的 proxies-groups

## chatgpt

1. 在 proxies-groups 中添加 GPT,proxies 中是可以正常访问GPT的节点

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
3. 使用 `myclash service restart` 重启clash 
4. 现在应该可以正常使用 chatgpt 了，你也可在尝试时通过 `myclash service get-logs` 监控openai的网站是否使用了设置的规则

### REF

## Nvidia Omniverse

**Isaac Sim** 中一些 assets 需要访问 aws 下载，但是在使用代理时可能遇到一些资产无法下载的问题。
> 你可以通过开启代理后