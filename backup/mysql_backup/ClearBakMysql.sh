#!/bin/bash
##
## 删除备份文件
##
## Started on 2019/11/8 Leo <xinlichao2016@gmail.com>
## Last update 2019/11/8 Leo <xinlichao2016@gmail.com>
##

BAKINCRE_PATH=/home/leo/mysqlbackup/bakincre

# 删除7天前文件
find ${BAKINCRE_PATH} -mtime +7 -type f -name "*.*" | xargs rm -f

# 通过下面命令将脚步加入系统的计划任务
# crontab -e
# 分钟 小时 天  月 星期几
# 每天01点30分执行
# crontab -e
# 30 01 * * * /usr/bin/bash /home/leo/scripts/clearBakMysql.sh >> /dev/null 2>&1
