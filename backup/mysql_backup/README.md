
## mysqldump

```bash
# 1、备份命令
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --database 数据库名 > 文件名.sql
mysqldump -h 192.168.1.100 -P 3306 -uroot -ppassword --database cmdb > /data/backup/cmdb.sql

# 备份压缩
# 导出的数据有可能比较大，不好备份到远程，这时候就需要进行压缩
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --database 数据库名 | gzip > 文件名.sql.gz
mysqldump -h192.168.1.100 -P 3306 -uroot -ppassword --database cmdb | gzip > /data/backup/cmdb.sql.gz

# 备份同个库多个表
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --database 数据库名 表1 表2 .... > 文件名.sql
mysqldump -h192.168.1.100 -P3306 -uroot -ppassword cmdb t1 t2 > /data/backup/cmdb_t1_t2.sql

# 同时备份多个库
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --databases 数据库名1 数据库名2 数据库名3 > 文件名.sql
mysqldump -h192.168.1.100 -uroot -ppassword --databases cmdb bbs blog > /data/backup/mutil_db.sql

# 备份实例上所有的数据库
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --all-databases > 文件名.sql
mysqldump -h192.168.1.100 -P3306 -uroot -ppassword --all-databases > /data/backup/all_db.sql

# 备份数据出带删除数据库或者表的sql备份
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --add-drop-table --add-drop-database 数据库名 > 文件名.sql
mysqldump -uroot -ppassword --add-drop-table --add-drop-database cmdb > /data/backup/all_db.sql

# 备份数据库结构，不备份数据
# 格式：mysqldump -h主机名 -P端口 -u用户名 -p密码 --no-data 数据库名1 数据库名2 数据库名3 > 文件名.sql
mysqldump --no-data –databases db1 db2 cmdb > /data/backup/structure.sql

# 恢复数据
# 系统命令行
# 格式：mysql -h链接ip -P(大写)端口 -u用户名 -p密码 数据库名 < 文件名.sql
mysql -uusername -ppassword db1 < db1.sql

# 或mysql命令行
mysql>
user db1;
source db1.sql;

```
## crontab

```bash
# 查看状态
service crond status
# 启动服务
/sbin/service crond start
# 关闭服务
/sbin/service crond stop
# 重启服务
/sbin/service crond restart
# 重新载入配置
/sbin/service crond reload
# 查看任务
cat /etc/crontab
# 显示 crontab 文件
crontab -l
# 修改 crontab 文件.
crontab -e
# 删除 crontab 文件。
crontab -r

# 分钟 小时 天  月 星期几
# {minute} {hour} {day-of-month} {month} {day-of-week} {full-path-to-shell-script} 
# minute: 区间为 0 – 59 
# hour: 区间为0 – 23 
# day-of-month: 区间为0 – 31 
# month: 区间为1 – 12. 1 是1月. 12是12月. 
# Day-of-week: 区间为0 – 7. 周日可以是0或7.

# 在 12:01 a.m 运行，即每天凌晨过一分钟。这是一个恰当的进行备份的时间，因为此时系统负载不大。
1 0 * * * /root/bin/backup.sh

# 每5分钟运行一次命令
*/5 * * * * /root/bin/check-status.sh

# 每天12点12分执行备份
12 12 * * * /usr/bin/bash /home/leo/bakmysql.sh
```