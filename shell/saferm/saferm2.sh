#!/bin/bash  
trash_dir="/Users/lichao/.Trash"  
date=`date "+%Y%m%d"`  
mkdir -p ${trash_dir}/${date}  
for i in $*  
do  
    suffix=`date "+%H%M%S"`  
    if [ ! -d "${i}" ]&&[ ! -f "${i}" ]  
    then  
        echo "[${i}] do not exist"  
    else  
        file_name=`basename $i`  
        mv $i ${trash_dir}/${date}/${file_name}_${suffix}_${RANDOM}  
        echo "[${i}] delete  completed"  
    fi  
done 


# or
# PARA_CNT=$#  
# TRASH_DIR="/home/username/.trash"  
  
# for i in $*; do  
#     STAMP=`date +%s`  
#     fileName=`basename $i`  
#     mv $i $TRASH_DIR/$fileName.$STAMP  
# done  