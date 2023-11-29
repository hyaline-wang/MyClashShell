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

   ```
3. 更新订阅
   ```bash
   # 修改刚刚自动生成的 config_custom.yaml 中的 url1 为你自己的订阅链接
   # 有两种方法可以更新连接
   # 1.在当前窗口
   source /etc/bash.bashrc;source ~/.bashrc
   ./update_proxy_config.sh

   # 2.新开一个窗口 运行
   myclash update
   ```
 4. 使用帮助：可以通过myclash help 查看