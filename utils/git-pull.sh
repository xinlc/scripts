#!/bin/bash
##
## git 批量更新当前目录下所有项目
##
## Started on 2020/03/10 Leo <xinlichao2016@gmail.com>
## Last update 2020/03/10 Leo <xinlichao2016@gmail.com>
##

baseDir=$(pwd)
#ls | while read file
Dirs=$(ls -l | grep '^d' | awk '{print $9}')
for file in $Dirs; do
  echo 
  echo "git pull $file ...................."
  echo 
  if [ -d $file ]; then
    cd $file
    git pull
    cd $baseDir
  fi
done
