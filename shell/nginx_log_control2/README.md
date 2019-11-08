# nginxLogControl

> Control your nginx error log and access log limited in 7 days or any day you like.

[document](http://www.liumapp.com/articles/2017/06/01/1496286037699.html)

## how to use 

* put clearLog.sh and delLog.sh in your server anywhere you like . (maybe the nginx log folder shall be great)

* chmod -R 777 clearLog.sh delLog.sh. 

* crontab -e (make sure your server started crontab,or you can just enter line like "/sbin/service/crond start")

* add following code:

	```
		55 23 * * * /usr/local/nginx/logs/clearLog.sh
		59 23 * * * /usr/local/nginx/logs/delLog.sh
	```

* of course you need change the path , while your nginx log folder located in different location.

* nginx -s reload (reload your nginx at the beginning)

## QA

### 为什么最后重启nginx？

nginx在运行状态下，access.log和error.log两个文件的资源句柄并没有被释放，此时脚本是无法做到彻底删除这两个文件的，只有通过nginx重启，手动的释放资源句柄后才可。

## 技术细节

```bash
find . -amin -10 # 查找在系统中最后10分钟访问的文件
find . -atime -2 # 查找在系统中最后48小时访问的文件
find . -empty # 查找在系统中为空的文件或者文件夹
find . -group cat # 查找在系统中属于 groupcat的文件
find . -mmin -5 # 查找在系统中最后5分钟里修改过的文件
find . -mtime -1 #查找在1天以内修改过的文件
find . -mtime +7 #查找在7天以外修改过的文件
find . -nouser #查找在系统中属于作废用户的文件
find . -user fred #查找在系统中属于FRED这个用户的文件
find . -type -f # 查找文件类型为普通文件的文件
```
