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
3. 修改 myclash 目录下生成的 config.yaml
3. 更新订阅
   ```bash
      myclash service update_subcribe 
   ```
4. 使用 `myclash` 命令查看软件信息
4. 通过`myclash help` 查看帮助