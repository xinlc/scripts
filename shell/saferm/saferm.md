## 给 “rm” 命令添加个“垃圾桶”

## 下载
 
```bash
cd /bin
 
wget https://raw.githubusercontent.com/xinlc/scripts/master/shell/saferm/saferm.sh
 
chmod +x saferm.sh
```

## 配置
在 .bashrc 文件中设置别名，
```bash
alias rm=saferm.sh
```

执行下面的命令使其生效，
```bash
$ source ~/.bashrc
```