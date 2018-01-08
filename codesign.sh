#!/bin/sh
	#App重签名处理
#  codesign.sh
#  TestXcodeBuild
#
#  Created by SunSet on 2017/11/1.
#  Copyright © 2017年 SunSet. All rights reserved.


# 项目目录
project_path=$(pwd)
# ipa
ipa_path=""
# 签名证书名称
certifice=""
# 签名配置文件
mobileprovision=""


#获取参数中的Target
#":i:c:nc:o:t:ws:"
param_pattern=":i:c:m:t:ws:"
while getopts $param_pattern optname
do
case "$optname" in
"i")
# tmp_optind=$OPTIND
tmp_optname=$optname
ipa_path=$OPTARG
;;
"c")    #证书名称
tmp_optname=$optname
certifice=$OPTARG
;;
"m")    #配置文件
tmp_optname=$optname
mobileprovision=$OPTARG
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


#判断基本条件
if [[ $ipa_path == '' ]]; then
	echo "Error! 请输入ipa"
	exit
fi

if [[ $certifice == '' ]]; then
	echo "Error! 请输入证书"
	exit
fi

if [[ $mobileprovision == '' ]]; then
	echo "Error! 请输入配置文件"
	exit
fi


#改变最后生成的ipa 目录地址为和原始ipa一个目录
project_path=${ipa_path%/*}

# 创建临时文件夹
tempdir=$project_path/Temp
#删除文件夹
rm -rf $tempdir
mkdir $tempdir

# ipa名称 取最后一段
ipa=${ipa_path##*/}
ipaname=${ipa%.*}

#解压文件
unzip -q $ipa_path -d $tempdir

#替换其中的配置文件
cp $mobileprovision $tempdir/Payload/${ipaname}.app/embedded.mobileprovision

#输出配置文件的所有文件
/usr/bin/security cms -D -i $mobileprovision > $tempdir/entitlements_full.plist
#输出相应的Entitlements 文件
/usr/libexec/PlistBuddy -x -c 'Print:Entitlements'  $tempdir/entitlements_full.plist > $tempdir/entitlements.plist

#执行签名操作
/usr/bin/codesign -f -s "${certifice}" --entitlements $tempdir/entitlements.plist $tempdir/Payload/${ipaname}.app 
if [[ $? != 0 ]]; then
	#有错误直接退出
	exit
fi

#验证签名
/usr/bin/codesign --verify $tempdir/Payload/$ipaname.app
if [[ $? != 0 ]]; then
	#有错误直接退出
	exit
fi


#生成ipa
cd $tempdir
zip -r $project_path/${ipaname}_new.ipa Payload

open $project_path
echo "制作好的app 地址为 $project_path/${ipaname}_new.ipa "








