#!/bin/bash
##
## Jenkins 部署脚本
##
## Started on 2019/10/28 Leo <xinlichao2016@gmail.com>
## Last update 2019/10/28 Leo <xinlichao2016@gmail.com>
##

set -e

version="1.0.0"

# Colours
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
magenta="\033[95m"
cyan="\033[96m"
none="\033[0m"

# 项目ID
project_id=""

# 环境：development, testing, production
profile_name=""

# 构建版本：1.0.0
project_version="1.0.0"

# 模块相对项目根路径
modules_path=(
  all
  smart-apm/smart-admin
  smart-tx-manager
  smart-gateway
  smart-auth
  smart-server/smart-server-job
  smart-server/smart-server-generator
  smart-server/smart-server-system
)

# 镜像仓库名
register_names=(
  all
  smart-admin
  smart-tx-manager
  smart-gateway
  smart-auth
  smart-server-job
  smart-server-generator
  smart-server-system
)

# 镜像版本由 init 生成，如：smart-auth-server:1.0.0-SNAPSHOT
image_tags=(
  all
)

# 定义环境和镜像 tag 后缀映射
declare -A image_tag_suffix_map=(["development"]="DEV" ["testing"]="SNAPSHOT" ["production"]="RELEASE")
# declare -A maven_profile_map=(["development"]="dev" ["testing"]="test" ["production"]="prod")
# 暂时处理，选择开发环境使用测试环境构建
declare -A maven_profile_map=(["development"]="test" ["testing"]="test" ["production"]="prod")

# 脚本执行工作路径
work_path=$(
  cd "$(dirname "$0")";
  pwd
)

# 项目根目录
project_root_path=$(
  cd $work_path;
  cd ..;
  pwd
)

# docker 镜像仓库地址
docker_registry_uri="registry-vpc.cn-beijing.aliyuncs.com/leo"
#docker_registry_uri="registry.cn-beijing.aliyuncs.com/leo"
docker_file_path="${work_path}/Dockerfile"

init() {

	# 截取字符 10:aid-abc -> 10
	project_id=${project_id%%:*}

	# 映射 maven 环境
	maven_profile="${maven_profile_map[$profile_name]}"

	# 根据环境映射镜像tag
  for ((i = 1; i < ${#register_names[@]}; i++)); do
    ImageTag=${project_version}
    image_tags[$i]="${ImageTag}-${image_tag_suffix_map[$profile_name]}"
  done
}

error() {
  echo -e "\n$red 输入错误！$none\n"
  exit 1
}

pause() {
  read -rsp "$(echo -e "按${green} Enter 回车键 ${none}继续...或按${red} Ctrl + C ${none}取消.")" -d $'\n'
  echo
}

show_projects() {
  for ((i = 1; i <= ${#register_names[*]}; i++)); do
    Item="${register_names[$i - 1]}"
    if [[ "$i" -le 9 ]]; then
      # echo
      echo -e "$yellow  $i. $none${Item}"
    else
      # echo
      echo -e "$yellow $i. $none${Item}"
    fi
  done
}

show_deploy_projects() {
  for ((i = 1; i <= ${#image_tags[*]} - 1; i++)); do
    ItemTag="${image_tags[$i]}"
    ItemName="${register_names[$i]}"
    echo -e "$cyan ${docker_registry_uri}/${ItemName}:${ItemTag}$none"
  done
}

show_confirm_deploy() {
  echo "=============================="
  echo -e "$yellow 即将部署 $none"
  echo
  if test $project_id -eq 1; then
    show_deploy_projects
  else
    echo -e "$cyan ${docker_registry_uri}/${register_names[project_id - 1]}:${image_tags[$project_id - 1]}$none"
  fi
  echo
  echo "=============================="

#  # 提示
#  pause
#
  # 部署
  deploy
}

deploy() {

  # 部署所有项目
  if test $project_id -eq 1; then
		# 构建所有模块
#		mvn clean install -Dmaven.test.skip=true -P${maven_profile}
		mvn clean install -Dmaven.test.skip=true

    for ((i = 1; i <= ${#image_tags[*]} - 1; i++)); do
      ItemTag="${image_tags[$i]}"
      ItemName="${register_names[$i]}"
      RegisterName="${register_names[$i]}"
      ProjectPath=${project_root_path}/${modules_path[$i]}

      # 构建 docker 镜像并推送到镜像仓库
      docker build -t "${docker_registry_uri}/${RegisterName}:${ItemTag}" -f ${docker_file_path} ${ProjectPath}
      docker push "${docker_registry_uri}/${RegisterName}:${ItemTag}"

    done
  else

    # 部署选择的项目
    ItemTag="${image_tags[$project_id - 1]}"
    ItemName="${register_names[project_id - 1]}"
    RegisterName="${register_names[project_id - 1]}"
		ProjectPath=${project_root_path}/${modules_path[project_id - 1]}

		# 构建指定模块
#		mvn clean install -Dmaven.test.skip=true -pl :${RegisterName} -am -P${maven_profile}
		mvn clean install -Dmaven.test.skip=true -pl :${RegisterName} -am

    # 构建 docker 镜像并推送到镜像仓库
    docker build -t "${docker_registry_uri}/${RegisterName}:${ItemTag}" -f ${docker_file_path} ${ProjectPath}
    docker push "${docker_registry_uri}/${RegisterName}:${ItemTag}"
  fi
  echo
  echo -e "${green}===============部署成功===============${none}"
  echo
}

run() {

  # clear
  echo
  while :; do
    echo -e "请选择要部署的项目 [${magenta}1-${#register_names[*]}$none]"
    echo

    # 显示所有项目
    show_projects

    # 读取用户输入
    # read -p "$(echo -e "(默认: ${cyan}all$none)"):" project_id

    pwd

    # project_id=1

    case $project_id in
    [1-9]|1[0-9])
      echo
      echo -e "$yellow 已选择 $cyan${register_names[$project_id - 1]}$none"
      break
      ;;
    *)
      error
      ;;
    esac
  done

  # 显示确认部署信息
  show_confirm_deploy
}

usage() {
  echo -e "$red Usage:`basename $0` -p [Project ID] -e [development | testing | production] -v [Build Version]$none"
  echo -e "$red `basename $0` -p 1:xxx -e testing -v 1.0.0 $none"

  show_projects

  exit 1
}

# 获取输入参数
while getopts "hp:e:v:" opt; do
  case $opt in
  h)
    usage
    ;;
  p)
    project_id=$OPTARG
    ;;
  e)
    profile_name=$OPTARG
    ;;
  v)
    project_version=$OPTARG
    ;;
  ?)
    usage
    ;;
  esac
done

# 检查输入参数
echo $*
if [ $# == 0 ]; then
  usage
fi

if [[ -z $project_id || -z $profile_name ]]; then
  usage
fi

# 进入工作目录
cd $work_path

# 初始化
init

# 开始执行
run
