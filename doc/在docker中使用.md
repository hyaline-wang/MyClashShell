# 在docker中使用

## docker pull 走代理

[Docker的三种网络代理配置 &middot; 零壹軒·笔记](https://note.qidong.name/2020/05/docker-proxy/)

在执行`docker pull`时，是由守护进程`dockerd`来执行。 因此，代理需要配在`dockerd`的环境中。 而这个环境，则是受`systemd`所管控，因此实际是`systemd`的配置。

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/proxy.conf
sudo vim /etc/systemd/system/docker.service.d/proxy.conf
```

在这个`proxy.conf`文件（可以是任意`*.conf`的形式）中，添加以下内容：

```
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890/"
Environment="HTTPS_PROXY=http://127.0.0.1:7890/"
```

最后

```
systemctl daemon-reload
systemctl restart docker
```
## 在容器中使用clash
docker的机制里不支持systemctl 所以docker 想使用 clash ，只能通过与主机共享来实现
TODO



# Note
docker依赖于宿主机上的clash,正常情况下，主机IP为 172.17.0.1,所以这里取了巧，写死了宿主机IP。# 在docker中使用
