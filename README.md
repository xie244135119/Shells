# Shells
a group of common shell in the xcode 

For Example

* xcodebuild.sh (用于Xcode 自动编译的脚本)

|参数|说明|备注|
| ---- |:----:|:----:|
|p|Target名称||
|c|Debug 或 Release||

* appstore_build.sh (上传AppStore的脚本)

|参数|说明|备注|
| ---- |:----:|:----:|
|p|Target名称||


* codesign.sh  (用于App重签名的脚本)

|参数|说明|备注|
| ---- |:----:|:----:|
|i|待签名的ipa文件||
|c|使用的签名证书名称||
|m|使用的配置文件||

* upload_pgy.sh (上传蒲公英的脚本 可更改其中api_key)

|参数|说明|备注|
| ---- |:----:|:----:|
|p|ipa文件地址||
|c|Debug 或 Release||


######注
xcodebuild.sh 和 appstore_build.sh 使用前 需要进入到项目目录