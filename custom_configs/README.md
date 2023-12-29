# 如何添加自定义配置
通过创建与`subscribes`中与`<your_proxy_name>`同名的yaml文件，可以在其中编写对应的自定义配置，主要包含两个部分，可以参考example.yaml，下面是详细介绍

## 更改参数

```yaml
# clash 默认端口为 7890,你也可以改成其他值
port: 7890
#
socks-port: 7891
# 允许局域网中的其他设备使用这个代理 true/false
allow-lan: true
# Rule/Direct/Global
mode: Rule
# info / debug / 
log-level: info
# rest api 端口，默认为 9090
external-controller: :9090
```

## 更改规则

规则包含三大部分
- proxies ： 节点
- proxy-groups ： 代理组
- rules ： 规则

我们一般不会新增节点，但是可能需要自定义部分 代理组或者规则

### 新增代理组
下面是一个实例
```yaml
proxy-groups:
  - name: new-group-name_1
    type: select
    proxies:
      - ♻️ 自动选择
      - DIRECT
      - 🏳️‍🌈 【高速节点区↓ 禁止大流量下载】
      - 🇸🇬 推荐|中转新加坡 三网通用带宽充足
  - name: new-group-name_2
    type: select
    proxies:
      - DIRECT
      - 🏳️‍🌈 【高速节点区↓ 禁止大流量下载】
      - 🇯🇵 推荐|中转日本1 三网通用带宽充足
      - 🇺🇸 推荐|中转美国1 三网通用带宽充足    

```
上面涉及到的节点
- ♻️ 自动选择
- DIRECT
- 🏳️‍🌈 【高速节点区↓ 禁止大流量下载】
- 🇸🇬 推荐|中转新加坡 三网通用带宽充足
- 🇯🇵 推荐|中转日本1 三网通用带宽充足
- 🇺🇸 推荐|中转美国1 三网通用带宽充足  
其中 前两个分别是 根据网络情况自动选择和直连选项，其他四个是`proxies`中的节点，根据自己的代理情况填写

# 如何生效配置

在更新代理(`myclash service update_subscribes`)时自动完成覆盖和添加，若修改了`custom_configs`那么请重新运行。