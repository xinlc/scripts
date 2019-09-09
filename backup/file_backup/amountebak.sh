#!/bin/bash
#增量备份
#根据项目同重命名该脚本
#例 amountebak.sh or pandawillsbak.sh
#该脚本放 $bakpp定义绝路径部
#$bakpp找相应备份文件
#例 /usr/backup/amountebak.sh or /usr/backup/pandawillsbak.sh
########## Init Path ########
# 面参数必须定义参数 $bakpp、$project、$projectpp
TAR=/bin/tar
# 存放备份文件项目名称区
bakpp=/apps/beifen/"$project"
# 需要备份文件夹文件夹路径
project=djk
projectpp=/apps/apache-tomcat-8.5.9/webapps/vlis/
# parament for varible
ym=$(date +%Y%m)
ymd=$(date +%Y%m%d)
# 存储备份文件目录月份区级目录$bakpp定义
monthbakpp=$bakpp/$ym
gidpp=$monthbakpp
gidshot=gid$project$ym
# 完全备份文件名
fullname=$ym
# 增量备份文件名
incrementalname=$ymd
# Record the location of the log
log=$bakpp/$project.log
############ chk_full #######################
# 检查完全备份否存存创建
#this function check fullbackup file exist or not , if not then create fullbackup now
chk_full() {
  if [ -e "$monthbakpp"/"$project"_"$ym"_full.tar.gz ]; then
    echo ""$project"_"$ym"_full.tar.gz file exist!! ====$(date +%Y-%m-%d-%T) " >>$log
  else
    tar_full
  fi
}
######### chk_incremental ########
# 检查增量备份否存
chk_incremental() {
  while [ -e "$monthbakpp"/"$project"_"$incrementalname"_incremental.tar.gz ]; do
    incrementalname=$(echo "$incrementalname + 0.1" | bc)
  done
}
######## tar_incremental #######
# 执行增量备份
tar_incremental() {
  cd $projectpp
  echo "BEIGIN_TIME=====$(date +%Y-%m-%d-%T) ==== CREATE "$project"_"$incrementalname"_incremental.tar.gz" >>$log
  sleep 3
  $TAR -g $gidpp/$gidshot -zcf $monthbakpp/"$project"_"$incrementalname"_incremental.tar.gz $project
  echo "END_TIME========$(date +%Y-%m-%d-%T) ==== CREATE "$project"_"$incrementalname"_incremental.tar.gz" >>$log
}
######## tar_full ###########
tar_full() {
  touch $gidpp/$gidshot
  cd $projectpp
  echo "BEIGIN_TIME=====$(date +%Y-%m-%d-%T) ==== CREATE "$project"_"$fullname"_full.tar.gz" >>$log
  $TAR -g $gidpp/$gidshot -zcf $monthbakpp/"$project"_"$fullname"_full.tar.gz $project
  echo "END_TIME========$(date +%Y-%m-%d-%T) ==== CREATE "$project"_"$fullname"_full.tar.gz" >>$log
}
########### backup ##############################
# 总体调用备份做相应检查确保备份前提准备充
backup() {
  if [ -d $monthbakpp ]; then
    chk_full
    chk_incremental
    tar_incremental
  else
    mkdir -p $bakpp/$ym
    tar_full
  fi
}
########### let's begin #############
# 先检查$bakpp否存存先创建备份
if [ -d $bakpp ]; then
  backup
else
  mkdir -p $bakpp
  backup
fi
#advice you can create a file for put backup file, eg /usr/cctcc
#crontab
#mini hours day month week command
# */5 * * * * /home/mmroot/zbb/aaa.sh
# 44 11 * * * /usr/tmp/vcan.sh
# tar -ztf test.tar.gz 查看备份文件面文件

# 将上述文件放到你要运行的文件中
# vi   /usr/tmp/vlisVcan.sh
# 上面代码复制粘贴
# 根据自己需求的不同只需要修改上面代码中的三个位置
# 存放备份文件项目名称区
# bakpp=/apps/beifen/"$project"
# 需要备份文件夹和文件夹路径
# project=djk
# projectpp=/apps/apache-tomcat-8.5.9/webapps/vlis/
# 然后在设置定时器,创建定时器文件
# vi  /usr/tmp/task
# 填写定时器
# 命令  文件 ；
# 分钟 小时 天  月 星期几
# 例：12 12 * /bin/sh /root/remove.sh                 //每天12点12分执行
# 保存文件然后利用crontab /usr/tmp/task 使生效。
# 查看任务列表 crontab -l  显示你设置的定时器就ok了。
