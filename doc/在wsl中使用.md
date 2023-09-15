# run in wsl 
run in wsl 的目的是与宿主机共享代理。
由于wsl内的IP端一直在改变，所以写死代理IP的方式并不可取
当然网上有一些办法可以固化IP，但是我希望程序可以智能一点。
所以run_in_wsl 依赖于python3 来获取eth0的ip

## USE
在run in wsl 目录下 运行
```bash
sudo ./run_in_wsl2.sh
```
开启一个新终端测试 测试效果