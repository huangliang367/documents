# 设置git repo 代理

背景：windows本地安装了网络代理，可以科学上网，wsl中希望使用网络代理加速git, repo代码下载。

## 配置步骤

1. windows代理需打开局域网连接

2. 确定代理使用的端口7890...

3. 找到wsl访问Windows的IP地址

可以在windows中查看：

![windows_ip](/_static/misc/windows_ip.png)

4. git 配置代理

```shell
git config --global http.proxy "http://172.18.32.1:7897"
git config --global https.proxy "http://172.18.32.1:7897"
```

5. repo配置代理

```shell
export http_proxy=http://172.18.32.1:7897
export https_proxy=http://172.18.32.1:7897
export all_proxy=socks5://172.18.32.1:7897
```

6. 确认配置是否生效

```shell
curl ipinfo.io
```

![ipinfo](/_static/misc/ipinfo.png)

## docker配置代理

```shell
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```

输入以下内容：

```shell
[Service]
Environment="HTTP_PROXY=http://172.18.32.1:7897"
Environment="HTTPS_PROXY=http://172.18.32.1:7897"
```

重启docker

```shell
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart docker
```