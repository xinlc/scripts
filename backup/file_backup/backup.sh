#!/bin/bash
FTP_USER=[ftp服务器用户名]
FTP_PASS=[ftp登陆密码]
FTP_IP=[ftp服务器地址，如果在同一局域网建议使用内网地址，在公网的要打开端口映射]
FTP_PORT=[测试时建议使用21，之后改为高位端口号比较好]
FTP_backup=backup[在ftp服务器的根目录新建一个backup目录，然后脚本中指向往这个目录里塞备份文件]
WEB_DATA=/home/www/website[你要备份的网站根目录]
WebBakName=website_$(date +%Y%m%d).tar.gz
OldWeb=Web_$(date -d -5day +"%Y%m%d").tar.gz
#删除本地3天前的数
rm -rf /tmp/backup/Web_$(date -d -3day +"%Y%m%d").tar.gz
cd /tmp/backup
tar zcf $WebBakName --exclude=website/wget-log $WEB_DATA
ftp -v -n -p  << END
open $FTP_IP $FTP_PORT
user $FTP_USER $FTP_PASS
type binary
cd $FTP_backup
delete $OldWeb
put $WebBakName
bye
END
