#!/bin/bash
#
# 解决迭代升级遗留的历史bug。
# 适用于 Mac OS。
#
# 注意事项：
# 1. 每次运行 npm install，都要执行这个脚本。
# Made by Leo
#

#work_path=$(dirname $(greadlink -f "$0"))
work_path=$(cd "$(dirname "$0")"; pwd)
nm_path=$(cd "$work_path"; cd ../node_modules; pwd)


# 解决 ios TextInput 不能输入中文bug
cp -f "$work_path/lib/RCTBaseTextInputShadowView.m" "$nm_path/react-native/Libraries/Text/TextInput/"
cp -f "$work_path/lib/RCTBaseTextInputView.m" "$nm_path/react-native/Libraries/Text/TextInput/"


# 解决 发布包闪退 undefined is not an object (evaluating 'o.View.propTypes.style')
# sed -i "" "2s/^[^#]/#&/" $work_path/aa.txt

#注释掉_DEV_的判断
sed -i "" "71s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native/Libraries/Components/View/View.js
sed -i "" "83s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native/Libraries/Components/View/View.js
sed -i "" "86s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native/Libraries/Components/View/View.js
sed -i "" "88s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native/Libraries/Components/View/View.js


# [android] 错误: 方法不会覆盖或实现超类型的方法

sed -i "" "25s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native-contacts/android/src/main/java/com/rt2zz/reactnativecontacts/ReactNativeContacts.java
sed -i "" "19s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native-permissions/android/src/main/java/com/joshblour/reactnativepermissions/ReactNativePermissionsPackage.java
sed -i "" "26s/^[^\\/\\/]/\\/\\/&/" $nm_path/react-native-vector-icons/android/src/main/java/com/oblador/vectoricons/VectorIconsPackage.java
sed -i "" "21s/^[^\\/\\/]/\\/\\/&/" $nm_path/@remobile/react-native-toast/android/src/main/java/com/remobile/toast/RCTToastPackage.java


# Unable to resolve module xxx react-addons-pure-render-mixin
rapr_folder=$nm_path/react-native-router-flux/node_modules/react-addons-pure-render-mixin

if [ -d $rapr_folder ]
then
    rm -r $rapr_folder
fi


echo fixed issues
