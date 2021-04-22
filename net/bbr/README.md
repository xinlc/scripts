
# 一键安装最新内核并开启 BBR 脚本
> Intro: https://teddysun.com/489.html

使用root用户登录，运行以下命令：
```bash
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
```

安装完成后，脚本会提示需要重启 VPS，输入 y 并回车后重启。
重启完成后，进入 VPS，验证一下是否成功安装最新内核并开启 TCP BBR，输入以下命令：

```bash
uname -r
```
查看内核版本，显示为最新版就表示 OK 了

# 最新一键BBR脚本

```bash
wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```
