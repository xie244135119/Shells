#!/bin/sh
#  蒲公英上传插件
#  uploadpgy.sh
#  TestXcodeBuild
#
#  Created by SunSet on 2017/11/1.
#  Copyright © 2017年 SunSet. All rights reserved.

# 使用说明
# 参数 p: ipa文件地址  c: 模式 Debug or Release
# example:  uploadpgy.sh -p [*.ipa]


ipa_path=""
#Debug Release
build_config="Debug"

# warning 这块可变更为自己的
#API调用方身份
_api_key=""
if [[ $_api_key == "" ]]; then
    echo "请配置蒲公英账号的ApiKey"
    exit
fi

#获取参数中的Target
param_pattern=":p:nc:ws:"
while getopts $param_pattern optname
do
case "$optname" in
"p")
tmp_optname=$optname
ipa_path=$OPTARG
;;
"c")
tmp_optname=$optname
build_config=$OPTARG
;;
"?")
echo "Error! Unknown option $OPTARG"
exit 2
;;
":")
echo "Error! No argument value for option $OPTARG"
exit 2
;;
*)
# Should not occur
echo "Error! Unknown error while processing options"
exit 2
;;
esac
done


#得到当前ipa文件夹的目录
ipa_dir=${ipa_path%/*}
# ipa=${ipa_path##*/}
#解压到指定文件夹
temp_path=$ipa_dir/uploadpgy_temp
#删除目录

mkdir $temp_path
unzip -q $ipa_path -d $temp_path
#查找 .app文件地址
app_path=$(find $temp_path -name *.app)


#info plist
infoplist_path=$app_path/Info.plist
#取build版本号值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${infoplist_path})
rm -rf $temp_path

#安装方式1：公开，2：密码安装，3：邀请安装。默认为1公开
installType=1
#password="123456"
#版本更新内容
updateDescription="$build_config 发布版本:V${bundleVersion}"
#内容
filepath=$ipa_path

#自动上传
curl -F "file=@${filepath}" -F "_api_key=${_api_key}" -F "buildInstallType=${installType}" -F "buildUpdateDescription=${updateDescription}" https://qiniu-storage.pgyer.com/apiv2/app/upload





