
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

## mac 客户端

```bash
https://github.com/Cenmrev/V2RayX
brew cask install v2rayx

https://github.com/yanue/V2rayU
brew cask install v2rayu
```

## win 客户端

```bash
https://github.com/Cenmrev/V2RayW
https://github.com/2dust/v2rayN
```

## android 客户端

```bash
https://github.com/2dust/v2rayNG
https://apkpure.com/bifrostv/com.github.dawndiy.bifrostv
```

## 下载 V2Ray
预编译的压缩包可以在如下几个站点找到：

Github Release: github.com/v2ray/v2ray-core
Github 分流: github.com/v2ray/dist
Homebrew: github.com/v2ray/homebrew-v2ray
Arch Linux: packages/community/x86_64/v2ray/
Snapcraft: snapcraft.io/v2ray-core

## 参考

[v2ray](https://www.v2ray.com)
[一个 V2Ray 配置文件模板收集仓库](https://github.com/KiriKira/vTemplate)
