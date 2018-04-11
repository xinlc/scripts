
# FTP 上传一键脚本ftp_upload.sh

> Intro: https://teddysun.com/484.html


## 下载该脚本并赋予执行权限

下载脚本到本地待上传文件的目录下，比如：/data/www/default

```bash
cd /data/www/default
wget --no-check-certificate https://github.com/teddysun/across/raw/master/ftp_upload.sh
chmod +x ftp_upload.sh
```

##修改并配置脚本
请使用 vim 或 nano 等工具来修改。

关于变量名的一些说明：

* LOCALDIR （脚本当前所在目录）
* LOGFILE （脚本运行产生的日志文件路径）
* FTP_HOST （连接的 FTP 域名或 IP 地址）
* FTP_USER （连接的 FTP 的用户名）
* FTP_PASS （连接的 FTP 的用户的密码）
* FTP_DIR （连接的 FTP 的远程目录，比如： public_html）

一些注意事项的说明：

1）脚本需要用到 ftp 命令，请事先安装好；
2）脚本运行产生的日志文件路径不要乱改；
3）脚本需运行在待上传文件的目录下；
4）脚本后面跟含有通配符的参数时，一定要加双引号。

# 脚本运行示例
脚本会显示待上传文件列表，并在最后统计出所需时间。

上传当前目录下的文件 filename.tgz

```bash
./ftp_upload.sh filename.tgz
```

上传当前目录下的多个文件 filename1.tgz，filename2.tgz，filename3.tgz

```bash
./ftp_upload.sh filename1.tgz filename2.tgz filename3.tgz
```

上传当前目录下的通配符文件 *.tgz（注意此时后面跟的参数要加双引号）

```bash
./ftp_upload.sh "*.tgz"
```

上传当前目录下的多个通配符文件 *.tgz，*.gz（注意此时后面跟的参数要加双引号）

```bash
./ftp_upload.sh "*.tgz" "*.gz"
```
