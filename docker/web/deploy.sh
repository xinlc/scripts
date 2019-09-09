work_path=$(
  cd "$(dirname "$0")"
  pwd
)
project_path=$(
  cd "$work_path"
  cd ../
  pwd
)

npm run build:prod

docker build -t registry.cn-qingdao.aliyuncs.com/xx/xx:latest -f $project_path/Dockerfile .
docker push registry.cn-qingdao.aliyuncs.com/xx/xx:latest
