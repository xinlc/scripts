#!/bin/bash
db_user="root"
db_passwd="root"
db_host="192.168.1.101"
db_prod="3306"
db_name="test"
backup_dir="/Users/leo/Downloads/bakmysql"
backup_old_dir="/Users/leo/Downloads/bakmysqlold"

echo $backup_old_dir

#进入备份目录将之前的移动到old目录
cd "$backup_dir"
echo "you are in bakmysql directory now"
mv $db_name* "$backup_old_dir"
echo "Old databases are moved to bakmysqlold folder"

#时间格式
time=$(date +"%Y-%m-%d")

#mysql 备份的命令，注意有空格和没有空格
mysqldump -h$db_host -P$db_prod -u$db_user -p$db_passwd $db_name | gzip > "$backup_dir/$db_name"-"$time.sql.gz"
echo "your database backup successfully completed"

#这里将7天之前的备份文件删掉
SevenDays=$(date -d -7day  +"%Y-%m-%d")
if [ -f "$backup_old_dir/$db_name-$SevenDays.sql.gz" ]
then
rm -rf "$backup_old_dir/$db_name-$SevenDays.sql.gz"
echo "you have delete 7days ago bak sql file "
else
echo "7days ago bak sql file not exist "
echo "bash complete"
fi

# 通过下面命令将脚步加入系统的计划任务
# crontab -e
# 分钟 小时 天  月 星期几
# 每天12点12分执行备份
# crontab -e
# 12 12 * * * /usr/bin/bash /home/hst/bakmysql.sh
# 也许需要重启crontab  启用命令：/sbin/service crond restart
