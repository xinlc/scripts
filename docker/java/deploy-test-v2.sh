#!/bin/bash
##
## 测试环境部署脚本
##
## Started on 2019/10/28 Leo <xinlichao2016@gmail.com>
## Last update 2019/10/28 Leo <xinlichao2016@gmail.com>
##

version="1.0.0"

# Colours
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
magenta="\033[95m"
cyan="\033[96m"
none="\033[0m"

# 项目名
project_names=(
  all
  project-purchaser
  project-supplier
  project-audit
  project-job
  auth-svc
  gateway
  project-crm
	order-svc
)

# 项目相对路径
project_path=(
  all
  project-purchaser
  project-supplier
  project-audit
  project-job
  auth/auth-svc
  gateway
  project-crm
  order/order-svc
)

# 镜像仓库名
register_names=(
  all
  project-purchaser-server
  project-supplier-server
  project-audit-server
  project-job-server
  project-auth-svc
  project-gateway
  project-crm-server
  project-order-svc
)

# 项目版本，最后生成项目名+版本，如：project-purchaser-server:0.0.1-SNAPSHOT
# 版本和项目名顺序一一对应
image_tags=(
  all
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
  1.0.0-SNAPSHOT
)

# 脚本执行工作路径
work_path=$(
  cd "$(dirname "$0")"
  pwd
)
# docker 镜像仓库地址
docker_registry_uri="registry.cn-chengdu.aliyuncs.com/demo"

error() {
  echo -e "\n$red 输入错误！$none\n"
  exit 1
}

pause() {
  read -rsp "$(echo -e "按${green} Enter 回车键 ${none}继续...或按${red} Ctrl + C ${none}取消.")" -d $'\n'
  echo
}

show_projects() {
  for ((i = 1; i <= ${#project_names[*]}; i++)); do
    Item="${project_names[$i - 1]}"
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
    ItemName="${project_names[$i]}"
    echo -e "$cyan ${ItemName}-${ItemTag}$none"
  done
}

show_confirm_deploy() {
  echo "=============================="
  echo -e "$yellow 即将部署 $none"
  echo
  if test $project_id -eq 1; then
    show_deploy_projects
  else
    echo -e "$cyan ${project_names[project_id - 1]}-${image_tags[$project_id - 1]}$none"
  fi
  echo
  echo "=============================="

  # 提示
  pause

  # 部署
  deploy
}

deploy() {

  # 部署所有项目
  if test $project_id -eq 1; then
		# 构建测试包
		mvn clean install -Dmaven.test.skip=true -Ptest

    for ((i = 1; i <= ${#image_tags[*]} - 1; i++)); do
      ItemTag="${image_tags[$i]}"
      ItemName="${project_names[$i]}"
      RegisterName="${register_names[$i]}"
#      ProjectPath=${work_path}/${ItemName}
      ProjectPath=${work_path}/${project_path[$i]}

      # 构建 docker 镜像并推送到镜像仓库
      docker build -t "${docker_registry_uri}/${RegisterName}:${ItemTag}" -f "${ProjectPath}/Dockerfile" "${ProjectPath}"
      docker push "${docker_registry_uri}/${RegisterName}:${ItemTag}"

    done
  else

    # 部署选择的项目
    ItemTag="${image_tags[$project_id - 1]}"
    ItemName="${project_names[project_id - 1]}"
    RegisterName="${register_names[project_id - 1]}"
#    ProjectPath=${work_path}/${ItemName}
		ProjectPath=${work_path}/${project_path[project_id - 1]}

    # 构建指定模块
    mvn clean install -Dmaven.test.skip=true -pl :${RegisterName} -am -Ptest

    # 构建 docker 镜像并推送到镜像仓库
    docker build -t "${docker_registry_uri}/${RegisterName}:${ItemTag}" -f "${ProjectPath}/Dockerfile" "${ProjectPath}"
    docker push "${docker_registry_uri}/${RegisterName}:${ItemTag}"
  fi
  echo
  echo -e "${green}===============部署成功===============${none}"
  echo
}

run() {
  #  if test "$#" -ne 2; then
  #    echo '<Project Name | all> <test | prod>'
  #    exit 1
  #  fi

  # clear
  echo
  while :; do
    echo -e "请选择要部署的项目 [${magenta}1-${#project_names[*]}$none]"
    echo

    # 显示所有项目
    show_projects

    # 读取用户输入
    read -p "$(echo -e "(默认: ${cyan}all$none)"):" project_id

    [ -z "$project_id" ] && project_id=1

    case $project_id in
    [1-9])
      echo
      echo -e "$yellow 已选择 $cyan${project_names[$project_id - 1]}$none"
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

# 开始执行
run
