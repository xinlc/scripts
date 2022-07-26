
## 第一种

```bash
bash <(curl -s -L https://git.io/v2ray.sh)

systemctl stop firewalld.service # 关防火墙
systemctl disable firewalld.service # 禁止自启
```

## 第二种

```bash
# 建议使用 Debian 9（代号Stretch） 版本
bash <(curl -L -s https://install.direct/go.sh)

# 启动 V2Ray:
sudo systemctl start v2ray
# 停止运行 V2Ray：
sudo systemctl stop v2ray
# 重启 V2Ray:
sudo systemctl restart v2ray

# 可能会出现-bash: curl: command not found的错误提示，解决办法是先执行apt-get update 在执行apt-get install curl

# 修改配置
vi /etc/v2ray/config.json

# 重启 V2Ray 生效
systemctl restart v2ray
```

### 校准时间

即便配置没有任何问题，如果时间不正确也无法连接 V2Ray 服务器，所以服务器、手机和电脑等系统时间一定要正确，时间误差不能超过一分钟。

```bash
# 时间查询命令。 返回：Wed, 07 Nov 2018 12:41:38 +0000，输出结果中的+0000代表 0 时区格林威治标准时间，换成东八区的上海时间则为 2018 20:41:38，时间是准确的。这里补充一下，时区不同没关系，只要换算后的时间是准确即可。
date -R

# 时间修改命令
date --set="2018-11-07 13:29:10"
```

## 第三种

Trojan+gRPC+TLS

```bash
# 1. 注册域名 https://www.namesilo.com/ 这个商家支持域名隐私保护，注册域名时注意要开启隐私保护：Privacy Setting -> WHOIS Privacy

# 2. 用 https://www.cloudflare.com 接管域名解析，托管到CDN的目的是让域名解析生效时间更快（30秒左右，不使用CDN可能要十多分钟）

# 3. https://github.com/mack-a/v2ray-agent
yum update && yum install -y wget curl

wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
  # nginx 可能会需要添加端口
    # semanage port -l | grep http_port_t
    # semanage port -a -t http_port_t -p tcp 31300

# 重新打开脚本
vasma

# 4. https://github.com/yichengchen/clashX

# 参考：v2ray使用cloudflare中转流量，拯救被墙ip（https://vpsgongyi.com/p/2273/）
```

## 客户端

### mac 客户端

```bash
https://github.com/Cenmrev/V2RayX
brew cask install v2rayx

https://github.com/yanue/V2rayU
brew cask install v2rayu

https://github.com/Qv2ray/Qv2ray

https://github.com/Dr-Incognito/V2Ray-Desktop

https://github.com/yichengchen/clashX
https://github.com/Fndroid/clash_for_windows_pkg
```

### win 客户端

```bash
https://github.com/Qv2ray/Qv2ray
https://github.com/Cenmrev/V2RayW
https://github.com/2dust/v2rayN
https://github.com/Fndroid/clash_for_windows_pkg
```

### android 客户端

```bash
https://github.com/2dust/v2rayNG
https://apkpure.com/bifrostv/com.github.dawndiy.bifrostv
https://github.com/Kr328/ClashForAndroid
```

## 下载 V2Ray
预编译的压缩包可以在如下几个站点找到：

Github Release: github.com/v2ray/v2ray-core
Github 分流: github.com/v2ray/dist
Homebrew: github.com/v2ray/homebrew-v2ray
Arch Linux: packages/community/x86_64/v2ray/
Snapcraft: snapcraft.io/v2ray-core

## 参考

- [v2ray](https://www.v2ray.com)
- [一个 V2Ray 配置文件模板收集仓库](https://github.com/KiriKira/vTemplate)
- [v2rayssr 综合网](https://www.v2rayssr.com)
- [新 V2Ray 白话文指南](https://github.com/v2fly/v2ray-step-by-step/tree/dev)
- [v2ray 官方文档](https://github.com/v2fly/v2fly-github-io/tree/v5-zh)
