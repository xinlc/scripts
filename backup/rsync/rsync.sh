# 客户端同步到远程的脚本rsync.sh

#rsync auto sync script with inotify
#variables
current_date=$(date +%Y%m%d_%H%M%S)
source_path=/bak/mysqlbak/
log_file=/var/log/rsync_client.log
#rsync
rsync_server=192.168.53.86
rsync_user=root
rsync_pwd=/etc/rsync_client.pwd
rsync_module=mysqlbak
INOTIFY_EXCLUDE='(.*/*\.log|.*/*\.swp)$|^/tmp/src/mail/(2014|20.*/.*che.*)'
RSYNC_EXCLUDE='/bak/rsync_exclude.lst'
#rsync client pwd check
if [ ! -e ${rsync_pwd} ];then
    echo -e "rsync client passwod file ${rsync_pwd} does not exist!"
    exit 0
fi
#inotify_function
inotify_fun(){
    /usr/bin/inotifywait -mrq --timefmt '%Y/%m/%d-%H:%M:%S' --format '%T %w %f' \
          --exclude ${INOTIFY_EXCLUDE}  -e modify,delete,create,move,attrib ${source_path} \
          | while read file
      do
          /usr/bin/rsync -auvrtzopgP --exclude-from=${RSYNC_EXCLUDE} --progress --bwlimit=200 --password-file=${rsync_pwd} ${source_path} ${rsync_user}@${rsync_server}::${rsync_module}
      done
}
#inotify log
inotify_fun >> ${log_file} 2>&1 &


# 给脚本执行权限，执行后就可以了
# chmod 777 rsync.sh
# ./rsync.sh