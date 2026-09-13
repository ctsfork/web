#!/usr/bin/env bash 

# 获取当前脚本的绝对路径，并进入目录
# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# cd "$SCRIPT_DIR"
# #
#



clear
echo "创建测试规则文件的软连接到桌面........"



ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/_conf/广告过滤-OverWrite.conf" "/Users/kimi/Desktop/"
ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/_conf/广告过滤-OverWrite.yaml" "/Users/kimi/Desktop/"




## rule-shadowrocket.list 规则文件内容和 KimiCustomAD.list 相同
# ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/output/rule-shadowrocket.list" "/Users/kimi/Desktop/"


ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/ads/KimiCustomAD.list" "/Users/kimi/Desktop/"
ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/ads/url-rewrite/KimiURLRule.list" "/Users/kimi/Desktop/"


ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/direct/KimiDirectDomains.list" "/Users/kimi/Desktop/"
ln -s "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/reject/KimiRejectDomains.list" "/Users/kimi/Desktop/"