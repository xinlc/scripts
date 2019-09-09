
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

# 常用
# 导出数据库
/usr/bin/mysqldump -u root -ppwd database > database20191001.sql
# 导入数据库
mysql -u root -p database < database20191001.sql

#备份到压缩文件
/usr/bin/mysqldump -u root -ppwd database  | gzip > database20191001.sql.gz
#从压缩文件导入
gzip < database20191001.sql.gz | mysql -u root -p database


# 备份开启新logs
# 参数 —flush-logs：使用一个新的日志文件来记录接下来的日志；
# 参数 —lock-all-tables：锁定所有数据库;
# 对于InnoDB将--lock-all-tables替换为--single-transaction
/usr/bin/mysqldump -uroot -p123456  --lock-all-tables --flush-logs test > /home/backup.sql


```
## crontab

```bash
# crontab会自动重新加载配置。所以不需要重启，但是如果你想马上生效，也可以重启它，这里附上命令。

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
# 显示 cron 任务
crontab -l
# 修改 cron 任务
crontab -e
# 删除 cron 任务
crontab -r
# 设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数
# root查看自己的cron设置:crontab -u root -l
crontab -u

# 任务分类
# 1、系统任务调度：系统周期性所要执行的工作，比如写缓存数据到硬盘、日志清理等。在/etc目录下有一个crontab文件，这个就是系统任务调度的配置文件. 如果要重启系统 root用户也不行，必须在这个文件中定义，其他任务就不建议在这个文件定义。
# 前四行用来配置crond任务运行的环境变量，其中：第一行SHELL变量指定了系统要使用哪个shell，这里是bash；第二行PATH变量指定了系统执行命令的路径；第三行MAILTO变量指定了crond的任务执行信息将通过电子邮件发送给root用户，如果MAILTO变量的值为空，则表示不发送任务执行信息给用户；第四行的HOME变量指定了在执行命令或者脚本时使用的主目录。

# 执行成功后悔发送邮件
# cat /var/spool/mail/{user}

# 2. 用户任务调度：用户定期要执行的工作，比如用户数据备份、定时邮件提醒等。用户可以使用crontab来定制自己的计划任务。所有用户定义的crontab文件都被保存在/var/spool/cron目录下，其文件名与用户名一致。

# crontab内容格式
# 分钟 小时 天  月 星期几
# {minute} {hour} {day-of-month} {month} {day-of-week} {full-path-to-shell-script} 
# minute: 区间为 0 – 59 
# hour: 区间为0 – 23 
# day-of-month: 区间为0 – 31 
# month: 区间为1 – 12. 1 是1月. 12是12月. 
# Day-of-week: 区间为0 – 7. 周日可以是0或7.

# 在以上各个字段中，还可以使用以下特殊字符：
# 星号（*）：代表所有可能的值，例如month字段如果是星号，则表示在满足其它字段的制约条件后每月都执行该命令操作。
# 逗号（,）：可以用逗号隔开的值指定一个列表范围，例如，“1,2,5,7,8,9”
# 中杠（-）：可以用整数之间的中杠表示一个整数范围，例如“2-6”表示“2,3,4,5,6”
# 正斜线（/）：可以用正斜线指定时间的间隔频率，例如“0-23/2”表示每两小时执行一次。同时正斜线可以和星号一起使用，例如*/10，如果用在minute字段，表示每十分钟执行一次。
# 示例：
# 下面是每隔多少分钟，每隔多少小时，每天/每周/每月/每年的crontab的归纳总结
# 每五分钟执行 */5 * * * *
# 每五小时执行 0 */5 * * *
# 每天执行 0 0 * * *
# 每周执行 0 0 * * 0
# 每月执行 0 0 1 * *
# 每年执行 0 0 1 1 *
# 如果说是每个月的每隔10天来执行某个脚本的话，同样可以写成:
# 每个月的1号，11号，21号，31号，执行HTTP服务重启
0 0 */10 * * /etc/init.d/service restart
# 下午6点到早上6点，每隔15分钟执行一次脚本
0,15,30,45 18-06 * * * /bin/bash /home/script.sh > /dev/null 2>&1
# 每两小时，重启一次服务
0 */2 * * * /etc/init.d/service restart
# 每天凌晨过一分钟。这是一个恰当的进行备份的时间，因为此时系统负载不大。
1 0 * * * /root/bin/back.sh
# 每个工作日(Mon – Fri) 11:59 p.m 都进行备份作业。
59 11 * * 1,2,3,4,5 /root/bin/test.sh
# 下面例子与上面的例子效果一样：
59 11 * * 1-5 /root/bin/test.sh

# 在 12:01 a.m 运行，即每天凌晨过一分钟。这是一个恰当的进行备份的时间，因为此时系统负载不大。
1 0 * * * /root/bin/backup.sh

# 每5分钟运行一次命令
*/5 * * * * /root/bin/check-status.sh

# 每天01点10分执行备份
10 01 * * * /usr/bin/bash /home/leo/bakmysql.sh
```