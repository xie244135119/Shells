#!/bin/sh

#  appstore.sh
#  TestXcodeBuild
#
#  Created by SunSet on 2017/9/30.
#  Copyright © 2017年 SunSet. All rights reserved.


# 需要自己配置配置苹果账号信息
AppleID=''
AppleIDPWD=''

if [[ $AppleID == '' ]]; then
	echo 'Error! 请先苹果开发者账号'
	exit
fi

if [[ $AppleIDPWD == '' ]]; then
	echo 'Error! 请先苹果开发者账号'
	exit
fi


#工程绝对路径
#cd $1
project_path=$(pwd)
#build文件夹路径
build_path=${project_path}/build
#最后ipa地址
ipa_path=${project_path}/build/ipa-build


workspace_name=$(ls | grep xcworkspace | awk -F.xcworkspace '{print $1}')
build_workspace=${workspace_name}.xcworkspace

#编译的configuration，默认为Debug Release
build_config=Release
#编译的Scheme 默认
build_scheme=$workspace_name


#获取参数中的Target
param_pattern=":s:p:nc:o:t:a:ws:"
while getopts $param_pattern optname
do
case "$optname" in
"s")
tmp_optname=$optname
tmp_optarg=$OPTARG
build_scheme=$tmp_optarg
;;
"p")
tmp_optname=$optname
tmp_optarg=$OPTARG
#build_target=$tmp_optarg
build_scheme=$tmp_optarg
;;
# "c")
# tmp_optname=$optname
# tmp_optarg=$OPTARG
# build_config=$tmp_optarg
# ;;
"t")
# tmp_optind=$OPTIND
tmp_optname=$optname
tmp_optarg=$OPTARG
;;
"a")
# tmp_optind=$OPTIND
tmp_optname=$optname
build_account=$OPTARG
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


####-----V2.0版本-----
archivepath=${project_path}/build/$build_config-iphoneos/$build_scheme.xcarchive
xcodebuild archive -workspace $build_workspace  -scheme $build_scheme  -configuration $build_config  -archivePath $archivepath
if [[ $? != 0 ]]; then
	#有错误直接退出
	exit
fi

exportplstpath=${project_path}/build_shell/AppStoreExportOptions.plist
xcodebuild -exportArchive -archivePath $archivepath -exportPath $ipa_path -exportOptionsPlist $exportplstpath
if [[ $? != 0 ]]; then
	#有错误直接退出
	exit
fi
####


#ipa文件地址
ipa_filepath=$ipa_path/$build_scheme.ipa
#altool文件地址
altoolPath=/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool
# 验证App
"${altoolPath}" --validate-app -f ${ipa_filepath} -u ${AppleID} -p ${AppleIDPWD} -t ios
if [[ $? != 0 ]]; then
exit
fi
# 提交Appstore
"${altoolPath}" --upload-app -f ${ipa_filepath} -u ${AppleID} -p ${AppleIDPWD} -t ios --output-format xml





