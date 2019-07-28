work_path=$(cd "$(dirname "$0")"; pwd)
project_path=$(cd "$work_path"; cd ../; pwd)

# npm run build:stage
npm run build:prod


docker build -t registry.cn-hangzhou.aliyuncs.com/xx/xx:latest-staging -f $project_path/Dockerfile .
docker push registry.cn-hangzhou.aliyuncs.com/xx/xx:latest-staging
