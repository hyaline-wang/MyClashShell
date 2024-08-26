# 在docker中使用

## 在 docker pull 时走代理

[Docker的三种网络代理配置 &middot; 零壹軒·笔记](https://note.qidong.name/2020/05/docker-proxy/)

在执行`docker pull`时，是由守护进程`dockerd`来执行。 因此，代理需要配在`dockerd`的环境中。 而这个环境，则是受`systemd`所管控，因此实际是`systemd`的配置。

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo vim /etc/systemd/system/docker.service.d/proxy.conf
```

在这个`proxy.conf`文件（可以是任意`*.conf`的形式）中，添加以下内容：

```
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890/"
Environment="HTTPS_PROXY=http://127.0.0.1:7890/"
```

```bash
# 最后重启 Docker 服务
systemctl daemon-reload
systemctl restart docker
```

## 在 docker 容器中使用 clash
docker的机制里不支持systemctl 所以docker 想使用 clash ，只能通过与主机共享来实现

docker依赖于宿主机上的clash,正常情况下，使用

```bash
# 查看宿主机 Docker 虚拟网卡地址（本例为 172.17.0.1）
ifconfig

# 进入容器，配置代理环境变量
export http_proxy="http://172.17.0.1:7890"
```
