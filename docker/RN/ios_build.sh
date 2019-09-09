#!/bin/bash
#
# IOS 上传
#

WORK_PATH=$(
  cd "$(dirname "$0")"
  pwd
)
PROJECT_PATH=$(
  cd "$WORK_PATH"
  cd ..
  pwd
)
BUILD_DATE=$(date +%Y%m%d)
PACKAGE_PATH=~/Downloads/app-archive
IOS_PACK_FOLDER=$(ls -t $PACKAGE_PATH | head -1)
IOS_PACK_FOLDER=$PACKAGE_PATH/${IOS_PACK_FOLDER/\:/}
BUILD_VERSION=$1
BUILD_DATE_INDEX=$2
BUILD_RELEASE=$3

if [ ! -d $PACKAGE_PATH ]; then
  echo "请将打好的ios包导出到${PACKAGE_PATH}下"
  exit 1
fi

# echo $IOS_PACK_FOLDER/xxx.ipa
echo $IOS_PACK_FOLDER/app-$BUILD_VERSION-$BUILD_DATE-$BUILD_DATE_INDEX-$BUILD_RELEASE.ipa

if test "$#" -ne 3; then
  echo '[version] [index] [test|release]'
  exit 1
fi

cp "$IOS_PACK_FOLDER/xxx.ipa" "$IOS_PACK_FOLDER/app-$BUILD_VERSION-$BUILD_DATE-$BUILD_DATE_INDEX-$BUILD_RELEASE.ipa"

if [ $3 == 'test' ]; then
  curl -F "file=@$IOS_PACK_FOLDER/app-$BUILD_VERSION-$BUILD_DATE-$BUILD_DATE_INDEX-$BUILD_RELEASE.ipa" -F "uKey=<key>" -F "_api_key=<key>" https://qiniu-storage.pgyer.com/apiv1/app/upload
  echo ""
  echo "Pgyer download: https://www.pgyer.com/xxx"

fi

if [ $3 == 'release' ]; then
  python3 $WORK_PATH/appUploadOss.py "$IOS_PACK_FOLDER/app-$BUILD_VERSION-$BUILD_DATE-$BUILD_DATE_INDEX-$BUILD_RELEASE.ipa" ios/$BUILD_RELEASE/app-$BUILD_VERSION-$BUILD_DATE-$BUILD_DATE_INDEX-$BUILD_RELEASE.ipa
  echo "Downloads link:  http://download.xxx.com/ios/$BUILD_RELEASE/app-$BUILD_VERSION-$BUILD_DATE-$BUILD_DATE_INDEX-$BUILD_RELEASE.ipa"
fi
