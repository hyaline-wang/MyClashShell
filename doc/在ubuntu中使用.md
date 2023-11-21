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
   ```

2. 安装: 
   ```bash
   cd ubuntu
   sudo ./install.sh amd64

   ```
3. 更新订阅
   ```bash
   # 修改刚刚自动生成的 config_custom.yaml
   
   ./update_proxy_config.sh

   或者新开一个窗口以生效配置
   myclash update
   ```