## 给 macOS “rm” 命令添加个“垃圾桶"

## 下载
 
```bash
cd ~

wget https://raw.githubusercontent.com/xinlc/scripts/master/shell//saferm/saferm2.sh
```

## 配置
在 .bashrc 文件中设置别名，
```bash
alias rm="sh ~/saferm2.sh"
```

执行下面的命令使其生效，
```bash
$ source ~/.bashrc
```

## 设置crontab
每天0点清空垃圾箱

```bash
crontab -e

# 添加下面任务
0 0 * * * rm -rf ~/.Trash/*
```
