#!/bin/sh

#  xcodebuild.sh
#  FrameWork
#
#  Created by SunSet on 16/10/14.
#  Copyright © 2016年 SunSet. All rights reserved.


#  1.0版本 xcodebuild.sh -p <Target名称> -c <Debug or Release>
#  2.0版本<融合xworkspace> 命令不变
#


#工程绝对路径
#cd $1
project_path=$(pwd)
#build文件夹路径
build_path=${project_path}/build
#最后ipa地址
ipa_path=${project_path}/build/ipa-build

#工程配置文件路径
#project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
#编译的Target
#build_target=$project_name

workspace_name=$(ls | grep xcworkspace | awk -F.xcworkspace '{print $1}')
build_workspace=${workspace_name}.xcworkspace

#编译的configuration，默认为Release
build_config=Debug
#编译的Scheme 默认
build_scheme=$workspace_name;
#编译的选项 使用自己的账号为xq<默认为dev>
build_account=dev

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
"c")
tmp_optname=$optname
tmp_optarg=$OPTARG
build_config=$tmp_optarg
;;
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

# OPTIND=$OPTIND-1
# if getopts $param_pattern optname ;then
# echo  "Error argument value for option $tmp_optname"
# exit 2
# fi
# # OPTIND=$tmp_optind

# build_target=$tmp_optarg
# ;;
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
exportpath=$ipa_path
archivepath=${project_path}/build/$build_config-iphoneos/$build_scheme.xcarchive
xcodebuild archive -workspace $build_workspace  -scheme $build_scheme  -configuration $build_config  -archivePath $archivepath
if [[ $? != 0 ]]; then
	#有错误直接退出
	exit
fi

##不同的文件采用不同的配置文件
# 配置账号信息
exportplst='AdHocExportOptions.plist'

exportplstpath=${project_path}/build_shell/$exportplst
xcodebuild -exportArchive -archivePath $archivepath -exportPath $exportpath -exportOptionsPlist $exportplstpath
if [[ $? != 0 ]]; then
	#有错误直接退出
	exit
fi
####

echo "ipa文件地址: $ipa_path/$build_scheme.ipa"



