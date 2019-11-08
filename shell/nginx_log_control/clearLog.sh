#!/bin/bash
##
## 切割 log
##
## Started on 2019/11/8 Leo <xinlichao2016@gmail.com>
## Last update 2019/11/8 Leo <xinlichao2016@gmail.com>
##

LOGS_PATH=/home/leo/docker-data/nginx-router/logs/history
CUR_LOGS_PATH=/home/leo/docker-data/nginx-router/logs
DOCKER_COMPOSE_FILE=/home/leo/docker/nginx-router/docker-compose.yml
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

# 按天切割日志
mv ${CUR_LOGS_PATH}/access.log ${LOGS_PATH}/old_access_${YESTERDAY}.log
mv ${CUR_LOGS_PATH}/error.log ${LOGS_PATH}/old_error_${YESTERDAY}.log

# 向 NGINX 主进程发送 USR1 信号。USR1 信号是重新打开日志文件
# 向 nginx 主进程发送USR1信号，重新打开日志文件，否则会继续往mv后的文件写数据的。原因在于：linux系统中，内核是根据文件描述符来找文件的。如果不这样操作导致日志切割失败。
# docker 执行
# bash -c 执行字符串命令。注意是 ‘’ 不是 “”, 双引号$()会在当前主机环境执行
docker-compose -f ${DOCKER_COMPOSE_FILE} exec nginx-router bash -c 'kill -USR1 $(cat /var/run/nginx.pid)'

# kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid)
# kill -USR1 $(ps axu | grep "nginx: master process" | grep -v grep | awk '{print $2}')

# 日志切割
# /usr/local/nginx/sbin/nginx -s reopen

# 删除7天前的日志
find ${LOGS_PATH} -mtime +7 -type f -name \*.log | xargs rm -f

# cd ${LOGS_PATH}
# find . -mtime +7 -name "*20[1-9][3-9]*" | xargs rm -f




# 通过下面命令将脚步加入系统的计划任务
# crontab -e
# 分钟 小时 天  月 星期几
# 每天01点10分执行
# crontab -e
# 10 01 * * * /usr/bin/bash /home/leo/clearLog.sh
# 10 01 * * * /usr/bin/bash /home/leo/clearLog.sh >> /dev/null 2>&1
# crontab 会自动加在配置，你也可以重启crontab  启用命令：/sbin/service crond restart

# find . -amin -10 # 查找在系统中最后10分钟访问的文件
# find . -atime -2 # 查找在系统中最后48小时访问的文件
# find . -empty # 查找在系统中为空的文件或者文件夹
# find . -group cat # 查找在系统中属于 groupcat的文件
# find . -mmin -5 # 查找在系统中最后5分钟里修改过的文件
# find . -mtime -1 #查找在1天以内修改过的文件
# find . -mtime +7 #查找在7天以外修改过的文件
# find . -nouser #查找在系统中属于作废用户的文件
# find . -user fred #查找在系统中属于FRED这个用户的文件
# find . -type -f # 查找文件类型为普通文件的文件

# /sbin/service crond start
# /sbin/service crond stop
# /sbin/service crond restart
# /sbin/service crond reload
# ubuntu下为：
# /etc/init.d/cron start