# 在ubuntu中使用

## 硬件支持

- AMD64
- ARMv8
- ARMv7a
  

## 安装

**本教程默认你已经会使用clash在某个平台上使用魔法了，否则请先学会如何使用clash。**

1. ```bash
   git clone https://github.com/hyaline-wang/MyClashShell.git
   cd MyClashShell
   mkdir -p config_urls
   touch config_urls/default.txt
   ```

2. 将 订阅链接 复制到 **default.txt** 中,注意是Clash用的订阅链接，如果你用过windows 下的 Clash 就应该知道。

3. 在**MyClashShell根目录**下，运行 **../ubuntu/config_clash.sh <架构>** ,脚本会自动帮你完成配置,中途需要你输入一次密码使得能够使用systemd控制clash 运行。如
   
   ```bash
   sudo ../ubuntu/config_clash.sh AMD64
   # 你可以选择 AMD64 ARMv8 或 ARMv7a
   ```
4. 完成

<!-- ## 更新订阅

1. 修改clash_link.txt 为新的 订阅链接
2. ./update_clash_url.sh -->