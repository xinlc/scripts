## 给 macOS “rm” 命令添加个“垃圾桶”

## 下载
 
```bash
cd ~

wget https://raw.githubusercontent.com/xinlc/scripts/master/shell/safermformac.sh
```

## 配置
在 .bash_profile 文件中设置别名，
```bash
alias rm="bash ~/safermformac.sh
```

## Mac下的readlink没有-f参数
1.安装coreutils：
```bash
brew install coreutils
```
2.设置环境变量，编辑~/.bash_profile，添加：
```bash
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
```
3.创建别名，使用greadlink替代readlink，同样是编辑~/.bash_profile，添加：
```bash
alias readlink=greadlink
```