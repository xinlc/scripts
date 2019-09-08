#!/bin/bash
db_user="root"
db_passwd="123456"
db_name="test_db"
#进入备份目录将之前的移动到old目录
cd /mnt/backup/bakmysql
echo "you are in bakmysql directory now"
mv test_db* /mnt/backup/bakmysqlold
echo "Old databases are moved to bakmysqlold folder"
#备份目录
backup_dir="/mnt/backup/bakmysql"
#时间格式
time=$(date +"%Y-%m-%d")
#mysql 备份的命令，注意有空格和没有空格
mysqldump -u$db_user -p$db_passwd $db_name  > "$backup_dir/$db_name"-"$time.sql"
echo "your database backup successfully completed"
#这里将7天之前的备份文件删掉
SevenDays=$(date -d -7day  +"%Y-%m-%d")
if [ -f /mnt/backup/bakmysqlold/pashanhu-$SevenDays.sql ]
then
rm -rf /mnt/backup/bakmysqlold/pashanhu-$SevenDays.sql
echo "you have delete 7days ago bak sql file "
else
echo "7days ago bak sql file not exist "
echo "bash complete"
fi

# 然后通过下面命令将脚步加入系统的计划任务
# crontab -e
# 0 2 * * * cd /usr/sbin/ && ./bakmysql.sh
# 也许需要重启crontab  启用命令：/sbin/service crond restart