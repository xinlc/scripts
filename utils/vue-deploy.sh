#!/bin/bash
##
## vue 测试环境部署脚本
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
  aid-supplier-web
  aid-portal-web
)

# 脚本执行工作路径
work_path=$(
  cd "$(dirname "$0")"
  pwd
)

error() {
  echo -e "\n$red 输入错误！$none\n"
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
  for ((i = 1; i <= ${#project_names[*]} - 1; i++)); do
    ItemName="${project_names[$i]}"
    echo -e "$cyan ${ItemName}$none"
  done
}

show_confirm_deploy() {
  echo "=============================="
  echo -e "$yellow 即将部署 $none"
  echo
  if test $project_id -eq 1; then
    show_deploy_projects
  else
    echo -e "$cyan ${project_names[project_id - 1]}$none"
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
    for ((i = 1; i <= ${#project_names[*]} - 1; i++)); do
      ItemName="${project_names[$i]}"
      ProjectPath=${work_path}/${ItemName}

      cd "$ProjectPath"
      bash scripts/deploy.sh
      cd ..

    done
  else

    # 部署选择的项目
    ItemName="${project_names[project_id - 1]}"
    ProjectPath=${work_path}/${ItemName}

    cd "$ProjectPath"
    bash scripts/deploy.sh
    cd ..
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
    [1-5])
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
